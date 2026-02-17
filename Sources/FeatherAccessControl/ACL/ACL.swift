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

    public func has(
        roleKey: String
    ) async throws -> Bool {
        roleKeys.contains(roleKey)
    }

    public func has(
        permissionKey: String
    ) async throws -> Bool {
        permissionKeys.contains(permissionKey)
    }
}
