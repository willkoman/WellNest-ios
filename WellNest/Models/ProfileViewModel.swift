import SwiftUI
import Alamofire

class ProfileViewModel: ObservableObject {
    @Published var profile: Profile?  // Profile to be displayed
    @Published var errorMessage: String = ""
    
    private let baseURL = "http://127.0.0.1:8000/api/"  // Replace with your backend URL
    
    func loadProfile(profileID: Int) {
        guard let token = TokenService.shared.getAccessToken() else {
            errorMessage = "No access token found"
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let url = baseURL + "profiles/\(profileID)/"  // Fetch the profile by ID
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: Profile.self) { response in
                switch response.result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        self.profile = profile
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to load profile: \(error.localizedDescription)"
                    }
                }
            }
    }
}
