//
//  ACL.swift
//  feather-access-control
//
//  Created by Binary Birds on 2026. 02. 17.

/// Default ACL implementation backed by static role and permission key lists.
public struct ACL: AccessControlList {

    /// Identifier of the account the ACL belongs to.
    public let accountId: String
    /// Role keys granted to the account.
    public let roles: [String]
    /// Permission keys granted to the account.
    public let permissions: [String]

    /// Creates a new ACL value.
    ///
    /// - Parameters:
    ///   - accountId: Identifier of the account.
    ///   - roles: Role keys available to the account.
    ///   - permissions: Permission keys available to the account.
    public init(
        accountId: String,
        roles: [String] = [],
        permissions: [String] = []
    ) {
        self.accountId = accountId
        self.roles = roles
        self.permissions = permissions
    }

    /// Checks whether the ACL contains the given role key.
    ///
    /// - Parameter role: Role key to test.
    /// - Returns: `true` when the role key is present, otherwise `false`.
    /// - Throws: This method currently does not throw.
    public func has(
        role: String
    ) async throws(AccessControlError) -> Bool {
        roles.contains(role)
    }

    /// Checks whether the ACL contains the given permission key.
    ///
    /// - Parameter permission: Permission key to test.
    /// - Returns: `true` when the permission key is present, otherwise `false`.
    /// - Throws: This method currently does not throw.
    public func has(
        permission: String
    ) async throws(AccessControlError) -> Bool {
        permissions.contains(permission)
    }
}
