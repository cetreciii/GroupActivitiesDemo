import SwiftUI

@main
struct GroupActivitiesDemoApp: App {
    // 1. Initialize our SessionManager
    @State private var sessionManager = SessionManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(sessionManager)
                .onAppear {
                    // 2. Start listening for incoming GroupSessions
                    sessionManager.configureSessionListener()
                }
        }
        .windowStyle(.plain)

        // 3. Define our Immersive Space
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(sessionManager)
        }
    }
}
