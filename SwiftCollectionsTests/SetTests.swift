import SwiftCollections
import XCTest

class SetTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCountForEmptySet() {
        let emptySet = Set<Int>()
        XCTAssertEqual(emptySet.count, 0)
    }

    func testCountForNonEmptySet() {
        let set = Set([1,2,3,4,5])
        XCTAssertEqual(set.count, 5)
    }
    
    func testThatDuplicatesAreNotInserted() {
        // Given
        var set = Set<Int>()
        // When
        set.insert(10)
        set.insert(10)
        set.insert(10)
        // Then
        XCTAssertEqual(set.count, 1)
    }
    
    func testThatItemsCanBeRemoved() {
        // Given
        var set = Set(Array(1...10))
        // When
        set.remove(3)
        set.remove(8)
        // Then
        XCTAssertEqual(set.count, 8)
        XCTAssertFalse(set.contains(3))
        XCTAssertFalse(set.contains(8))
        XCTAssertTrue(set.contains(7))
    }
    
    func testSequenceEnumeration() {
        // Given
        let items = [11,22,33,44,55,66,77,88,99]
        let set = Set(items)
        // When
        let sortedSetElements = sorted(map(set) { $0 })
        // Then
        XCTAssertEqual(sortedSetElements, items)
    }
    
    func testContains() {
        let set = Set(["Jane", "John", "Kathy", "Michael", "Kelly", "Thomas"])
        XCTAssertTrue(set.contains("Kathy"))
        XCTAssertFalse(set.contains("Linda"))
    }
}
