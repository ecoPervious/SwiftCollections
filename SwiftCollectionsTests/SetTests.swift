import SwiftCollections
import Quick
import Nimble

class SetSpec: QuickSpec {
    
    override func spec() {
        
        describe("a set") {
            it("counts its elements") {
                let emptySet = Set<Int>()
                let set = Set([1,2,3,4,5])
                expect(emptySet.count) == 0
                expect(set.count) == 5
            }
            
            it("does not insert duplicate elements") {
                var set = Set<Int>()
                set.insert(10)
                set.insert(10)
                set.insert(10)
                expect(set.count) == 1
            }
            
            it("can delete elements") {
                var set = Set([1,2,3,3,7,8,9,8,8])
                set.remove(3)
                set.remove(8)
                expect(set.count) == 4
                expect(set.contains(3)).to(beFalse())
                expect(set.contains(8)).to(beFalse())
                expect(set.contains(7)).to(beTrue())
            }
            
            it("supports sequence enumeration") {
                let items = [11,22,33,44,55,66,77,88,99]
                let set = Set(items)
                let sortedSetElements = sorted(map(set) { $0 })
                expect(sortedSetElements).to(equal(items))
            }
            
            it("can look up its elements") {
                let set = Set(["Jane", "John", "Kathy", "Michael", "Kelly", "Thomas"])
                expect(set.contains("Kathy"))
                expect(set.contains("Linda"))
                expect(set.contains("Ben")).to(beFalse())
            }
        }
    }
}
