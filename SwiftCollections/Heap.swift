/// A tree-based data structure whose nodes are ordered in such a way that any 
/// parent node is always less than (or greater than) its children. At all
/// times, the root node is the smallest (or largest) element in the tree.
///
/// Items in the heap must implement Comparable. When creating a heap, you can
/// specify a function that determines how items should be ordered. The default
/// ordering is <, which specifies a min-heap: parent nodes are less than
/// their children, and the root node is the smallest element in the heap.
/// Call Heap(isOrderedBefore: { $0 > $1 }) to create a max-heap.
///
public struct Heap<T : Comparable> {
    
    public init(_ values: [T] = []) {
        self.init(values, isOrderedBefore: { $0 < $1 })
    }
    
    public init(isOrderedBefore: (T, T) -> Bool) {
        self.init([], isOrderedBefore)
    }
    
    // TODO: isOrderedBefore should be a default parameter, but that
    // crashes the Swift compiler with a segfault
    public init(_ values: [T], isOrderedBefore: (T, T) -> Bool) {
        self.isOrderedBefore = isOrderedBefore
        
        // TODO: Shorten this to O(n) (from O(n log n)) with a more efficient
        // heapify implementation
        // (see https://en.wikipedia.org/wiki/Heapsort#Pseudocode)
        for v in values {
            insert(v)
        }
    }
    
    public var isEmpty: Bool { return buffer.isEmpty }
    
    /// The number of elements in the heap
    public var count: Int { return buffer.count }
    
    /// The root element of the heap. The heap guarantees that this is always
    /// the element that is less than all other elements in the heap
    /// (as specified by the isOrderedBefore function).
    /// Results in a runtime error if the heap is empty.
    public var root: T {
        precondition(!isEmpty, "Accessing the root element of an empty heap")
        return buffer[0]
    }
    
    /// Inserts an item into the heap. Complexity: O(n)
    public mutating func insert(k: T) {
        // Insert the item at the end, then bubble up until the heap property
        // is restored.
        buffer.append(k)
        bubbleUp(buffer.count - 1)
    }
    
    /// Returns the root element after removing it from the heap.
    /// Results in a runtime error if the heap is empty.
    /// Complexity: O(n)
    public mutating func extractRoot() -> T {
        precondition(!isEmpty, "Accessing the root element of an empty heap")
        
        // Move the last element to the root position, then bubble down
        // until the heap property is restored.
        let previousRoot = root
        if count > 1 {
            buffer[0] = buffer.removeLast()
            bubbleDown(0)
        } else {
            buffer.removeLast()
        }
        return previousRoot
    }

    /// Returns true if the receiver satisfies the heap invariant,
    /// i.e., each parent nodes is ordered before its children.
    ///
    /// Used for testing. You should not need to call this in production code.
    public var isValid: Bool {
        for (index, k) in enumerate(buffer) {
            if let (_, parent) = parent(index) {
                if isOrderedBefore(k, parent) {
                    return false
                }
            }
        }
        return true
    }

    // The function that determines the ordering of the heap
    private let isOrderedBefore: (T, T) -> Bool
    
    private var buffer = [T]()

    /// Bubble-up the element k at the given index until heap invariant is
    /// restored (i.e., k's parent is ordered before k)
    private mutating func bubbleUp(index: Int) {
        if let (parentIndex, parent) = parent(index) {
            let k = buffer[index]
            if (isOrderedBefore(k, parent)) {
                buffer[parentIndex] = k
                buffer[index] = parent
                bubbleUp(parentIndex)
            }
        }
    }
    
    /// Bubble-down the element k at the given index until heap invariant is
    /// restored (i.e., k's children are ordered after k)
    private mutating func bubbleDown(index: Int) {
        if let (childIndex, child) = smallestChild(index) {
            let k = buffer[index]
            if (isOrderedBefore(child, k)) {
                buffer[childIndex] = k
                buffer[index] = child
                bubbleDown(childIndex)
            }
        }
    }

    /// Returns the index and value of the parent node of the given index.
    /// Returns nil if the node has no parent (i.e., the root node).
    private func parent(index: Int) -> (index: Int, value: T)? {
        switch index {
        case 0: return .None
        case _: return (index/2, buffer[index/2])
        }
    }
    
    /// Returns the index and value of a node's "smallest" child node.
    ///
    /// If the node has more than one child, this method uses isOrderedBefore
    /// to determine which of them is the "smallest" (i.e., ordered before all
    /// other children).
    /// Returns nil if the node has no children.
    private func smallestChild(index: Int) -> (index: Int, value: T)? {
        let leftChildIndex = 2 * index
        let rightChildIndex = (2 * index) + 1
        if (leftChildIndex >= count) {
            return .None
        } else if (rightChildIndex >= count) {
            return (leftChildIndex, buffer[leftChildIndex])
        } else {
            let leftChild = buffer[leftChildIndex]
            let rightChild = buffer[rightChildIndex]
            if isOrderedBefore(leftChild, rightChild) {
                return (leftChildIndex, leftChild)
            } else {
                return (rightChildIndex, rightChild)
            }
        }
    }
}

extension Heap : Printable {
    public var description: String {
        return buffer.description
    }
}
