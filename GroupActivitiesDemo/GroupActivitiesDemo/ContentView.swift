import SwiftUI
import RealityKit
import GroupActivities

struct ContentView: View {
    @Environment(SessionManager.self) private var sessionManager
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    @State private var immersiveSpaceIsShown = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Collaborative Cube")
                .font(.extraLargeTitle)

            if let session = sessionManager.session {
                Text("SharePlay Active")
                    .foregroundColor(.green)
                    .font(.headline)
                
                Text("Participants: \(session.activeParticipants.count)")
            } else {
                Button(action: {
                    sessionManager.startSharing()
                }) {
                    Label("Start SharePlay", systemImage: "shareplay")
                }
                .buttonStyle(.borderedProminent)
            }

            Toggle(immersiveSpaceIsShown ? "Exit Immersive Space" : "Enter Immersive Space", isOn: $immersiveSpaceIsShown)
                .onChange(of: immersiveSpaceIsShown) { _, newValue in
                    Task {
                        if newValue {
                            await openImmersiveSpace(id: "ImmersiveSpace")
                        } else {
                            await dismissImmersiveSpace()
                        }
                    }
                }
                .toggleStyle(.button)
        }
        .padding()
        .glassBackgroundEffect()
    }
}

#Preview {
    ContentView()
        .environment(SessionManager())
}
