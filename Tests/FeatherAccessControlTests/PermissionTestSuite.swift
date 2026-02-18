//
//  PermissionTestSuite.swift
//  feather-access-control
//
//  Created by Binary Birds on 2026. 02. 17.

//
//  PermissionTests.swift
//
//
//  Created by Codex on 17/02/2026.
//

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
            action: .create
        )

        #expect(permission.components == ["app", "article", "create"])
        #expect(permission.key == "app.article.create")
        #expect(permission.accessKey == "app.article.create.access")
    }

    @Test
    func testPermissionFromKeyParsesKnownAction() {
        let permission = Permission("app.article.update")

        #expect(permission.namespace == "app")
        #expect(permission.context == "article")
        #expect(permission.action == .update)
        #expect(permission.key == "app.article.update")
    }

    @Test
    func testPermissionFromKeyParsesCustomAction() {
        let permission = Permission("app.article.publish")

        #expect(permission.action == .custom("publish"))
        #expect(permission.key == "app.article.publish")
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
        let acl = ACL(accountId: "test-id", permissionKeys: [permission.key])

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
            #expect(state.key == permission.key)
        }
        catch {
            Issue.record("Unexpected error type.")
        }
    }
}
