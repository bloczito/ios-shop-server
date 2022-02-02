import Vapor

@available(macOS 12.0, *)
struct UserAuthenticator: Vapor.AsyncBearerAuthenticator {
   
    func authenticate(bearer: BearerAuthorization, for request: Request) async throws {

        let url = URL(string: "https://dev-p-th9prq.us.auth0.com/userinfo")
        var req = URLRequest(url: url!)
        req.allHTTPHeaderFields = [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(bearer.token)"
        ]

        let (data, _) = try await URLSession.shared.data(for: req)
        
        let info = try JSONDecoder().decode(UserInfoDto.self, from: data)
        
        request.auth.login(User(id: info.sub))
    }
}
