import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: AppViewModel  // ObservableObject to track profile data
    @State private var isEditing = false
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var fetchedImage: UIImage?  // Store fetched image if downloaded manually
    
    var body: some View {
        VStack {
            if let profile = viewModel.profile {
                VStack(spacing: 16) {
                    // Profile Image
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
                    
                    // Username
                    Text(profile.username)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    // Editable Bio Section
                    VStack(spacing: 8) {
                        Text("Bio")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        if isEditing {
                            TextField("Enter bio", text: Binding(
                                get: { viewModel.profile?.bio ?? "" },
                                set: { viewModel.profile?.bio = $0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        } else {
                            Text(profile.bio)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .padding(.horizontal)
                        }
                    }
                    
                    // Editable Goals Section
                    VStack(spacing: 8) {
                        Text("Goals")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        if isEditing {
                            TextField("Enter goals", text: Binding(
                                get: { viewModel.profile?.goals ?? "" },
                                set: { viewModel.profile?.goals = $0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        } else {
                            Text(profile.goals)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .padding(.horizontal)
                        }
                    }
                    
                    // Image Picker Button
                    if isEditing {
                        Button("Change Profile Picture") {
                            showImagePicker = true
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    // Save Button
                    if isEditing {
                        Button("Save") {
                            viewModel.updateProfile(with: selectedImage)  // Pass selectedImage to the update method
                            isEditing = false
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    } else {
                        Button("Edit Profile") {
                            isEditing = true
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    // Logout Button
                    Button(action: {
                        viewModel.logout()  // Call logout to reset the auth state
                    }) {
                        Text("Logout")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
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
        .onAppear {
            viewModel.loadProfile()
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
