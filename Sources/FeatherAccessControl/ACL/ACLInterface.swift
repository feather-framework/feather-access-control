//
//  ACLInterface.swift
//  feather-access-control
//
//  Created by Binary Birds on 2026. 02. 17.

//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/03/2024.
//

/// Interface describing role and permission checks for an ACL implementation.
public protocol ACLInterface: Sendable {

    /// Checks whether the ACL contains the given role.
    ///
    /// - Parameter roleKey: Role key to test.
    /// - Returns: `true` when the role is present, otherwise `false`.
    /// - Throws: Any error produced by the ACL backend.
    func has(
        roleKey: String
    ) async throws -> Bool

    /// Checks whether the ACL contains the given permission key.
    ///
    /// - Parameter permissionKey: Permission key to test.
    /// - Returns: `true` when the permission is present, otherwise `false`.
    /// - Throws: Any error produced by the ACL backend.
    func has(
        permissionKey: String
    ) async throws -> Bool

    /// Checks whether the ACL contains the given permission value.
    ///
    /// - Parameter permission: Permission value to test.
    /// - Returns: `true` when the permission is present, otherwise `false`.
    /// - Throws: Any error produced by the ACL backend.
    func has(
        permission: Permission
    ) async throws -> Bool

    //    func hasAccess(
    //        _ key: String,
    //        userInfo: [String: Any]
    //    ) async throws -> Bool

    /// Requires the ACL to contain the given role.
    ///
    /// - Parameter roleKey: Required role key.
    /// - Throws: ``AccessControlError/forbidden(_:)`` when the role is missing.
    func require(
        roleKey: String
    ) async throws

    /// Requires the ACL to contain the given permission key.
    ///
    /// - Parameter permissionKey: Required permission key.
    /// - Throws: ``AccessControlError/forbidden(_:)`` when the permission is missing.
    func require(
        permissionKey: String
    ) async throws

    /// Requires the ACL to contain the given permission value.
    ///
    /// - Parameter permission: Required permission.
    /// - Throws: ``AccessControlError/forbidden(_:)`` when the permission is missing.
    func require(
        permission: Permission
    ) async throws

    //    func requireAccess(
    //        _ key: String,
    //        userInfo: [String: Any]
    //    ) async throws
}

extension ACLInterface {

    //    public func hasAccess(
    //        _ key: String,
    //        userInfo: [String: Any]
    //    ) async throws -> Bool {
    //        try await hasPermission(key)
    //    }

    /// Checks whether the ACL contains the given permission value.
    ///
    /// - Parameter permission: Permission value to test.
    /// - Returns: `true` when the permission is present, otherwise `false`.
    /// - Throws: Any error produced by `has(permissionKey:)`.
    public func has(
        permission: Permission
    ) async throws -> Bool {
        try await has(permissionKey: permission.key)
    }

    /// Requires the ACL to contain the given role.
    ///
    /// - Parameter roleKey: Required role key.
    /// - Throws: ``AccessControlError/forbidden(_:)`` when the role is missing.
    public func require(
        roleKey: String
    ) async throws {
        guard try await has(roleKey: roleKey) else {
            throw AccessControlError.forbidden(
                .init(
                    key: roleKey,
                    kind: .role
                )
            )
        }
    }

    /// Requires the ACL to contain the given permission key.
    ///
    /// - Parameter permissionKey: Required permission key.
    /// - Throws: ``AccessControlError/forbidden(_:)`` when the permission is missing.
    public func require(
        permissionKey: String
    ) async throws {
        guard try await has(permissionKey: permissionKey) else {
            throw AccessControlError.forbidden(
                .init(
                    key: permissionKey,
                    kind: .permission
                )
            )
        }
    }

    /// Requires the ACL to contain the given permission value.
    ///
    /// - Parameter permission: Required permission.
    /// - Throws: ``AccessControlError/forbidden(_:)`` when the permission is missing.
    public func require(
        permission: Permission
    ) async throws {
        try await require(permissionKey: permission.key)
    }

    //    public func requireAccess(
    //        _ key: String,
    //        userInfo: [String: Any]
    //    ) async throws {
    //        guard try await hasAccess(key, userInfo: userInfo) else {
    //            throw AccessControlError.forbidden(
    //                .init(
    //                    key: key,
    //                    kind: .access
    //                )
    //            )
    //        }
    //    }
}
