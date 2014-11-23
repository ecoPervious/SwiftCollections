/// An immutable singly linked list
///
/// Because it is immutable, List is a value type although it is implemented as a class.
/// The class implementation is necessary because Swift does not allow recursive value types (yet?).
public final class List<T> {
    private let h: T?
    private let t: List?
    
    public init() {
        h = nil
        t = nil
    }

    public init(head: T, tail: List<T>) {
        h = head
        t = tail
    }
    
    public convenience init(_ values: T...) {
        if let firstElement = values.first {
            let remainingElements = values[1..<values.count]
            let tail = remainingElements.reverse().reduce(List(), combine: { (tail, head) -> List in
                return List(head: head, tail: tail)
            })
            self.init(head: firstElement, tail: tail)
        }
        else {
            self.init()
        }
    }
    
    public var isEmpty: Bool {
        return h == nil
    }
    
    public var count: Int {
        if isEmpty { return 0 }
        else { return 1 + tail.count }
    }
    
    public var head: T {
        switch h {
        case .None: fatalError("Can’t get head of empty List")
        case .Some(let h): return h
        }
    }
    
    public var tail: List<T> {
        switch t {
        case .None: fatalError("Can’t get tail of empty List")
        case .Some(let t): return t
        }
    }
}

public struct ListGenerator<T> : GeneratorType {
    var list: List<T>

    public mutating func next() -> T? {
        if list.isEmpty {
            return nil
        }
        else {
            let head = list.head
            list = list.tail
            return head
        }
    }
}

extension List : SequenceType {
    public func generate() -> ListGenerator<T> {
        return ListGenerator(list: self)
    }
}

extension List : Printable {
    public var description: String {
        let elementDescriptions = map(self) { "\($0)" }
        return "[" + ", ".join(elementDescriptions) + "]"
    }
}

extension List : Printable {
    public var debugDescription: String {
        let elementDescriptions = map(self) { "\($0)" }
        return "List: [" + ", ".join(elementDescriptions) + "]"
    }
}
