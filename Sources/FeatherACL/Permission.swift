//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/03/2024.
//

import Foundation

/// Generic permission object.
public struct Permission: Equatable, Codable, Sendable, Hashable {

    private static let separator = "."

    /// Namespace of the permission, usually the module name.
    public let namespace: String
    /// Context of the permission, usually a model name.
    public let context: String
    /// Action for the given namespace & context.
    public let action: Action

    /// Init a new permission using a namespace, context, action.
    public init(namespace: String, context: String, action: Action) {
        self.namespace = namespace
        self.context = context
        self.action = action
    }

    /// Init a new permission using a key with 3 components.
    ///
    /// (namespace, context, action) separated by a `.`.
    public init(_ key: String) {
        let parts = key.components(separatedBy: Self.separator)
        guard parts.count == 3 else {
            fatalError("Invalid permission key")
        }
        self.namespace = parts[0]
        self.context = parts[1]
        self.action = .init(parts[2])
    }
}

extension Permission {

    /// Namespace, context and action.key as an array of string.
    public var components: [String] { [namespace, context, action.key] }
    /// String identifier of the permisison (format: namespace.context.action).
    public var key: String { components.joined(separator: Self.separator) }
    /// The permission key with an access suffix (format: namespace.context.action.access).
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
        /// Custom action.
        case custom(String)

        /// Create a new action using a raw key.
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

        /// Convert an action to a key using a String value.
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

        /// Custom decoder (decode value from raw string).
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self = .init(try container.decode(String.self))
        }

        /// Custom encoder (encode value as raw string).
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(key)
        }
    }
}
