//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import XCTest

@testable import FeatherACL

final class FeatherACLTests: XCTestCase {

    func testGetACL() async throws {
        let res = try await AccessControl.exists(ACL.self)
        XCTAssertFalse(res)

        let acl = try await AccessControl.get(ACL.self)
        XCTAssertNil(acl)
    }

    func testSetACL() async throws {
        let acl = ACL(
            accountId: "test-id",
            roleKeys: ["test-role"],
            permissionKeys: ["test-permission"]
        )

        try await AccessControl.set(acl) {
            let res1 = try await AccessControl.exists(ACL.self)
            XCTAssertTrue(res1)

            let acl = try await AccessControl.get(ACL.self)
            XCTAssertNotNil(acl)

            try await AccessControl.unset(ACL.self) {
                let acl = try await AccessControl.get(ACL.self)
                XCTAssertNil(acl)
            }

            let res2 = try await AccessControl.exists(ACL.self)
            XCTAssertTrue(res2)
        }
    }

    func testRequireACL() async throws {
        let acl = ACL(
            accountId: "test-id",
            roleKeys: ["test-role"],
            permissionKeys: ["test-permission"]
        )

        try await AccessControl.set(acl) {
            let acl = try await AccessControl.require(ACL.self)
            try await acl.requireRole("test-role")
            try await acl.requirePermission("test-permission")
        }
    }

    func testUnauthorizedError() async throws {
        do {
            _ = try await AccessControl.require(ACL.self)
            XCTFail("Test case should fail.")
        }
        catch AccessControlError.unauthorized {
            // ok
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testACLForbiddenRoleError() async throws {
        let acl = ACL(accountId: "test-id")

        do {
            try await AccessControl.set(acl) {
                let acl = try await AccessControl.require(ACL.self)
                try await acl.requireRole("test-role")
            }
            XCTFail("Test case should fail.")
        }
        catch AccessControlError.forbidden(let state) {
            XCTAssertEqual(state.kind, .role)
            XCTAssertEqual(state.key, "test-role")
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testACLForbiddenPermissionError() async throws {
        let acl = ACL(accountId: "test-id")

        do {
            try await AccessControl.set(acl) {
                let acl = try await AccessControl.require(ACL.self)
                try await acl.requirePermission("test-permission")
            }
            XCTFail("Test case should fail.")
        }
        catch AccessControlError.forbidden(let state) {
            XCTAssertEqual(state.kind, .permission)
            XCTAssertEqual(state.key, "test-permission")
        }
        catch {
            XCTFail("\(error)")
        }
    }
}
