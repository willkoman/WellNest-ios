struct Profile: Identifiable, Decodable {
    var id: Int
    var username: String
    var bio: String
    var goals: String
    var image: String  // URL for the profile image
}
