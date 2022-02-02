import Fluent
import Vapor
import Foundation


final class CartItem: Fluent.Model, Content {
//    typealias IDValue = String
    
    static let schema = "cartItem"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "quantity")
    var quantity: UInt
    
    @Field(key: "user_id")
    var userId: String
    
    @Parent(key: "product_id")
    var product: Product
    
    init() {}
    
    
    init(id: UUID? = nil, userId: String, quantity: UInt, productId: UUID) {
        self.id = id
        self.quantity = quantity
        self.$product.id = productId
        self.userId = userId
    }
}
