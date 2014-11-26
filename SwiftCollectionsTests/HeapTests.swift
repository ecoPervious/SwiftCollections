import SwiftCollections
import XCTest

class HeapTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCountForEmptyHeap() {
        let emptyHeap = Heap<Int>()
        XCTAssertEqual(emptyHeap.count, 0)
    }
    
    func testCountForNonEmptyHeap() {
        var threeElementHeap = Heap<Int>()
        threeElementHeap.insert(5)
        threeElementHeap.insert(3)
        threeElementHeap.insert(1)
        XCTAssertEqual(threeElementHeap.count, 3)
    }
}
