import XCTest
import TrailBlazer
@testable import PathComplete

final class PathCompleteTests: XCTestCase {
    private func setup() -> (Open<DirectoryPath>, DirectoryChildren, DirectoryChildren, DirectoryChildren, DirectoryChildren) {
        let tmp: Open<DirectoryPath>
        do {
            tmp = try DirectoryPath.temporary()
        } catch {
            fatalError("Failed to set up test files/directories")
        }

        do {
            var test1 = FilePath(tmp.path + "test1")!
            var test2 = FilePath(tmp.path + "test2")!
            var test3 = FilePath(tmp.path + "3test")!
            var test4 = FilePath(tmp.path + "4test")!
            var test5 = DirectoryPath(tmp.path + "test5")!
            var test6 = DirectoryPath(tmp.path + "test6")!
            var test7 = DirectoryPath(tmp.path + "7test")!
            var test8 = DirectoryPath(tmp.path + "8test")!

            try test1.create()
            try test2.create()
            try test3.create()
            try test4.create()
            try test5.create()
            try test6.create()
            try test7.create()
            try test8.create()

            let results1 = DirectoryChildren(files: [test1, test2, test3, test4], directories: [test8, test7, test6, test5])
            let results2 = DirectoryChildren(files: [test1, test2], directories: [test6, test5])
            let results3 = DirectoryChildren(files: [test1, test2, test3, test4])
            let results4 = DirectoryChildren(directories: [test6, test5])

            return (tmp, results1, results2, results3, results4)
        } catch {
            var path = tmp.path
            try? path.recursiveDelete()
            fatalError("Failed to set up test files/directories")
        }
    }

    func testPathCompletion() {
        let (tmp, results1, results2, results3, results4) = setup()

        do {
            let completions1 = try tmp.path.complete()
            let completions2 = try tmp.path.complete("test")
            let completions3 = try tmp.path.complete(types: [.file])
            let completions4 = try tmp.path.complete("test", types: [.directory])
            XCTAssertEqual(completions1, results1)
            XCTAssertEqual(completions2, results2)
            XCTAssertEqual(completions3, results3)
            XCTAssertEqual(completions4, results4)
        } catch {
            XCTFail("Failed to get completions from directory path")
        }

        var path = tmp.path
        try? path.recursiveDelete()
    }

    func testOpenCompletion() {
        let (tmp, results1, results2, results3, results4) = setup()

        XCTAssertEqual(tmp.complete(), results1)
        XCTAssertEqual(tmp.complete("test"), results2)
        XCTAssertEqual(tmp.complete(types: [.file]), results3)
        XCTAssertEqual(tmp.complete("test", types: [.directory]), results4)

        var path = tmp.path
        try? path.recursiveDelete()
    }

    func testUpdateCompletion() {
        let (tmp, _, results2, _, _) = setup()

        let completions = tmp.complete()
        XCTAssertEqual(completions.updatedCompletions(for: "test"), results2)

        var path = tmp.path
        try? path.recursiveDelete()
    }

    static var allTests = [
        ("testPathCompletion", testPathCompletion),
        ("testOpenCompletion", testOpenCompletion),
        ("testUpdateCompletion", testUpdateCompletion)
    ]
}
