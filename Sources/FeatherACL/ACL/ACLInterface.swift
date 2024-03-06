//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/03/2024.
//

public protocol ACLInterface: Sendable {

    func hasRole(
        _ key: String
    ) async throws -> Bool

    func hasPermission(
        _ key: String
    ) async throws -> Bool

    //    func hasAccess(
    //        _ key: String,
    //        userInfo: [String: Any]
    //    ) async throws -> Bool

    func requireRole(
        _ key: String
    ) async throws

    func requirePermission(
        _ key: String
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

    public func requireRole(
        _ key: String
    ) async throws {
        guard try await hasRole(key) else {
            throw AccessControlError.forbidden(
                .init(
                    key: key,
                    kind: .role
                )
            )
        }
    }

    public func requirePermission(
        _ key: String
    ) async throws {
        guard try await hasPermission(key) else {
            throw AccessControlError.forbidden(
                .init(
                    key: key,
                    kind: .permission
                )
            )
        }
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
