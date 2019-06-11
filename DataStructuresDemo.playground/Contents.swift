import UIKit



//Check whether any pair exists whose sum is X
extension Collection where Iterator.Element: Comparable {
    
    func binarySearch(element: Iterator.Element) -> Bool {
        var low = startIndex
        var high = endIndex
        while low != high {
            let mid = index(low, offsetBy: distance(from: low, to: high)/2)
            if self[mid] < element {
                low = index(after: mid)
            } else if element < self[mid] {
                high = mid
            } else {
                return true
            }
        }
        return false
    }
}

func checkPairs(in numbers: [Int], forSum target: Int) -> Bool {
    
    return numbers.enumerated().contains(where: { (i, x) -> Bool in
        numbers[i+1 ..< numbers.count].binarySearch(element: target - x)
    })
}
checkPairs(in: [1,3,4,5], forSum: 8)
checkPairs(in: [1,3,4,5,6], forSum: 12)

//Find occurence of each character in a string and return the information
let name = "harshitha"
let list = Array(name)//["a", "b", "c", "d", "a", "c"]
//Creates a collection containing the specified number of the given element.
let ones = repeatElement(1, count: list.count)
//Creates a sequence of pairs built out of two underlying sequences.
//Creates a new dictionary from the key-value pairs in the given sequence, using a combining closure to determine the value for any duplicate keys.
let counted = Dictionary(zip(list, ones), uniquingKeysWith: +)
//["i": 1, "r": 1, "s": 1, "t": 1, "h": 3, "a": 2]

class TreeNode {
    var value: Int
    var leftChild: TreeNode?
    var rightChild: TreeNode?
    
    init(_ value: Int,_ leftChild: TreeNode?,_ rightChild: TreeNode?) {
        self.value = value
        self.rightChild = rightChild
        self.leftChild = leftChild
    }
}

let ten = TreeNode(10,nil,nil)
let one = TreeNode(0,nil,nil)
let third = TreeNode(3,nil,nil)
let fourth = TreeNode(4,nil,nil)
let five = TreeNode(5,ten,third)
let six = TreeNode(6,fourth,nil)
let root = TreeNode(2,five,six)
let root2 = TreeNode(2,five,six)

func inorderTraversal(_ root: TreeNode?) -> [Int] {
    if root == nil {
        return []
    }
    var result: [Int] = []
    result += inorderTraversal(root!.leftChild)
    result.append(root!.value)
    result += inorderTraversal(root!.rightChild)
    return result
}
inorderTraversal(root)
//Check two binary tree is identical or not
func isIdentical(_ root1: TreeNode?, root2: TreeNode?) -> Bool {
    if root1 == nil && root2 == nil {
        return true
    }
    if (root1 == nil && root2 != nil)  || (root1 != nil && root2 == nil) {
        return false
    }
    if root1?.value == root2?.value && isIdentical(root1?.leftChild, root2: root1?.leftChild) && isIdentical(root1?.rightChild, root2: root1?.rightChild) {
        return true
    }
    return false
}

isIdentical(root, root2: root2)



//Check whether number exists in form of 4n+1 or not
func checkNumber(_ num: Int) -> Bool {
    var low = 0
    var high = num
    while low <= high {
        let mid: Int = low + (high - low)/2
        let formattedNum: Int = 4*mid + 1
        if formattedNum == num {
            return true
        }
        if formattedNum > num {
            high = mid - 1
        }else {
            low = mid + 1
        }
    }
    return false
}

checkNumber(5)
checkNumber(6)
checkNumber(9)
