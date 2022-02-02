import Fluent
import Vapor
import Foundation

struct ProduktController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let produkty = routes.grouped("produkt")
        produkty.get(use: index)
        produkty.post(use: create)
        produkty.group(":produktID") { produkt in
            produkt.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[ProductDto]> {
        let categoryId = req.query[UUID.self, at: "categoryId"]
        
        if let id = categoryId {
            return Product
                .query(on: req.db)
                .filter(\.$category.$id == id)
                .all()
                .mapEach { product in
                    ProductDto(product: product)
                }
        } else {
            return Product
                .query(on: req.db)
                .all()
                .mapEach { product in
                    ProductDto(product: product)
                }
        }
        
        
    }

    func create(req: Request) throws -> EventLoopFuture<Product> {
        let product = try req.content.decode(Product.self)
        return product.create(on: req.db).map{product}    
    }
    


    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Product.find(req.parameters.get("produktID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
