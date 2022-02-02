import Fluent

struct CreateCartItem: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(CartItem.schema)
            .id()
            .field("quantity", .uint, .required)
            .field("user_id", .string, .required)
            .field("product_id", .uuid, .required)
            .foreignKey("product_id", references: Product.schema, .id, onDelete: .cascade, onUpdate: .noAction)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(CartItem.schema).delete()
    }
}
