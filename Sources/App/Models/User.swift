import Vapor
import Fluent

final class User: Authenticatable {
    
    var id: String
    
    init(id: String) {
        self.id = id
    }
}
