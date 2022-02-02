import Vapor
import Fluent
import Darwin


@available(macOS 12.0, *)
class CartController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let protected = routes.grouped(UserAuthenticator()).grouped(User.guardMiddleware()).grouped("cartItems")

        protected.post(use: addItem)
        protected.get(use: getUserItems)
        protected.delete(use: removeCartItem)
        protected.group("count") {i in
            i.get(use: countUserItems)
        }
        protected.group(":productId") { item in
            item.delete(use: removeWholeCartItem)
        }
        
    }
    
    func getUserItems(req: Request) throws -> EventLoopFuture<[CartItemDto]> {
        let user = try req.auth.require(User.self)
        
        return CartItem.query(on: req.db)
            .filter(\.$userId == user.id)
            .join(Product.self, on: \CartItem.$product.$id == \Product.$id)
            .all()
            .mapEach({ element in
                let product = try! element.joined(Product.self)
                return CartItemDto(id: element.id!, product: ProductDto(product: product), quantity: element.quantity)
            })
    }
    
    func countUserItems(req: Request) throws -> EventLoopFuture<Int> {
        let user = try req.auth.require(User.self)
        
        let asd = CartItem.query(on: req.db)
            .filter(\.$userId == user.id)
            .count()

        return asd
        
    }
    
    
    func addItem(req: Request) throws -> EventLoopFuture<Int> {
        let user = try req.auth.require(User.self)
        let addItemDto = try req.content.decode(AddRemoveItemDto.self)
        
        return Product
            .find(addItemDto.productId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                return CartItem.query(on: req.db)
                    .filter(\.$product.$id == addItemDto.productId)
                    .filter(\.$userId == user.id)
                    .first()
                    .flatMap { optItem in
                        if let item = optItem {
                            
                            if item.quantity + addItemDto.quantity > product.quantity {
                                item.quantity = product.quantity
                            } else {
                                item.quantity += addItemDto.quantity
                            }

                            return item
                                .save(on: req.db)
                                .transform(to: CartItem
                                            .query(on: req.db)
                                            .filter(\.$userId == user.id)
                                            .count()
                                )
                        } else {
                            let newItem = CartItem(
                                userId: user.id,
                                quantity: addItemDto.quantity,
                                productId: product.id!
                            )
                            return newItem
                                .create(on: req.db)
                                .transform(to: CartItem
                                            .query(on: req.db)
                                            .filter(\.$userId == user.id)
                                            .count()
                                )
                        }
                    }
            }
    }
    
    
    func removeCartItem(req: Request) throws -> EventLoopFuture<UInt> {
        let user = try req.auth.require(User.self)
        let dto = try req.content.decode(AddRemoveItemDto.self)
        
        return CartItem.query(on: req.db)
            .filter(\.$product.$id == dto.productId)
            .filter(\.$userId == user.id)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { item in
                item.quantity = item.quantity - dto.quantity > 0 ? item.quantity - dto.quantity : 0
                
                return item
                    .save(on: req.db)
                    .transform(to: item.quantity)
            }
    }

    func removeWholeCartItem(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let itemId = req.parameters.get("productId") as UUID? else {
            throw Abort(.badRequest)
        }
                
        return CartItem
            .find(itemId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
}
