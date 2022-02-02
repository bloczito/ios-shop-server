import Fluent
import Vapor


final class Shop: Model, Content {
    static let schema = "shop"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "address")
    var address: String
    
    @Field(key: "latitude")
    var latitude: Double
    
    @Field(key: "longtitude")
    var longtitude: Double
    
    init() {}
    
    init(id: UUID? = nil, title: String, address: String, latitude: Double, longtitude: Double) {
        self.id = id
        self.address = address
        self.latitude = latitude
        self.longtitude = longtitude
    }
}
