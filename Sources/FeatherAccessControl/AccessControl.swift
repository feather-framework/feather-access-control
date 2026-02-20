//
//  AccessControl.swift
//  feather-access-control
//
//  Created by Binary Birds on 2026. 02. 17.

/// Task-local access control context utilities.
public enum AccessControl: Sendable {

    @TaskLocal
    private static var rawValue: AccessControlList?

    /// Runs a block with the given ACL value set for the current task context.
    ///
    /// - Parameters:
    ///   - acl: ACL value to store for the current task, or `nil` to clear it.
    ///   - block: Async block executed with the provided ACL context.
    /// - Returns: The result produced by `block`.
    /// - Throws: Rethrows any error thrown by `block`.
    public static func set<T: AccessControlList, R>(
        _ acl: T?,
        _ block: (() async throws -> R)
    ) async throws -> R {
        try await $rawValue.withValue(acl) {
            try await block()
        }
    }

    /// Runs a block with no ACL value set for the current task context.
    ///
    /// - Parameters:
    ///   - type: ACL type marker used to infer the ACL generic type.
    ///   - block: Async block executed without an ACL context.
    /// - Returns: The result produced by `block`.
    /// - Throws: Rethrows any error thrown by `block`.
    public static func unset<T: AccessControlList, R>(
        _ type: T.Type,
        _ block: (() async throws -> R)
    ) async throws -> R {
        try await $rawValue.withValue(nil) {
            try await block()
        }
    }

    /// Returns the current task-local ACL value if present and type-compatible.
    ///
    /// - Parameter type: ACL type to retrieve from the task-local context.
    /// - Returns: The typed ACL value, or `nil` if unavailable.
    /// - Throws: This method currently does not throw.
    public static func get<T: AccessControlList>(
        _ type: T.Type
    ) async throws -> T? {
        rawValue as? T
    }

    /// Returns the current task-local ACL value or throws if it is missing.
    ///
    /// - Parameter type: ACL type to retrieve from the task-local context.
    /// - Returns: The typed ACL value.
    /// - Throws: ``AccessControlError/unauthorized`` if no matching ACL is set.
    public static func require<T: AccessControlList>(
        _ type: T.Type
    ) async throws(AccessControlError) -> T {
        guard let value = rawValue as? T else {
            throw .unauthorized
        }
        return value
    }

    /// Indicates whether a typed ACL value exists in the current task context.
    ///
    /// - Parameter type: ACL type to check for.
    /// - Returns: `true` when a matching ACL is available, otherwise `false`.
    /// - Throws: This method currently does not throw.
    public static func exists<T: AccessControlList>(
        _ type: T.Type
    ) async throws -> Bool {
        try await get(T.self) != nil
    }
}
