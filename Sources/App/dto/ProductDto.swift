import Vapor

struct ProductDto: Content {
    let id: UUID
    let title: String
    let desc: String?
    let image: String
    let quantity: UInt
    let price: Double
    let categoryId: UUID
    
    
    init(product: Product) {
        self.id = product.id!
        self.title = product.title
        self.desc = product.description
        self.image = product.image
        self.quantity = product.quantity
        self.price = product.price
        self.categoryId = product.$category.id
    }
}
