//
//  PermissionTestSuite.swift
//  feather-access-control
//
//  Created by Binary Birds on 2026. 02. 17.

import Foundation
import Testing

@testable import FeatherAccessControl

@Suite
struct PermissionTestSuite {

    @Test
    func testPermissionFromPartsBuildsDerivedKeys() {
        let permission = Permission(
            namespace: "app",
            context: "article",
            action: "create",
            separator: ":"
        )

        #expect(permission.components == ["app", "article", "create"])
        #expect(permission.action == .create)
        #expect(permission.rawValue == "app:article:create")
    }

    @Test
    func testPermissionFromPartsBuildsDerivedKeysCustomAction() {
        let permission = Permission(
            namespace: "app",
            context: "article",
            action: "exists",
            separator: "_"
        )

        #expect(permission.components == ["app", "article", "exists"])
        #expect(permission.action == .custom("exists"))
        #expect(permission.rawValue == "app_article_exists")
    }

    @Test
    func testPermissionFromKeyParsesKnownAction() {
        guard let permission = Permission(rawValue: "app.article.update") else {
            Issue.record("Permission should exist.")
            return
        }

        #expect(permission.namespace == "app")
        #expect(permission.context == "article")
        #expect(permission.action == .update)
        #expect(permission.rawValue == "app.article.update")
    }

    @Test
    func testPermissionFromKeyParsesCustomAction() {
        guard let permission = Permission(rawValue: "app.article.publish")
        else {
            Issue.record("Permission should exist.")
            return
        }

        #expect(permission.action == .custom("publish"))
        #expect(permission.rawValue == "app.article.publish")
    }

    @Test
    func testActionRawKeyMapping() {
        #expect(Permission.Action("list") == .list)
        #expect(Permission.Action("detail") == .detail)
        #expect(Permission.Action("create") == .create)
        #expect(Permission.Action("update") == .update)
        #expect(Permission.Action("delete") == .delete)
        #expect(Permission.Action("sync") == .custom("sync"))
    }

    @Test
    func testPermissionCodableRoundtrip() throws {
        let permission = Permission(
            namespace: "app",
            context: "article",
            action: .custom("publish")
        )
        let encoded = try JSONEncoder().encode(permission)
        let decoded = try JSONDecoder().decode(Permission.self, from: encoded)

        #expect(decoded == permission)
    }

    @Test
    func testACLHasPermissionUsingPermissionValue() async throws {
        let permission = Permission(
            namespace: "app",
            context: "article",
            action: .delete
        )
        let acl = ACL(accountId: "test-id", permissions: [permission.rawValue])

        let hasPermission = try await acl.has(permission: permission)
        #expect(hasPermission)
    }

    @Test
    func testACLRequirePermissionThrowsForbiddenWhenMissing() async throws {
        let acl = ACL(accountId: "test-id")
        let permission = Permission(
            namespace: "app",
            context: "article",
            action: .delete
        )

        do {
            try await acl.require(permission: permission)
            Issue.record("Expected forbidden permission error.")
        }
        catch AccessControlError.forbidden(let state) {
            #expect(state.kind == .permission)
            #expect(state.key == permission.rawValue)
        }
        catch {
            Issue.record("Unexpected error type.")
        }
    }
}
