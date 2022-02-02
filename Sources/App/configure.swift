import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
@available(macOS 12.0, *)
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let db = DatabaseConfigurationFactory.sqlite(.file("db.sqlite"))
    
    app.databases.use(db, as: .sqlite)
    
                
                                

    app.migrations.add(CreateProdukt())
    app.migrations.add(CreateKategoria())
    app.migrations.add(CreateShop())
    app.migrations.add(CreateCartItem())


    

//    try app.autoMigrate().waitŪ()
    // register routes
    try routes(app)
}
