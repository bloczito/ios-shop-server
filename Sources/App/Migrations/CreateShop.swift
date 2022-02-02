import Fluent

struct CreateShop: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("shop")
            .id()
            .field("address", .string, .required)
            .field("latitude", .double, .required)
            .field("longtitude", .double, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("shop").delete()
    }
}
