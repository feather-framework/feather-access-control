//
//  AccessControlList.swift
//  feather-access-control
//
//  Created by Binary Birds on 2026. 02. 17.

/// Interface describing role and permission checks for an ACL implementation.
public protocol AccessControlList: Sendable {

    /// Checks whether the ACL contains the given role.
    ///
    /// - Parameter role: Role key to test.
    /// - Returns: `true` when the role is present, otherwise `false`.
    /// - Throws: Any error produced by the ACL backend.
    func has(
        role: String
    ) async throws(AccessControlError) -> Bool

    /// Checks whether the ACL contains the given permission key.
    ///
    /// - Parameter permission: Permission key to test.
    /// - Returns: `true` when the permission is present, otherwise `false`.
    /// - Throws: Any error produced by the ACL backend.
    func has(
        permission: String
    ) async throws(AccessControlError) -> Bool

    /// Requires the ACL to contain the given role.
    ///
    /// - Parameter role: Required role key.
    /// - Throws: ``AccessControlError/forbidden(_:)`` when the role is missing.
    func require(
        role: String
    ) async throws(AccessControlError)

    /// Requires the ACL to contain the given permission key.
    ///
    /// - Parameter permission: Required permission key.
    /// - Throws: ``AccessControlError/forbidden(_:)`` when the permission is missing.
    func require(
        permission: String
    ) async throws(AccessControlError)
}

extension AccessControlList {

    /// Requires the ACL to contain the given role.
    ///
    /// - Parameter role: Required role key.
    /// - Throws: ``AccessControlError/forbidden(_:)`` when the role is missing.
    public func require(
        role: String
    ) async throws(AccessControlError) {
        guard try await has(role: role) else {
            throw .forbidden(
                .init(
                    key: role,
                    kind: .role
                )
            )
        }
    }

    /// Requires the ACL to contain the given permission key.
    ///
    /// - Parameter permission: Required permission key.
    /// - Throws: ``AccessControlError/forbidden(_:)`` when the permission is missing.
    public func require(
        permission: String
    ) async throws(AccessControlError) {
        guard try await has(permission: permission) else {
            throw .forbidden(
                .init(
                    key: permission,
                    kind: .permission
                )
            )
        }
    }
}
