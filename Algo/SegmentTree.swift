protocol SegTreeProtocol {
    associatedtype Node: Comparable
    var initialValue: Node { get  set }
    var tree: [Node] { get set }
    mutating func update(pos: Int, value: Node)
    func query(leading:  Int, trailing:  Int) -> Node
    var calculator : (Node,Node) -> Node { get set }
}

struct SegmentTree <T: Comparable>: SegTreeProtocol {

    var calculator: (T, T) -> T
    var initialValue: T
    var tree: [T]
    var leafs: Int = 1
    
    init(array: [T], action: @escaping (T,T) -> T, initialValue: T) {
        self.initialValue = initialValue
        calculator = action
        while leafs < array.count{ leafs *= 2 }
        tree = Array(repeatElement(initialValue, count: 2 * leafs))
        array.enumerated().forEach { (pos,value) in
            update(pos: pos + 1, value: value)
        }
    }
    init(arraySize: Int, action: @escaping (T,T) -> T, initialValue: T){
        self.initialValue = initialValue
        calculator = action
        while leafs < arraySize { leafs *= 2 }
        tree = Array(repeatElement(initialValue, count: 2 * leafs))
    }
    
     mutating func update(pos: Int, value: T) {
        var pivot = pos + leafs - 1
        tree[pivot] = value
        while pivot > 1 {
            tree[pivot / 2] = calculator(tree[pivot ^ 1] , tree[pivot])
            pivot /= 2
        }
    }
    
    func query( leading:  Int, trailing:  Int) -> T {
        var lPos = leading + leafs - 1
        var rPos = trailing + leafs - 1
        var result = initialValue
        while lPos <= rPos {
            if lPos % 2 == 1 {
                result = calculator(result,tree[lPos])
                lPos += 1
            }
            if rPos % 2 == 0 {
                result = calculator(result,tree[rPos])
                rPos -= 1
            }
            lPos /= 2
            rPos /= 2
        }
        return result
    }
}

let array = [3,1,4,1,5,9,2]

var minSegTree = SegmentTree(array: array, action: min, initialValue: Int.max)
var maxSegTree = SegmentTree(array: array, action: max, initialValue: Int.min)
var sumSegtree = SegmentTree(array: array, action: +, initialValue: 0)


print(minSegTree.query(leading: 1, trailing: 7)) // result 1
print(maxSegTree.query(leading: 1, trailing: 7)) // result 9
print(sumSegtree.query(leading: 1, trailing: 7)) // result 25

minSegTree.update(pos: 2, value: 10)
minSegTree.update(pos: 4, value: 10)
print(minSegTree.query(leading: 1, trailing: 7)) // result 2

maxSegTree.update(pos: 1, value: 100)
print(maxSegTree.query(leading: 1, trailing: 7)) // result 100


(1...array.count).forEach{
    sumSegtree.update(pos: $0, value: 0)
}
print(sumSegtree.query(leading: 1, trailing: 7)) // result 0


