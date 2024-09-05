import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            
            Button(action: login) {
                Text("Login")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
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
                    // Navigate to profile view
                    viewModel.isAuthenticated = true
                    
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}
