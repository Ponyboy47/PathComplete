import TrailBlazer

public let allPathTypes: Set<PathType> = [.socket, .link, .regular, .block, .directory, .character, .fifo]

private func _complete(_ path: String? = nil,
                       types: Set<PathType> = allPathTypes,
                       with children: DirectoryChildren) -> DirectoryChildren {
    var matches = children.filter { types.contains($0.type) }
    if let path = path {
        matches = matches.filter { $0.lastComponent?.hasPrefix(path) ?? false }
    }

    var children = DirectoryChildren()
    matches.forEach { children.append($0) }

    return children
}

public final class CompletionManager {
    private let children: DirectoryChildren

    public init(directory: DirectoryPath) throws {
        children = try directory.children(options: .includeHidden)
    }

    public init(opened directory: Open<DirectoryPath>) {
        children = directory.children(options: .includeHidden)
    }

    public func complete(_ path: String? = nil, types: Set<PathType> = allPathTypes) -> DirectoryChildren {
        return _complete(path, types: types, with: children)
    }
}

public extension DirectoryPath {
    func complete(_ path: String? = nil, types: Set<PathType> = allPathTypes) throws -> DirectoryChildren {
        return try _complete(path, types: types, with: children(options: .includeHidden))
    }
}

public extension Open where PathType == DirectoryPath {
    func complete(_ path: String? = nil, types: Set<TrailBlazer.PathType> = allPathTypes) -> DirectoryChildren {
        return _complete(path, types: types, with: children(options: .includeHidden))
    }
}
