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
        let threeElementHeap = Heap([5,3,1])
        XCTAssertEqual(threeElementHeap.count, 3)
    }
    
    func testThatInsertPreservesHeapInvariant() {
        var heap = Heap<Int>()
        for k in [10,8,6,4,2,7,5,13,4,2] {
            heap.insert(k)
            XCTAssertTrue(heap.isValid)
        }
        XCTAssertEqual(heap.root, 2)
    }
    
    func testThatExtractRootPreservesHeapInvariant() {
        let values = [10,8,6,4,2,7,5,13,4,2]
        var heap = Heap<Int>(values)
        
        for k in sorted(values) {
            let extractedRoot = heap.extractRoot()
            XCTAssertEqual(extractedRoot, k)
            XCTAssertTrue(heap.isValid)
        }
    }
    
    func testThatInsertIncrementsCount() {
        var heap = Heap<Int>()
        XCTAssertEqual(heap.count, 0)
        heap.insert(10)
        XCTAssertEqual(heap.count, 1)
        heap.insert(5)
        XCTAssertEqual(heap.count, 2)
    }

    func testThatExtractRootDecrementsCount() {
        var heap = Heap(["Amy", "Bob", "Christina", "Dan"])
        XCTAssertEqual(heap.count, 4)
        heap.extractRoot()
        XCTAssertEqual(heap.count, 3)
        heap.extractRoot()
        XCTAssertEqual(heap.count, 2)
        heap.extractRoot()
        XCTAssertEqual(heap.count, 1)
        heap.extractRoot()
        XCTAssertEqual(heap.count, 0)
    }
    
    func testThatOrderingCanBeCustomized() {
        let heap = Heap([1,2,3,4,5,6,7,8,9,10], isOrderedBefore: { $0 > $1 })
        XCTAssertEqual(heap.root, 10)
    }
}
