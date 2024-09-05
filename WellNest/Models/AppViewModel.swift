import SwiftUI

class AppViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false  // Tracks if the user is logged in
    
    func checkAuthentication() {
        // Example: Check if a valid token exists
        if let _ = TokenService.shared.getAccessToken() {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
    
    func logout() {
        TokenService.shared.clearTokens()
        isAuthenticated = false
    }
}

struct RootView: View {
    @StateObject var viewModel = AppViewModel()
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                ProfileView(viewModel: viewModel)  // Pass the viewModel to allow logout
            } else {
                LoginView(viewModel: viewModel)    // Pass the viewModel to trigger login
            }
        }
        .onAppear {
            viewModel.checkAuthentication()  // Check authentication when the view appears
        }
    }
}
