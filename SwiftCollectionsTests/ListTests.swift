import SwiftCollections
import XCTest

class ListTests: XCTestCase {

    let emptyList = List<Int>()
    let oneElementList = List(head: 10, tail: List())
    let twoElementList = List(head: 10, tail: List(head: 20, tail: List()))
    let fiveElementList = List(1,2,3,4,5)
    let tenElementList = List(1,2,3,4,5,6,7,8,9,10)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testIsEmptyForEmptyList() {
        XCTAssertTrue(emptyList.isEmpty)
    }

    func testIsEmptyForNonEmptyList() {
        XCTAssertFalse(oneElementList.isEmpty)
    }

    func testHeadForForNonEmptyList() {
        XCTAssertEqual(oneElementList.head, 10)
    }

    func DISABLED_testHeadForForEmptyList() {
        // TODO: Should test that emptyList.head throws an exception
        // This seems impossible to do at the moment
        //XCTAssertThrows(emptyList.head)
    }
    
    func testTailForForNonEmptyList() {
        XCTAssertTrue(oneElementList.tail.isEmpty)
    }

    func DISABLED_testTailForForEmptyList() {
        // TODO: Should test that emptyList.tail throws an exception
        // This seems impossible to do at the moment
        //XCTAssertThrows(emptyList.tail)
    }
    
    func testThatItCountsLength() {
        XCTAssertEqual(emptyList.count, 0)
        XCTAssertEqual(oneElementList.count, 1)
        XCTAssertEqual(twoElementList.count, 2)
    }
    
    func testThatConvenienceInitConstructsProperList() {
        XCTAssertEqual(fiveElementList.count, 5)
        XCTAssertEqual(fiveElementList.head, 1)
        XCTAssertEqual(fiveElementList.tail.head, 2)
        XCTAssertEqual(fiveElementList.tail.tail.head, 3)
        XCTAssertEqual(fiveElementList.tail.tail.tail.head, 4)
        XCTAssertEqual(fiveElementList.tail.tail.tail.tail.head, 5)
        XCTAssertTrue(fiveElementList.tail.tail.tail.tail.tail.isEmpty)
    }
    
    func testThatItCanBeEnumerated() {
        // When
        let doubled = map(fiveElementList) { $0 * 2 }
        // Then
        XCTAssertEqual(doubled, [2,4,6,8,10])
    }
}
