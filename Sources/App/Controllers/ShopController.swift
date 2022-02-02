import Fluent
import Vapor

struct ShopController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let shops = routes.grouped("shop")
        
        shops.get(use: index)
        shops.post(use: create)
    }
    
    
    
    func index(req: Request) throws -> EventLoopFuture<[Shop]> {
        return Shop.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Shop> {
        let newShop = try req.content.decode(Shop.self)
        return newShop.create(on: req.db).map{ newShop }
    }
    
}
