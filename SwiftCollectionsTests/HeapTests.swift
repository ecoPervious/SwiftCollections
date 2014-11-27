import SwiftCollections
import Quick
import Nimble

class HeapSpec : QuickSpec {
    override func spec() {
        describe("a heap") {
            it("counts its elements") {
                let emptyHeap = Heap<Int>()
                let nonEmptyHeap = Heap<Int>([5,3,1,2,4])
                expect(emptyHeap.count) == 0
                expect(nonEmptyHeap.count) == 5
            }
            
            context("when items are inserted") {
                it("increments the item count") {
                    var heap = Heap<Int>()
                    var expectedCount = 0
                    let values = [10, 5, -10]
                    for k in values {
                        heap.insert(k)
                        expectedCount++
                        expect(heap.count) == expectedCount
                    }
                }

                it("preserves the heap invariant") {
                    var heap = Heap<Int>()
                    for k in [10,8,6,4,2,7,5,13,4,2] {
                        heap.insert(k)
                        expect(heap.isValid)
                    }
                    expect(heap.root) == 2
                }
            }
            
            context("when the root is extracted") {
                it("decrements the item count") {
                    var heap = Heap(["Amy", "Bob", "Christina", "Dan"])
                    var expectedCount = 4
                    while !heap.isEmpty {
                        heap.extractRoot()
                        expectedCount--
                        expect(heap.count) == expectedCount
                    }
                }
                
                it("preserves the heap invariant") {
                    let values = [10,8,6,4,2,7,5,13,4,2]
                    var heap = Heap<Int>(values)
                    for k in sorted(values) {
                        let extractedRoot = heap.extractRoot()
                        expect(extractedRoot) == k
                        expect(heap.isValid)
                    }
                }
            }
            
            context("with a custom ordering function") {
                it("preserves the heap invariant") {
                    let heap = Heap([1,2,3,4,5,6,7,8,9,10], isOrderedBefore: { $0 > $1 })
                    expect(heap.root) == 10
                }
            }
        }
    }
}
