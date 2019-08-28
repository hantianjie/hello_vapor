import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!\(5+1)"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        
        return "Hello, world!"
    }

    // Example of configuring a controller
    router.get("users", Int.parameter) { (req) -> String in
        let id = try req.parameters.next(Int.self)
        
        return "requested id : \(id + 1024)"
    }
    
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
