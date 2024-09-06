import SwiftUI

struct PostView: View {
    let post: Post
    let profile: Profile  // This is the profile of the post author
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // Profile Image as a tappable NavigationLink
                NavigationLink(destination: ProfileDetailView(profileID: profile.id)) {
                    if let profileImageURL = URL(string: profile.image) {
                        AsyncImage(url: profileImageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 50, height: 50)
                        }
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 50, height: 50)
                    }
                }
                .buttonStyle(PlainButtonStyle())  // Remove default button style
                
                // Username and Timestamp
                VStack(alignment: .leading) {
                    Text(profile.username)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(post.created_at)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Post Content
            Text(post.content ?? "")
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(nil)
            
            // Post Image (if available)
            if let postImageURL = post.images, let url = URL(string: postImageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
