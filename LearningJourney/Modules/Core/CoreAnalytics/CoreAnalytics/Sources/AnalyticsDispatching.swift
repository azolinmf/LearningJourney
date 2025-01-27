public enum AnalyticsDestination {
    case firebase
}

public protocol AnalyticsDispatching {
    var destinations: [AnalyticsDestination] { get }
}

// MARK: - Default values

extension AnalyticsDispatching {
    var destinations: [AnalyticsDestination] {
        [.firebase]
    }
}
