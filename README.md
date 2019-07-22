# PathComplete

A simple utility for completing paths when given a directory and pathname prefix

## Installation (SPM)

```swift
.package(url: "https://github.com/Ponyboy47/PathComplete.git", from: "0.2.0")
```

## Usage

```swift
let dir = DirectoryPath("/tmp")!

// Just returns everything in /tmp
var completions: DirectoryChildren = try dir.complete()

// Returns everything that begins with "log"
completions = try dir.complete("log")

// Return only the files found in /tmp
completions = try dir.complete(types: [.file])

// Opening the directory makes the completion function safe
let opened = try dir.open()

// Just returns everything in /tmp
completions = opened.complete()

// Returns everything that begins with "log"
completions = opened.complete("log")

// Return only the files found in /tmp
completions = opened.complete(types: [.file])
```

## License
MIT
