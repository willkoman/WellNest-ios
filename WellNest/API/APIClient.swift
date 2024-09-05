import Alamofire

class APIClient {
    static let shared = APIClient()
    private let baseURL = "http://127.0.0.1:8000/api/"

    // Function to login and retrieve JWT tokens
    func login(username: String, password: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = baseURL + "token/"
        let parameters = ["username": username, "password": password]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let json = data as? [String: Any] {
                        completion(.success(json))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    // Fetch user profile data
    func getProfile(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = baseURL + "profiles/"
        guard let token = TokenService.shared.getAccessToken() else { return }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let json = data as? [String: Any] {
                        completion(.success(json))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
