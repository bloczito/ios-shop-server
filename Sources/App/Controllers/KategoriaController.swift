import Fluent
import Vapor

struct KategoriaController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("kategoria")
        todos.get(use: index)
        todos.post(use: create)
        todos.group(":kategoriaID") { todo in
            todo.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Category]> {
        let cat = Category.query(on: req.db).all()
        return cat;
    }

    func create(req: Request) throws -> EventLoopFuture<Category> {
        let todo = try req.content.decode(Category.self)
        return todo.save(on: req.db).map { todo }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Category.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
