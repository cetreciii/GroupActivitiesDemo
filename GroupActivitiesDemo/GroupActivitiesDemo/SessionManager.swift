import Foundation
import GroupActivities
import SwiftUI

/// The `GroupActivity` protocol defines the metadata for the SharePlay session.
struct CubeActivity: GroupActivity {
    static let activityIdentifier = "com.demo.groupactivities.cube"

    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = "Collaborative Red Cube"
        metadata.subtitle = "Manipulate the cube together!"
        metadata.type = .generic
        return metadata
    }
}

/// A Codable struct to represent the cube's transform (position, rotation, scale).
struct CubeState: Codable {
    var position: SIMD3<Float>
    var rotation: SIMD4<Float>
    var scale: SIMD3<Float>
}

@Observable
class SessionManager {
    /// The active GroupSession.
    var session: GroupSession<CubeActivity>?
    
    /// The messenger used to send/receive data.
    var messenger: GroupSessionMessenger?
    
    /// Current state of the cube, synced across participants.
    var cubeState = CubeState(
        position: [0, 1.5, -2], // Initial position: 1.5m high, 2m in front
        rotation: [0, 0, 0, 1], // Identity quaternion
        scale: [0.3, 0.3, 0.3]
    )
    
    /// Tasks to manage the session lifecycle.
    private var tasks = Set<Task<Void, Never>>()

    /// Call this to start/activate the activity.
    func startSharing() {
        Task {
            do {
                _ = try await CubeActivity().activate()
            } catch {
                print("Failed to activate activity: \(error)")
            }
        }
    }

    /// Listen for incoming sessions.
    func configureSessionListener() {
        Task {
            for await session in CubeActivity.sessions() {
                self.configureSession(session)
            }
        }
    }

    private func configureSession(_ session: GroupSession<CubeActivity>) {
        self.session = session
        let messenger = GroupSessionMessenger(session: session)
        self.messenger = messenger
        
        // Handle incoming data
        let task = Task {
            for await (state, _) in messenger.messages(of: CubeState.self) {
                // Apply the received state to the local model
                await MainActor.run {
                    self.cubeState = state
                }
            }
        }
        tasks.insert(task)
        
        session.join()
    }
    
    /// Send the local state to all participants.
    func broadcastState(_ state: CubeState) {
        self.cubeState = state
        Task {
            do {
                try await messenger?.send(state)
            } catch {
                print("Failed to send state: \(error)")
            }
        }
    }
}

// MARK: - Educational Helpers
extension simd_quatf {
    /// Creates a single-precision quaternion from a double-precision one (standard for visionOS gestures).
    init(_ dQuat: simd_quatd) {
        self.init(ix: Float(dQuat.vector.x), iy: Float(dQuat.vector.y), iz: Float(dQuat.vector.z), r: Float(dQuat.vector.w))
    }
}
