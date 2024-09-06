struct Profile: Identifiable, Decodable {
    var id: Int
    var username: String
    var bio: String
    var goals: String
    var image: String  // URL for the profile image
    var followers: [Int]
    var following: [Int]
    var followers_count: Int
    var following_count: Int
    var posts: [Int]
    var posts_count: Int
    var created_at: String
}


struct Post: Identifiable, Decodable {
    var id: Int
    var profile: Int  // Profile ID
    var content: String?
    var images: String?  // URL for the post image (optional)
    var created_at: String
    var liked: [Int]
}

