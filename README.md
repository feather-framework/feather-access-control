# Feather Access Control

A universal access control library for server-side Swift projects.

[
    ![Release: 1.0.0-beta.1](https://img.shields.io/badge/Release-1%2E0%2E0--beta%2E1-F05138)
](
    https://github.com/feather-framework/feather-access-control/releases/tag/1.0.0-beta.1
)

## Features

- Async `AccessControlList` protocol for role/permission checks
- Task-local access control context via `AccessControl.set/get/require/unset`
- Default `ACL` implementation with static roles and permission keys
- Structured errors for unauthorized and forbidden access states
- Strongly typed `Permission` model with namespace/context/action structure
- Built-in CRUD action keys (`list`, `detail`, `create`, `update`, `delete`) plus custom actions

## Requirements

![Swift 6.1+](https://img.shields.io/badge/Swift-6%2E1%2B-F05138)
![Platforms: Linux, macOS, iOS, tvOS, watchOS, visionOS](https://img.shields.io/badge/Platforms-Linux_%7C_macOS_%7C_iOS_%7C_tvOS_%7C_watchOS_%7C_visionOS-F05138)

- Swift 6.1+

- Platforms:
  - Linux
  - macOS 15+
  - iOS 18+
  - tvOS 18+
  - watchOS 11+
  - visionOS 2+

## Installation

Use Swift Package Manager; add the dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/feather-framework/feather-access-control", exact: "1.0.0-beta.1"),
```

Then add `FeatherAccessControl` to your target dependencies:

```swift
.product(name: "FeatherAccessControl", package: "feather-access-control"),
```

## Usage

[
    ![DocC API documentation](https://img.shields.io/badge/DocC-API_documentation-F05138)
](
    https://feather-framework.github.io/feather-access-control/
)

Define account identifier, roles and permissions using an ACL object:

```swift
import FeatherAccessControl

let acl = ACL(
    accountId: "user-account-123",
    roles: [
        "editor"
    ],
    permissions: [
        "article:write",
        "article:read",
    ]
)
```

Set the ACL for a request/task and require access:

```swift
try await AccessControl.set(acl) {
    let acl = try await AccessControl.require(ACL.self)

    try await acl.require(role: "editor")
    try await acl.require(permission: "article:write")
}
```

Error behavior:

- `AccessControl.require(...)` throws `AccessControlError.unauthorized` when no ACL is set.
- `acl.require(role:)` / `acl.require(permission:)` throws `AccessControlError.forbidden` when access is missing.

> [!WARNING]
> This repository is a work in progress, things can break until it reaches v1.0.0.

## Development

- Build: `swift build`
- Test:
  - local: `swift test`
  - using Docker: `make docker-test`
- Format: `make format`
- Check: `make check`

## Contributing

[Pull requests](https://github.com/feather-framework/feather-access-control/pulls) are welcome. Please keep changes focused and include tests for new logic.
