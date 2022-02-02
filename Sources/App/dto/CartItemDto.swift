import Vapor
import Foundation

struct CartItemDto: Codable, Content {
    let id: UUID
    let product: ProductDto
    let quantity: UInt
    
    init(id: UUID, product: ProductDto, quantity: UInt) {
        self.id = id
        self.quantity = quantity
        self.product = product
    }
}
