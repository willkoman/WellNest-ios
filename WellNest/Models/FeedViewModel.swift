import SwiftUI
import Alamofire

class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var profiles: [Int: Profile] = [:]  // Cache profiles by profile ID
    @Published var errorMessage: String = ""
    
    private let baseURL = "http://127.0.0.1:8000/api/"
    
    func loadPosts() {
        guard let token = TokenService.shared.getAccessToken() else {
            errorMessage = "No access token found"
            return
        }
        
        let url = baseURL + "posts/"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [Post].self) { response in
                switch response.result {
                case .success(let posts):
                    DispatchQueue.main.async {
                        self.posts = posts.sorted { $0.created_at > $1.created_at }
                        self.loadProfiles(for: posts)  // Fetch profiles for posts
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to load posts: \(error.localizedDescription)"
                    }
                }
            }
    }
    
    // Fetch profiles for each post and cache them
    private func loadProfiles(for posts: [Post]) {
        let profileIDs = posts.map { $0.profile }
        
        for profileID in profileIDs {
            if profiles[profileID] == nil {
                fetchProfile(profileID: profileID)
            }
        }
    }
    
    // Fetch and cache profile by ID
    private func fetchProfile(profileID: Int) {
        guard let token = TokenService.shared.getAccessToken() else {
            errorMessage = "No access token found"
            return
        }
        
        let url = baseURL + "profiles/\(profileID)/"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: Profile.self) { response in
                switch response.result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        print(response)
                        self.profiles[profileID] = profile  // Cache the profile with the correct ID
                        print("Fetched Profile ID: \(profileID), Username: \(profile.username)")  // Add this debugging line
                    }
                case .failure(let error):
                    print(response)
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to load profile: \(error.localizedDescription)"
                    }
                }
            }
    }

}
