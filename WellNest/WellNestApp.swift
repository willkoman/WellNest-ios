import SwiftUI

@main
struct WellNestApp: App {
    @StateObject var themeManager = ThemeManager()  // Global theme manager
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(themeManager)  // Inject the theme manager into the environment
        }
    }
}
