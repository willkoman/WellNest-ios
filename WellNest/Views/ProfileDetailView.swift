import SwiftUI

struct ProfileDetailView: View {
    @ObservedObject var profileViewModel = ProfileViewModel()  // ViewModel to load the specific profile
    let profileID: Int  // The profile ID to fetch
    
    var body: some View {
        VStack {
            if let profile = profileViewModel.profile {
                ProfileView(viewModel: AppViewModel(), profile: profile)  // Use ProfileView with fetched profile
            } else if !profileViewModel.errorMessage.isEmpty {
                Text(profileViewModel.errorMessage)
                    .foregroundColor(.red)
            } else {
                ProgressView("Loading Profile...")
            }
        }
        .onAppear {
            profileViewModel.loadProfile(profileID: profileID)
        }
        .navigationBarTitle("Profile", displayMode: .inline)
    }
}
