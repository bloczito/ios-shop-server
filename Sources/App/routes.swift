import Fluent
import Vapor

@available(macOS 12.0, *)
func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    try app.register(collection: ProduktController())
    try app.register(collection: KategoriaController())
    try app.register(collection: ShopController())
    try app.register(collection: CartController())
}
