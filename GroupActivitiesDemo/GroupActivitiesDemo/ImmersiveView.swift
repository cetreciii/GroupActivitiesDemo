import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @Environment(SessionManager.self) private var sessionManager
    @State private var cubeEntity: Entity?

    // 1. Grouped Gesture State (Lighter and more organized)
    struct Interaction {
        var dragOffset: SIMD3<Float>?
        var startOrientation: simd_quatf?
        var startScale: SIMD3<Float>?
    }
    @State private var activeInteraction = Interaction()

    var body: some View {
        RealityView { content in
            let entity = createRedCube()
            content.add(entity)
            self.cubeEntity = entity
        } update: { _ in
            syncCubeWithSession()
        }
        .gesture(allGestures)
    }

    // MARK: - Gestures
    private var allGestures: some Gesture {
        DragGesture().targetedToAnyEntity().onChanged { value in
            let currentGrabPoint = value.convert(value.location3D, from: .local, to: .scene)
            
            if activeInteraction.dragOffset == nil {
                activeInteraction.dragOffset = value.entity.position - currentGrabPoint
            }
            
            if let offset = activeInteraction.dragOffset {
                value.entity.position = currentGrabPoint + offset
                broadcast(value.entity)
            }
        }.onEnded { _ in activeInteraction.dragOffset = nil }
        
        .simultaneously(with: RotateGesture3D().targetedToAnyEntity().onChanged { value in
            if activeInteraction.startOrientation == nil {
                activeInteraction.startOrientation = value.entity.orientation
            }
            
            if let start = activeInteraction.startOrientation {
                // 1. Get the raw quaternion from the gesture
                let q = value.rotation.quaternion
                
                // 2. EXPOSE COMPONENTS FOR MODIFICATION
                // Mirroring Y and W components as requested
                let rotationDelta = simd_quatf(
                    ix: Float(q.vector.x),
                    iy: -Float(q.vector.y),
                    iz: Float(q.vector.z),
                    r: -Float(q.vector.w)
                )
                
                value.entity.orientation = rotationDelta * start
                broadcast(value.entity)
            }
        }.onEnded { _ in activeInteraction.startOrientation = nil })
        
        .simultaneously(with: MagnifyGesture().targetedToAnyEntity().onChanged { value in
            if activeInteraction.startScale == nil {
                activeInteraction.startScale = value.entity.scale
            }
            
            if let start = activeInteraction.startScale {
                value.entity.scale = start * Float(value.magnification)
                broadcast(value.entity)
            }
        }.onEnded { _ in activeInteraction.startScale = nil })
    }

    // MARK: - Helpers
    private func createRedCube() -> Entity {
        let mesh = MeshResource.generateBox(size: 1.0)
        let material = SimpleMaterial(color: .red, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        entity.position = sessionManager.cubeState.position
        entity.orientation = simd_quatf(vector: sessionManager.cubeState.rotation)
        entity.scale = sessionManager.cubeState.scale
        
        entity.generateCollisionShapes(recursive: false)
        entity.components.set(InputTargetComponent())
        return entity
    }

    private func syncCubeWithSession() {
        guard let entity = cubeEntity else { return }
        entity.position = sessionManager.cubeState.position
        entity.orientation = simd_quatf(vector: sessionManager.cubeState.rotation)
        entity.scale = sessionManager.cubeState.scale
    }

    private func broadcast(_ entity: Entity) {
        sessionManager.broadcastState(CubeState(
            position: entity.position,
            rotation: entity.orientation.vector,
            scale: entity.scale
        ))
    }
}
