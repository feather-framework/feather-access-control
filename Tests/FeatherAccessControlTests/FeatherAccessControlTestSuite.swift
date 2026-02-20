//
//  FeatherAccessControlTestSuite.swift
//  feather-access-control
//
//  Created by Binary Birds on 2026. 02. 17.

import Testing

@testable import FeatherAccessControl

@Suite
struct FeatherAccessControlTestSuite {

    @Test
    func testGetACL() async throws {
        let res = try await AccessControl.exists(ACL.self)
        #expect(res == false)

        let acl = try await AccessControl.get(ACL.self)
        #expect(acl == nil)
    }

    @Test
    func testSetACL() async throws {
        let acl = ACL(
            accountId: "test-id",
            roles: ["test-role"],
            permissions: ["test-permission"]
        )

        try await AccessControl.set(acl) {
            let res1 = try await AccessControl.exists(ACL.self)
            #expect(res1)

            let acl = try await AccessControl.get(ACL.self)
            #expect(acl != nil)

            try await AccessControl.unset(ACL.self) {
                let acl = try await AccessControl.get(ACL.self)
                #expect(acl == nil)
            }

            let res2 = try await AccessControl.exists(ACL.self)
            #expect(res2)
        }
    }

    @Test
    func testRequireACL() async throws {
        let acl = ACL(
            accountId: "test-id",
            roles: ["test-role"],
            permissions: ["test-permission"]
        )

        try await AccessControl.set(acl) {
            let acl = try await AccessControl.require(ACL.self)
            try await acl.require(role: "test-role")
            try await acl.require(permission: "test-permission")
        }
    }

    @Test
    func testUnauthorizedError() async throws {
        do {
            _ = try await AccessControl.require(ACL.self)
            Issue.record("Expected unauthorized error.")
        }
        catch AccessControlError.unauthorized {
            #expect(Bool(true))
        }
        catch {
            Issue.record("Unexpected error type.")
        }
    }

    @Test
    func testACLForbiddenRoleError() async throws {
        let acl = ACL(accountId: "test-id")

        do {
            try await AccessControl.set(acl) {
                let acl = try await AccessControl.require(ACL.self)
                try await acl.require(role: "test-role")
            }
            Issue.record("Expected forbidden role error.")
        }
        catch AccessControlError.forbidden(let state) {
            #expect(state.kind == .role)
            #expect(state.key == "test-role")
        }
        catch {
            Issue.record("Unexpected error type.")
        }
    }

    @Test
    func testACLForbiddenPermissionError() async throws {
        let acl = ACL(accountId: "test-id")

        do {
            try await AccessControl.set(acl) {
                let acl = try await AccessControl.require(ACL.self)
                try await acl.require(permission: "test-permission")
            }
            Issue.record("Expected forbidden permission error.")
        }
        catch AccessControlError.forbidden(let state) {
            #expect(state.kind == .permission)
            #expect(state.key == "test-permission")
        }
        catch {
            Issue.record("Unexpected error type.")
        }
    }
}
