import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class Todo: SQLiteModel {
    /// The unique identifier for this `Todo`.
    var id: Int?

    /// A title describing what this `Todo` entails.
    var title: String
    
    var mass: Int

    /// Creates a new `Todo`.
    init(id: Int? = nil, title: String, mass: Int) {
        self.id = id
        self.title = title
        self.mass = mass
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: SQLiteMigration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Todo: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Todo: Parameter { }


/// CreateTodo
final class CreateTodo: SQLiteMigration {
    static func prepare(on conn: SQLiteConnection) -> EventLoopFuture<Void> {
        return SQLiteDatabase.create(Todo.self, on: conn, closure: { (builder) in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.title)
        })
    }
    
    static func revert(on conn: SQLiteConnection) -> EventLoopFuture<Void> {
        return SQLiteDatabase.delete(Todo.self, on: conn)
    }
}

/// AddTodo
final class AddTodo: SQLiteMigration {
    static func prepare(on conn: SQLiteConnection) -> EventLoopFuture<Void> {
        return SQLiteDatabase.update(Todo.self, on: conn, closure: { (builder) in
            let defaultVal = SQLiteColumnConstraint.default(.literal(0))
            builder.field(for: \.mass, type: .integer, defaultVal)
        })
    }
    
    static func revert(on conn: SQLiteConnection) -> EventLoopFuture<Void> {
        return SQLiteDatabase.update(Todo.self, on: conn, closure: { (builder) in
            builder.deleteField(for: \.mass)
        })
    }
}

/// TodoMassCleanup
final class TodoMassCleanup: SQLiteMigration {
    static func prepare(on conn: SQLiteConnection) -> EventLoopFuture<Void> {
        return Todo.query(on: conn).filter(\.mass == 0).delete()
    }
    
    static func revert(on conn: SQLiteConnection) -> EventLoopFuture<Void> {
        return conn.future()
    }
}
