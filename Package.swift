// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Events",
                      defaultLocalization: "en",
                      platforms: [.iOS(.v14)],
                      products: [// Products define the executables and libraries a package produces, and make them visible to other packages.
                          .library(name: "Events",
                                   targets: ["Events"])],
                      dependencies: [// Dependencies declare other packages that this package depends on.
//                          .package(name: "AmwayThemeKit",
//                                   path: "../Package/AmwayThemeKit"),
                          .package(url: "https://github.com/VincentChew888/AmwayThemeKit.git", branch: "main"),
                          .package(url: "https://github.com/VincentChew888/CommonInteractions.git", branch: "main"),
                          .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", exact: Version("0.1.4"))],
                      targets: [// Targets are the basic building blocks of a package. A target can define a module or a test suite.
                          // Targets can depend on other targets in this package, and on products in packages this package depends on.
                          .target(name: "Events",
                                  dependencies: ["AmwayThemeKit",
                                                 "CommonInteractions",
                                                 .product(name: "Introspect", package: "SwiftUI-Introspect")],
                                  resources: [.process("Resources")]),
                          .testTarget(name: "EventsTests",
                                      dependencies: ["Events"])])
