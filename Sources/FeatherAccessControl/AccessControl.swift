//
//  File.swift
//
//
//  Created by Tibor Bodecs on 05/02/2024.
//

public enum AccessControl: Sendable {

    @TaskLocal
    private static var rawValue: ACLInterface?

    public static func set<T: ACLInterface, R>(
        _ acl: T?,
        _ block: (() async throws -> R)
    ) async throws -> R {
        try await $rawValue.withValue(acl) {
            try await block()
        }
    }

    public static func unset<T: ACLInterface, R>(
        _: T.Type,
        _ block: (() async throws -> R)
    ) async throws -> R {
        try await $rawValue.withValue(nil) {
            try await block()
        }
    }

    public static func get<T: ACLInterface>(
        _: T.Type
    ) async throws -> T? {
        rawValue as? T
    }

    public static func require<T: ACLInterface>(
        _: T.Type
    ) async throws -> T {
        guard let value = rawValue as? T else {
            throw AccessControlError.unauthorized
        }
        return value
    }

    public static func exists<T: ACLInterface>(
        _: T.Type
    ) async throws -> Bool {
        rawValue as? T != nil
    }
}
