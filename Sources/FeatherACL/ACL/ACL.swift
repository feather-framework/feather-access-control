//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/03/2024.
//

public struct ACL: ACLInterface {

    public let accountId: String
    public let roleKeys: [String]
    public let permissionKeys: [String]

    public init(
        accountId: String,
        roleKeys: [String] = [],
        permissionKeys: [String] = []
    ) {
        self.accountId = accountId
        self.roleKeys = roleKeys
        self.permissionKeys = permissionKeys
    }

    public func hasRole(
        _ key: String
    ) async throws -> Bool {
        roleKeys.contains(key)
    }

    public func hasPermission(
        _ key: String
    ) async throws -> Bool {
        permissionKeys.contains(key)
    }
}
