import Fluent
import Vapor

final class Product: Model, Content {
    static let schema = "produkt"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "description")
    var description: String
    
    @Field(key: "image")
    var image:  String
    
    @Field(key: "quantity")
    var quantity:  UInt
    
    @Field(key: "price")
    var price:  Double
    
    @Parent(key: "kategoria_id")
    var category: Category
    
    @Children(for: \.$product)
    var cartItems: [CartItem]
    
    init() { }

    init(id: UUID? = nil, title: String, description: String, image: String, price: Double, quantity: UInt) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
//        self.price = price
        self.quantity = quantity
    }
}
