//
//  PermissionCollection.swift
//  feather-access-control
//
//  Created by Binary Birds on 2026. 02. 17.

/// Describes a static collection of permissions for a domain or module.
public protocol PermissionCollection {
    /// Complete list of permissions defined by the set.
    static var permissions: [Permission] { get }
}
