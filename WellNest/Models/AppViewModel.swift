import SwiftUI
import Alamofire

class AppViewModel: ObservableObject {
    @Published var profile: Profile?  // Holds the current profile data
    @Published var isAuthenticated: Bool = false  // Tracks authentication state
    @Published var errorMessage: String = ""  // Stores error messages
    
    private let baseURL = "http://127.0.0.1:8000/api/"  // Replace with your backend URL
    
    func loadProfile() {
        guard let token = TokenService.shared.getAccessToken() else {
            errorMessage = "No access token found"
            isAuthenticated = false
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let url = baseURL + "profiles/me/"  // Use the /me/ endpoint
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: Profile.self) { response in
                switch response.result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        self.profile = profile
                        self.isAuthenticated = true
                        print("Profile loaded successfully")
                    }
                case .failure(let error):
                    if let statusCode = response.response?.statusCode, statusCode == 401 {
                        print("Token expired, refreshing...")
                        self.refreshTokenAndLoadProfile()
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed to load profile: \(error.localizedDescription)"
                            self.isAuthenticated = false
                        }
                    }
                }
            }
    }
    
    func updateProfile(with image: UIImage?) {
        guard let profile = profile else { return }
        guard let token = TokenService.shared.getAccessToken() else {
            errorMessage = "No access token found"
            return
        }
        
        let url = baseURL + "profiles/me/"  // Update the current user's profile using /me/
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        let profileData: [String: Any] = [
            "bio": profile.bio,
            "goals": profile.goals,
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in profileData {
                multipartFormData.append(Data("\(value)".utf8), withName: key)
            }
            
            if let imageData = image?.jpegData(compressionQuality: 0.8) {
                let fileName = UUID().uuidString + ".jpg"
                multipartFormData.append(imageData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
            }
        }, to: url, method: .patch, headers: headers)
        .validate()
        .response { response in
            switch response.result {
            case .success:
                print("Profile successfully updated")
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to update profile: \(error.localizedDescription)"
                }
            }
        }
    }

    
    func refreshTokenAndLoadProfile() {
        guard let refreshToken = TokenService.shared.getRefreshToken() else {
            DispatchQueue.main.async {
                self.isAuthenticated = false
            }
            return
        }
        
        let url = baseURL + "token/refresh/"
        let parameters: [String: String] = ["refresh": refreshToken]
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: [String: String].self) { response in
                switch response.result {
                case .success(let data):
                    if let accessToken = data["access"] {
                        TokenService.shared.saveAccessToken(accessToken)
                        self.loadProfile()  // Retry loading the profile with the new access token
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to refresh token: \(error.localizedDescription)"
                        self.isAuthenticated = false
                    }
                }
            }
    }
    
    
    func logout() {
        TokenService.shared.clearTokens()
        isAuthenticated = false
        profile = nil
    }
    
    func checkAuthentication() {
        if let _ = TokenService.shared.getAccessToken() {
            // If access token is available, try loading the profile
            loadProfile()
        } else if let _ = TokenService.shared.getRefreshToken() {
            // If only refresh token is available, try refreshing access token
            refreshTokenAndLoadProfile()
        } else {
            // No tokens available, user needs to log in
            isAuthenticated = false
        }
    }
}

import SwiftUI

struct RootView: View {
    @StateObject var viewModel = AppViewModel()  // Initialize the AppViewModel
    @EnvironmentObject var themeManager: ThemeManager  // Access the theme manager
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                MainTabView(viewModel: viewModel)  // Navigate to the MainTabView
            } else {
                LoginView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.checkAuthentication()  // Check if the user is authenticated
        }
    }
}
