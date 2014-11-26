private let MinBucketCount = 16
private let MaxLoad: Double = 0.5 // Resize the set if the item count exceeds this percentage of the bucket count

/// An unordered collection of unique objects.
///
/// Implemented using a hash table. Items in the set must implement Hashable.
///
/// Lookup, insert and delete should be O(1) operations.
public struct Set<T: Hashable> {

    private var buckets: ContiguousArray<List<T>>
    
    public init() {
        self.init(capacity: 0)
    }
    
    public init(_ values: [T]) {
        self.init(capacity: values.count)
        for v in values {
            insert(v)
        }
    }

    private init(capacity: Int) {
        let bucketCount = Set.bucketCountForCapacity(capacity)
        buckets = ContiguousArray(count: bucketCount, repeatedValue: List())
    }
    
    private static func bucketCountForCapacity(capacity: Int) -> Int {
        return max(MinBucketCount, Int(Double(capacity) / MaxLoad))
    }
    
    mutating func reserveCapacity(minimumCapacity: Int) {
        if (capacity < minimumCapacity) {
            let items = Array(self)
            self = Set(items)
        }
    }
    
    public var isEmpty: Bool { return count == 0 }
    public private(set) var count: Int = 0
    public var capacity: Int { return Int(Double(bucketCount) * MaxLoad) }

    private var bucketCount: Int {
        return buckets.count
    }

    public func contains(element: T) -> Bool {
        let bucketIndex = hash(element)
        let bucketContents = buckets[bucketIndex]
        return Swift.contains(bucketContents, element)
    }
    
    public mutating func insert(element: T) {
        let bucket = bucketForElement(element)
        if !Swift.contains(bucket.contents, element) {
            buckets[bucket.index] = List(head: element, tail: bucket.contents)
            count++
        }
    }

    private func removeFromList(list: List<T>, element: T) -> List<T> {
        if list.isEmpty {
            return list
        }
        else if list.head == element {
            return list.tail
        }
        else {
            return List(head: list.head, tail: removeFromList(list.tail, element: element))
        }
    }
    
    public mutating func remove(element: T) {
        let bucket = bucketForElement(element)
        if Swift.contains(bucket.contents, element) {
            buckets[bucket.index] = removeFromList(bucket.contents, element: element)
            count--
        }
    }

    private func hash(element: T) -> Int {
        return abs(element.hashValue) % buckets.count
    }
    
    private func bucketForElement(element: T) -> (index: Int, contents: List<T>) {
        let bucketIndex = hash(element)
        return (bucketIndex, buckets[bucketIndex])
    }
}

public struct SetGenerator<T: Hashable> : GeneratorType {
    var bucketsIterator: IndexingGenerator<ContiguousArray<List<T>>>
    var currentBucketIterator: ListGenerator<T>
    
    public init(set: Set<T>) {
        bucketsIterator = set.buckets.generate()
        currentBucketIterator = List().generate() // initialize with an empty list
    }
    
    public mutating func next() -> T? {
        while true {
            switch currentBucketIterator.next() {
            case .Some(let nextInCurrentBucket):
                // There is another item in the current bucket
                return nextInCurrentBucket
            case .None:
                // There are no more items in the current bucket
                // Advance to the next bucket
                switch bucketsIterator.next() {
                case .Some(let nextBucket):
                    // There is another bucket
                    // Reset the current bucket iterator to this bucket
                    currentBucketIterator = nextBucket.generate()
                case .None:
                    // There are no more buckets
                    return nil
                }
            }
        }
    }
}

extension Set : SequenceType {
    public func generate() -> SetGenerator<T> {
        return SetGenerator(set: self)
    }
}

extension Set : Printable {
    public var description: String {
        let itemDescriptions: [String] = map(self) { "\($0)" }
        return "<Set: \(count) items>: [" + ", ".join(itemDescriptions) + "]"
    }
}

extension Set : Printable {
    public var debugDescription: String {
        let bucketDescriptions = map(buckets) { $0.description }
        return "<Set: \(count) items in \(bucketCount) buckets>\n" + "\n".join(bucketDescriptions)
    }
}
