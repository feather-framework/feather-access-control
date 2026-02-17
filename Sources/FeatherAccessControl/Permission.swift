//
//  Permission.swift
//  feather-access-control
//
//  Created by Binary Birds on 2026. 02. 17.

//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/03/2024.
//

/// Generic permission object.
public struct Permission: Equatable, Hashable, Codable, Sendable {

    private static let separator = "."

    /// Namespace of the permission, usually the module name.
    public let namespace: String
    /// Context of the permission, usually a model name.
    public let context: String
    /// Action for the given namespace & context.
    public let action: Action

    /// Creates a new permission from namespace, context, and action.
    ///
    /// - Parameters:
    ///   - namespace: Namespace of the permission, typically a module name.
    ///   - context: Context of the permission, typically a model name.
    ///   - action: Action permitted for the given namespace and context.
    public init(
        namespace: String,
        context: String,
        action: Action
    ) {
        self.namespace = namespace
        self.context = context
        self.action = action
    }

    /// Creates a permission from a key with three components.
    ///
    /// The expected format is `namespace.context.action`.
    ///
    /// - Parameter key: Permission key to parse.
    public init(
        _ key: String
    ) {
        let parts = key.split(separator: Self.separator).map(String.init)
        guard parts.count == 3 else {
            fatalError("Invalid permission key")
        }
        self.namespace = parts[0]
        self.context = parts[1]
        self.action = .init(parts[2])
    }
}

extension Permission {

    /// Namespace, context, and action key components.
    public var components: [String] { [namespace, context, action.key] }
    /// String identifier of the permission in `namespace.context.action` format.
    public var key: String { components.joined(separator: Self.separator) }
    /// Permission key with an `.access` suffix.
    public var accessKey: String { key + Self.separator + "access" }
}

extension Permission {

    /// Generic action for permissions.
    public enum Action: Equatable, Codable, Sendable, Hashable {
        /// Action for list objects.
        case list
        /// Action for object details.
        case detail
        /// Action for creating new objects.
        case create
        /// Action for updating objects.
        case update
        /// Action for deleting objects.
        case delete
        /// Custom action key.
        case custom(String)

        /// Creates an action from a raw key.
        ///
        /// - Parameter key: Action key string.
        public init(_ key: String) {
            switch key {
            case "list": self = .list
            case "detail": self = .detail
            case "create": self = .create
            case "update": self = .update
            case "delete": self = .delete
            default: self = .custom(key)
            }
        }

        /// Raw key representation of the action.
        public var key: String {
            switch self {
            case .list: return "list"
            case .detail: return "detail"
            case .create: return "create"
            case .update: return "update"
            case .delete: return "delete"
            case .custom(let key): return key
            }
        }

        /// Decodes an action from its raw string representation.
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self = .init(try container.decode(String.self))
        }

        /// Encodes an action as its raw string representation.
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(key)
        }
    }
}
