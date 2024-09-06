import SwiftUI

struct FeedView: View {
    @ObservedObject var feedViewModel = FeedViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if feedViewModel.errorMessage.isEmpty {
                        ForEach(feedViewModel.posts) { post in
                            // Fetch and display the post along with the associated profile
                            if let profile = feedViewModel.profiles[post.profile] {
                                PostView(post: post, profile: profile)  // Pass both the post and profile
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                            } else {
                                ProgressView()  // Show loading indicator while fetching profile
                            }
                        }
                    } else {
                        Text(feedViewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Feed")
            .onAppear {
                feedViewModel.loadPosts()  // Load posts when the view appears
            }
            .refreshable {
                feedViewModel.loadPosts()  // Pull to refresh
            }
        }
    }
}
