//
//  Permission.swift
//  feather-access-control
//
//  Created by Binary Birds on 2026. 02. 17.

/// Generic permission object.
public struct Permission: Equatable, Hashable, Codable, Sendable {

    /// Default separator used between permission components.
    public static let separator = "."

    /// Generic action for permissions.
    public enum Action: RawRepresentable, Equatable, Codable, Sendable,
        Hashable, ExpressibleByStringLiteral
    {

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
        /// - Parameter rawValue: Action key string.
        public init(
            rawValue: String
        ) {
            switch rawValue {
            case "list": self = .list
            case "detail": self = .detail
            case "create": self = .create
            case "update": self = .update
            case "delete": self = .delete
            default: self = .custom(rawValue)
            }
        }

        /// Raw key representation of the action.
        public var rawValue: String {
            switch self {
            case .list: return "list"
            case .detail: return "detail"
            case .create: return "create"
            case .update: return "update"
            case .delete: return "delete"
            case .custom(let key): return key
            }
        }

        /// Creates an action from a string literal.
        ///
        /// - Parameter value: Action key string.
        public init(
            stringLiteral value: StringLiteralType
        ) {
            self = .init(rawValue: value)
        }

        /// Decodes an action from its raw string representation.
        public init(
            from decoder: Decoder
        ) throws {
            let container = try decoder.singleValueContainer()
            self = .init(rawValue: try container.decode(String.self))
        }

        /// Encodes an action as its raw string representation.
        public func encode(
            to encoder: Encoder
        ) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }
    }

    /// Namespace of the permission, usually the module name.
    public let namespace: String
    /// Context of the permission, usually a model name.
    public let context: String
    /// Action for the given namespace & context.
    public let action: Action
    /// The separator used to separate components.
    public let separator: String

    /// Creates a new permission from namespace, context, and action.
    ///
    /// - Parameters:
    ///   - namespace: Namespace of the permission, typically a module name.
    ///   - context: Context of the permission, typically a model name.
    ///   - action: Action permitted for the given namespace and context.
    ///   - separator: The separator to use when converting to rawValue.
    public init(
        namespace: String,
        context: String,
        action: Action,
        separator: String = Self.separator
    ) {
        self.namespace = namespace
        self.context = context
        self.action = action
        self.separator = separator
    }

    /// Creates a permission from a key with three components.
    ///
    /// The expected format is `namespace.context.action`.
    ///
    /// - Parameters:
    ///   - rawValue: Permission key to parse.
    ///   - separator: Separator used to split the permission key.
    public init?(
        rawValue: String,
        separator: String = Self.separator
    ) {
        let parts = rawValue.split(separator: separator).map(String.init)
        guard parts.count == 3 else {
            return nil
        }
        self.namespace = parts[0]
        self.context = parts[1]
        self.action = .init(rawValue: parts[2])
        self.separator = separator
    }

    /// Namespace, context, and action key components.
    public var components: [String] {
        [namespace, context, action.rawValue]
    }

    /// Raw value using the namespace, context and action joined with the separator.
    public var rawValue: String {
        components.joined(separator: separator)
    }
}
