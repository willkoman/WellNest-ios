import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: AppViewModel  // ObservableObject to track profile data for the logged-in user
    var profile: Profile?  // Optional profile for other users
    
    @State private var isEditing = false
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var fetchedImage: UIImage?  // Store fetched image if downloaded manually
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        let displayProfile = profile ?? viewModel.profile  // Use passed profile or default to logged-in user's profile
        
        VStack {
            if let profile = displayProfile {
                VStack(spacing: 16) {
                    // Profile Header Layout (Instagram-style)
                    ZStack {
                        HStack {
                            // Posts and Joined section
                            VStack {
                                Text("Posts")
                                    .font(.headline)
                                    .foregroundColor(themeManager.currentTheme.primaryTextColor)
                                Text(String(profile.posts_count))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(themeManager.currentTheme.primaryTextColor)
                                
                                Text("Joined")
                                    .font(.caption)
                                    .foregroundColor(themeManager.currentTheme.secondaryTextColor)
                                Text(convertToEnglishFormat(date: profile.created_at))
                                    .font(.caption)
                                    .foregroundColor(themeManager.currentTheme.secondaryTextColor)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: 80)
                            Spacer()
                            
                            // Followers and Following section
                            VStack {
                                Text("Followers")
                                    .font(.headline)
                                    .foregroundColor(themeManager.currentTheme.primaryTextColor)
                                Text(String(profile.followers_count))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(themeManager.currentTheme.primaryTextColor)
                                
                                Text("Following")
                                    .font(.headline)
                                    .foregroundColor(themeManager.currentTheme.primaryTextColor)
                                Text(String(profile.following_count))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(themeManager.currentTheme.primaryTextColor)
                            }
                        }
                        
                        // Center Section: Profile Picture
                        if isEditing && profile.id == viewModel.profile?.id {
                            Button(action: {
                                showImagePicker = true  // Open image picker when tapped
                            }) {
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                        .shadow(radius: 10)
                                } else if let fetchedImage = fetchedImage {
                                    Image(uiImage: fetchedImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                        .shadow(radius: 10)
                                } else if let url = URL(string: profile.image) {
                                    ProgressView()
                                        .onAppear {
                                            fetchImage(from: url)
                                        }
                                }
                            }
                        } else {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                    .shadow(radius: 10)
                            } else if let fetchedImage = fetchedImage {
                                Image(uiImage: fetchedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                    .shadow(radius: 10)
                            } else if let url = URL(string: profile.image) {
                                ProgressView()
                                    .onAppear {
                                        fetchImage(from: url)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Username
                    Text(profile.username)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.currentTheme.primaryTextColor)
                    
                    // Editable Bio Section
                    VStack(spacing: 8) {
                        Text("Bio")
                            .font(.headline)
                            .foregroundColor(themeManager.currentTheme.secondaryTextColor)
                        
                        if isEditing {
                            TextField("Enter bio", text: Binding(
                                get: { viewModel.profile?.bio ?? "" },
                                set: { viewModel.profile?.bio = $0 }
                            ),  axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(themeManager.currentTheme.backgroundColor.opacity(0.2))
                            .cornerRadius(10)
                            .lineLimit(3)
                            
                        } else {
                            Text(profile.bio)
                                .padding()
                                .background(themeManager.currentTheme.backgroundColor.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(themeManager.currentTheme.primaryTextColor)
                            
                        }
                    }
                    
                    // Editable Goals Section
                    VStack(spacing: 8) {
                        Text("Goals")
                            .font(.headline)
                            .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
                        
                        if isEditing {
                            TextField("Enter goals", text: Binding(
                                get: { viewModel.profile?.goals ?? "" },
                                set: { viewModel.profile?.goals = $0 }
                            ),  axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(themeManager.currentTheme.backgroundColor.opacity(0.2))
                            .cornerRadius(10)
                            .lineLimit(3)
                        } else {
                            Text(profile.goals)
                                .padding()
                                .background(themeManager.currentTheme.backgroundColor.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(themeManager.currentTheme.primaryTextColor)
                        }
                        
                    }
                    
                    Spacer()
                    
                    // Logout or Edit button if it's the logged-in user's profile
                    if profile.id == viewModel.profile?.id {
                        if isEditing {
                            Button("Save") {
                                viewModel.updateProfile(with: selectedImage)
                                isEditing = false
                            }
                            .padding()
                            .background(themeManager.currentTheme.buttonBackgroundColor)
                            .foregroundColor(themeManager.currentTheme.buttonTextColor)
                            .cornerRadius(10)
                        } else {
                            Button("Edit Profile") {
                                isEditing = true
                            }
                            .padding()
                            .background(themeManager.currentTheme.buttonBackgroundColor)
                            .foregroundColor(themeManager.currentTheme.buttonTextColor)
                            .cornerRadius(10)
                        }
                        
                        Button(action: { viewModel.logout() }) {
                            Text("Logout")
                                .padding()
                                .background(themeManager.currentTheme.buttonBackgroundColorSecondary)
                                .foregroundColor(themeManager.currentTheme.buttonTextColorSecondary)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.top, 10)
            } else if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
            } else {
                Text("No profile data available.")
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .padding()
    }
    
    // Function to manually fetch image from URL using URLSession
    func fetchImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load image: \(String(describing: error))")
                return
            }
            
            DispatchQueue.main.async {
                if let uiImage = UIImage(data: data) {
                    self.fetchedImage = uiImage  // Update state with fetched image
                } else {
                    print("Invalid image data")
                }
            }
        }.resume()
    }
}
