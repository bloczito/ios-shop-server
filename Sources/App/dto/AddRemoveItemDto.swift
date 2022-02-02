import Foundation
import Vapor

struct AddRemoveItemDto: Content, Codable {
//    let userId: String
    let productId: UUID
    let quantity: UInt
}
