import SwiftUI

public protocol RoutingService {
    func register<T>(_ factory: @escaping DependencyFactory, for type: T.Type)
    func register(routeHandler: RouteHandling)
    
    func feature(for featureType: Feature.Type) -> Feature
    func initialize(using feature: Feature.Type) -> AnyView
    func link<Body>(for route: Route, @ViewBuilder body: () -> Body) -> NavigationLink<Body, AnyView>
}

public final class RouterService: RoutingService {
    
    private let container: DependencyContainer
    
    private var registeredRoutes = [String : (Any, RouteHandling)]()
    
    public convenience init() {
        self.init(container: DefaultDependencyContainer())
    }
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    
    public func register<T>(_ factory: @escaping DependencyFactory, for type: T.Type) {
        container.register(factory: factory, for: type)
    }
    
    public func register(routeHandler: RouteHandling) {
        routeHandler.routes.forEach {
            registeredRoutes[$0.identifier] = ($0, routeHandler)
        }
    }
    
    public func feature(for featureType: Feature.Type) -> Feature {
        featureType.initialize(using: container)
    }
    
    public func initialize(using feature: Feature.Type) -> AnyView {
        let instance = feature.init()
        instance.resolve(using: container)
        return instance.build(using: nil)
    }
    
    public func link<Content>(for route: Route, @ViewBuilder body: () -> Content) -> NavigationLink<Content, AnyView> where Content : View {
        guard let handler = handler(for: route) else {
            fatalError("No handler for route \(route)")
        }
        
        let featureType = handler.destination(for: route)
        let feature = featureType.initialize(using: container)
        let view = feature.build(using: route)
        
        return NavigationLink(
            destination: view,
            label: body)
        
    }
    
    private func handler(for route: Route) -> RouteHandling? {
        let routeIdentifier = type(of: route).identifier
        return registeredRoutes[routeIdentifier]?.1
    }
}
