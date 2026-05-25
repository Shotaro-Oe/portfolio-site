import SwiftUI

@main
struct CameraChecklistApp: App {
    @StateObject private var store = ChecklistStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
