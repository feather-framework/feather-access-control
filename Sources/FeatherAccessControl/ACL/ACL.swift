//
//  ACL.swift
//  feather-access-control
//
//  Created by Binary Birds on 2026. 02. 17.

//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/03/2024.
//

/// Default ACL implementation backed by static role and permission key lists.
public struct ACL: ACLInterface {

    /// Identifier of the account the ACL belongs to.
    public let accountId: String
    /// Role keys granted to the account.
    public let roleKeys: [String]
    /// Permission keys granted to the account.
    public let permissionKeys: [String]

    /// Creates a new ACL value.
    ///
    /// - Parameters:
    ///   - accountId: Identifier of the account.
    ///   - roleKeys: Role keys available to the account.
    ///   - permissionKeys: Permission keys available to the account.
    public init(
        accountId: String,
        roleKeys: [String] = [],
        permissionKeys: [String] = []
    ) {
        self.accountId = accountId
        self.roleKeys = roleKeys
        self.permissionKeys = permissionKeys
    }

    /// Checks whether the ACL contains the given role key.
    ///
    /// - Parameter roleKey: Role key to test.
    /// - Returns: `true` when the role key is present, otherwise `false`.
    /// - Throws: This method currently does not throw.
    public func has(
        roleKey: String
    ) async throws -> Bool {
        roleKeys.contains(roleKey)
    }

    /// Checks whether the ACL contains the given permission key.
    ///
    /// - Parameter permissionKey: Permission key to test.
    /// - Returns: `true` when the permission key is present, otherwise `false`.
    /// - Throws: This method currently does not throw.
    public func has(
        permissionKey: String
    ) async throws -> Bool {
        permissionKeys.contains(permissionKey)
    }
}
