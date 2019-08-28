// swift-tools-version:4.0
import PackageDescription

/// SPM：Swift Package Manager (简称 SPM) 构建工程的源码和依赖
/// 首先SPM会检查包清单（Package.swift）
let package = Package(
    name: "HTJ_Hello",
    products: [
        .library(name: "HTJ_Hello", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),
        // 🖋🐬 Swift ORM (queries, models, relations, etc) built on MySQL.
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.1")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "FluentMySQL", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

