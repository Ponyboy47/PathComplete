import TrailBlazer

private func _complete(_ path: String? = nil,
                       types: Set<PathType> = PathType.allCases,
                       with children: DirectoryChildren) -> DirectoryChildren {
    var matches = children.lazy.filter { types.contains($0.type) }
    if let path = path {
        matches = matches.lazy.filter { $0.lastComponent?.hasPrefix(path) ?? false }
    }

    var children = DirectoryChildren()
    matches.forEach { children.append($0._path) }

    return children
}

public extension DirectoryChildren {
    mutating func updateCompletions(for path: String) {
        let files = self.files.filter { $0.lastComponent?.hasPrefix(path) ?? false }
        let directories = self.directories.filter { $0.lastComponent?.hasPrefix(path) ?? false }
        let sockets = self.sockets.filter { $0.lastComponent?.hasPrefix(path) ?? false }
        let other = self.other.filter { $0.lastComponent?.hasPrefix(path) ?? false }
        self = .init(files: files, directories: directories, sockets: sockets, other: other)
    }

    func updatedCompletions(for path: String) -> DirectoryChildren {
        var new = self
        new.updateCompletions(for: path)
        return new
    }
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
