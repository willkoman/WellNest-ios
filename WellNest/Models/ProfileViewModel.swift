import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var profile: [String: Any] = [:]
    @Published var errorMessage: String = ""
    
    func loadProfile() {
        APIClient.shared.getProfile { result in
            switch result {
            case .success(let data):
                if let profileArray = data as? [[String: Any]], let profileData = profileArray.first {
                    DispatchQueue.main.async {
                        self.profile = profileData
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Unexpected data structure"
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                
                }
            }
        }
    }
}
