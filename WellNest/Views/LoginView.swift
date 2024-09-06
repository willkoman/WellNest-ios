import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @EnvironmentObject var themeManager: ThemeManager  // Access the theme manager
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
                .background(themeManager.currentTheme.backgroundColor.opacity(0.2))
                .cornerRadius(5)
                .foregroundColor(themeManager.currentTheme.primaryTextColor)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal, 10)
            
            
            SecureField("Password", text: $password)
                .padding()
                .background(themeManager.currentTheme.backgroundColor.opacity(0.2))
                .cornerRadius(5)
                .foregroundColor(themeManager.currentTheme.primaryTextColor)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal, 10)
            
            Button(action: login) {
                Text("Login")
                    .padding()
                    .background(themeManager.currentTheme.buttonBackgroundColor)
                    .foregroundColor(themeManager.currentTheme.buttonTextColor)
                    .cornerRadius(5)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
    func login() {
        APIClient.shared.login(username: username.lowercased(), password: password) { result in
            switch result {
            case .success(let data):
                if let accessToken = data["access"] as? String,
                   let refreshToken = data["refresh"] as? String {
                    TokenService.shared.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                    viewModel.isAuthenticated = true
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}
