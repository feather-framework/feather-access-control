//
//  AccessControlError.swift
//  feather-access-control
//
//  Created by Binary Birds on 2026. 02. 17.

/// Errors related to access control context and authorization checks.
public enum AccessControlError: Error {

    /// Additional metadata describing why access was forbidden.
    public struct State: Sendable {

        /// Category of the forbidden access check.
        public enum Kind: Sendable {
            /// A permission check failed.
            case permission
            /// A role check failed.
            case role
        }

        /// Key that failed authorization.
        public let key: String
        /// Type of access check that failed.
        public let kind: Kind

        /// Creates a new forbidden state payload.
        ///
        /// - Parameters:
        ///   - key: Key that failed authorization.
        ///   - kind: Category of failed check.
        public init(
            key: String,
            kind: Kind
        ) {
            self.key = key
            self.kind = kind
        }
    }

    /// No ACL was available in the current access control context.
    case unauthorized
    /// ACL was present, but a role or permission check failed.
    case forbidden(State)
}
