//
//  ACLSet.swift
//  feather-access-control
//
//  Created by Binary Birds on 2026. 02. 17.

//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/03/2024.
//

/// Describes a static collection of permissions for a domain or module.
public protocol ACLSet {
    /// Complete list of permissions defined by the set.
    static var all: [Permission] { get }
}
