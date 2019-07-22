import TrailBlazer

private func _complete(_ path: String? = nil,
                       types: Set<PathType> = PathType.allCases,
                       with children: DirectoryChildren) -> DirectoryChildren {
    var matches = children.filter { types.contains($0.type) }
    if let path = path {
        matches = matches.filter { $0.lastComponent?.hasPrefix(path) ?? false }
    }

    var children = DirectoryChildren()
    matches.forEach { children.append($0) }

    return children
}

public extension DirectoryPath {
    func complete(_ path: String? = nil, types: Set<PathType> = PathType.allCases) throws -> DirectoryChildren {
        return try _complete(path, types: types, with: children(options: .includeHidden))
    }
}

public extension Open where PathType == DirectoryPath {
    func complete(_ path: String? = nil, types: Set<TrailBlazer.PathType> = TrailBlazer.PathType.allCases) -> DirectoryChildren {
        return _complete(path, types: types, with: children(options: .includeHidden))
    }
}
