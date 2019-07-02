import XCTest
import TrailBlazer
@testable import PathComplete

final class PathCompleteTests: XCTestCase {
    private func setup() -> (Open<DirectoryPath>, DirectoryChildren, DirectoryChildren) {
        let tmp: Open<DirectoryPath>
        do {
            tmp = try DirectoryPath.temporary()
        } catch {
            fatalError("Failed to set up test files/directories")
        }

        do {
            var test1 = FilePath(tmp.path + "test1")!
            var test2 = FilePath(tmp.path + "test2")!
            var test3 = DirectoryPath(tmp.path + "test3")!
            var test4 = DirectoryPath(tmp.path + "4test")!

            try test1.create()
            try test2.create()
            try test3.create()
            try test4.create()

            let results1 = DirectoryChildren(files: [test1, test2], directories: [test3, test4])
            let results2 = DirectoryChildren(directories: [test4])

            return (tmp, results1, results2)
        } catch {
            var path = tmp.path
            try? path.recursiveDelete()
            fatalError("Failed to set up test files/directories")
        }
    }

    func testCompletionManagerPath() {
        let (tmp, results1, results2) = setup()

        do {
            let manager = try CompletionManager(directory: tmp.path)
            XCTAssertEqual(manager.complete(), results1)
            XCTAssertEqual(manager.complete("4"), results2)
        } catch {
            XCTFail("Failed to create completion manager with error: \(error)")
        }

        var path = tmp.path
        try? path.recursiveDelete()
    }

    func testCompletionManagerOpen() {
        let (tmp, results1, results2) = setup()

        let manager = CompletionManager(opened: tmp)
        XCTAssertEqual(manager.complete(), results1)
        XCTAssertEqual(manager.complete("4"), results2)

        var path = tmp.path
        try? path.recursiveDelete()
    }

    func testPathCompletion() {
        let (tmp, results1, results2) = setup()

        do {
            let completions1 = try tmp.path.complete()
            let completions2 = try tmp.path.complete("4")
            XCTAssertEqual(completions1, results1)
            XCTAssertEqual(completions2, results2)
        } catch {
            XCTFail("Failed to get completions from directory path")
        }

        var path = tmp.path
        try? path.recursiveDelete()
    }

    func testOpenCompletion() {
        let (tmp, results1, results2) = setup()

        XCTAssertEqual(tmp.complete(), results1)
        XCTAssertEqual(tmp.complete("4"), results2)

        var path = tmp.path
        try? path.recursiveDelete()
    }

    static var allTests = [
        ("testCompletionManagerPath", testCompletionManagerPath),
        ("testCompletionManagerOpen", testCompletionManagerOpen),
        ("testPathCompletion", testPathCompletion),
        ("testOpenCompletion", testOpenCompletion)
    ]
}
