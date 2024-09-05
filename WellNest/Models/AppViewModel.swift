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
        let url = baseURL + "profiles/"
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [Profile].self) { response in
                switch response.result {
                case .success(let profiles):
                    if let profile = profiles.first {
                        DispatchQueue.main.async {
                            self.profile = profile
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "No profile data found"
                        }
                    }
                case .failure(let error):
                    if let statusCode = response.response?.statusCode, statusCode == 401 {
                        // Token is invalid or expired, log out and return to login screen
                        DispatchQueue.main.async {
                            self.logout()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed to load profile: \(error.localizedDescription)"
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
        
        let profileID = profile.id
        let url = baseURL + "profiles/\(profileID)/"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        var profileData: [String: Any] = [
            "bio": profile.bio,
            "goals": profile.goals
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
    
    func logout() {
        TokenService.shared.clearTokens()
        isAuthenticated = false
        profile = nil
    }
    
    func checkAuthentication() {
        if let _ = TokenService.shared.getAccessToken() {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
    
}

struct RootView: View {
    @StateObject var viewModel = AppViewModel()  // Create the AppViewModel
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                ProfileView(viewModel: viewModel)  // Pass the viewModel to ProfileView
            } else {
                LoginView(viewModel: viewModel)    // Pass the viewModel to LoginView
            }
        }
        .onAppear {
            viewModel.checkAuthentication()  // Check authentication when the view appears
        }
    }
}

