import App
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
if #available(macOS 12.0, *) {
    try configure(app)
} else {
    // Fallback on earlier versions
}
try app.autoMigrate().wait()
try app.run()
