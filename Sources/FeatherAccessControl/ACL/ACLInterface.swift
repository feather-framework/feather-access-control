//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/03/2024.
//

public protocol ACLInterface: Sendable {

    func has(
        roleKey: String
    ) async throws -> Bool

    func has(
        permissionKey: String
    ) async throws -> Bool

    func has(
        permission: Permission
    ) async throws -> Bool

    //    func hasAccess(
    //        _ key: String,
    //        userInfo: [String: Any]
    //    ) async throws -> Bool

    func require(
        roleKey: String
    ) async throws

    func require(
        permissionKey: String
    ) async throws

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

    public func has(
        permission: Permission
    ) async throws -> Bool {
        try await has(permissionKey: permission.key)
    }

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
