//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

public enum AccessControlError: Error {

    public struct State: Sendable {

        public enum Kind: Sendable {
            case permission
            case role
            //            case access
        }

        public let key: String
        public let kind: Kind

        public init(
            key: String,
            kind: Kind
        ) {
            self.key = key
            self.kind = kind
        }
    }

    case unauthorized
    case forbidden(State)
}
