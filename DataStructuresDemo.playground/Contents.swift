import UIKit

   func transpose(_ matrix: inout [[Int]]) {
    let row = matrix.count
    guard row > 0 else {
        return
    }
    let col = matrix[0].count
    
    //Convert row to col
    for i in 0..<row {
        for j in i..<col {
            if i != j {
                let temp = matrix[i][j]
                matrix[i][j] = matrix[j][i]
                matrix[j][i] = temp
            }
        }
    }
}

func reverseRow(_ matrix: inout [[Int]]) {
    let row = matrix.count
    guard row > 0 else {
        return
    }
    let col = matrix[0].count
    for i in 0..<row {
        var left = 0
        var right = col - 1
        while left < right {
            let temp = matrix[i][left]
            matrix[i][left] = matrix[i][right]
            matrix[i][right] = temp
            left = left + 1
            right = right - 1
        }
    }
}
func printMatrix(_ matrix: [[Int]]) {
    let row = matrix.count
    guard row > 0 else {
        return
    }
    for i in 0..<row {
            print(matrix[i])
    }
}

func rotate(_ matrix: inout [[Int]]) {
    transpose(&matrix)
    reverseRow(&matrix)
     printMatrix(matrix)
}
var matrix =
    [
        [ 5, 1, 9,11],
        [ 2, 4, 8,10],
        [13, 3, 6, 7],
        [15,14,12,16]
]
rotate(&matrix)
//Find minimum index such that a[i] = i
//var a = [-1, 0, 1, 2, 4, 10]
var a = [0, 2,3,4,5]
func search(_ a: [Int], start: Int, end: Int) -> Int {
    if start < end {
        let mid = start + (end - start)/2
        if a[mid] == mid {
            return mid
        }
        if a[mid] > mid {
            return search(a, start: start, end: mid - 1)
        }
        return search(a, start: mid + 1, end: end)
    }
    return -1
}
print(search(a, start: 0, end: 5))


//Max Path Sum
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}
func calculateSum(_ root: TreeNode?,result: inout Int) -> Int {
    guard let currentNode = root else {
        return 0
    }
    let left = max(0,calculateSum(currentNode.left, result: &result))
    let right = max(0,calculateSum(currentNode.right, result: &result))
    result = max(result, left + right + currentNode.val)
    print(result)
    print(left,right, currentNode.val + max(left, right))
    return currentNode.val + max(left, right)
}

func maxPathSum(_ root: TreeNode?) -> Int {
    var ans = Int.min
    calculateSum(root,result: &ans)
    return ans
}
var root: TreeNode? = TreeNode(1)
root?.left = TreeNode(2)
root?.right = nil
root?.left?.left = TreeNode(3)
root?.left?.right = nil
root?.left?.left?.left = TreeNode(4)
root?.left?.right?.right = nil
root?.left?.left?.left?.left = TreeNode(5)
root?.left?.right?.right?.right = nil
print(maxPathSum(root))


//Doubly linklist & LRU Cache
class List<Key: Hashable> {
    class ListNode<Key: Hashable> {
        let key: Key
        var value: Any
        var next: ListNode<Key>?
        weak var previous: ListNode<Key>?
        init(key: Key, value: Any) {
            self.key = key
            self.value = value
        }
    }
    
    public let maxSize: Int
    public var size: Int = 0
    private var head: ListNode<Key>?
    private var tail: ListNode<Key>?
    
    init(size: Int) {
        self.maxSize = size
    }
    public func remove(_ node: ListNode<Key>) {
        if size <= 0 {
            return
        }
        let previousNode = node.previous
        let nextNode = node.next
        if let previous = previousNode {
            previous.next = nextNode
        }else {
            head = nextNode
        }
        if let next = nextNode {
            next.previous = previousNode
        }
        node.next = nil
        node.previous = nil
    }
    public func insert(_ node:  ListNode<Key>) {
        size = size + 1
        if let currentNode = head {
            node.next = currentNode
            currentNode.previous = node
        }else {
            head = node
            tail = node
        }
    }
    public func dropLast() -> Key {
        guard let previous = tail?.previous else {
            let key = tail!.key
            tail = nil
            return key
        }
        tail = previous
        previous.next = nil
        return previous.key
    }
    
}
//LRU Cache
class LRUCache<Key: Hashable> {
    private let list: List<Key>
    private var hashMap: [Key: List<Key>.ListNode<Key>] = [:]
    init( size: Int) {
        self.list = List<Key>(size: size)
    }
    public func set(value: Any, for key:Key) {
        if let node = hashMap[key] {
            remove(key)
            node.value = value
            insert(node,  for: key)
        } else {
            let node = List<Key>.ListNode<Key>(key: key, value: value)
            insert(node,  for: key)
        }
    }
    public func get(_ key: Key) -> Any? {
        guard let node = hashMap[key] else {
            return nil
        }
        remove(key)
        insert(node, for: key)
        return node.value
    }
    private func remove(_ key: Key) {
        guard let node = hashMap[key] else {
            return
        }
        // remove from doubly link list
        list.remove(node)
        // remove from hashmap
        hashMap.removeValue(forKey: key)
    }
    private func insert(_ node: List<Key>.ListNode<Key>, for key: Key) {
        if list.size == list.maxSize {
            let droppedKey =  list.dropLast()
            hashMap.removeValue(forKey: droppedKey)
        }
        list.insert(node)
        hashMap[key] = node
    }
}

let cache = LRUCache<String>(size: 3)
cache.set(value: "Time", for: "Money")
cache.set(value: "Time1", for: "Money1")
cache.set(value: "Time2", for: "Money2")
cache.set(value: "Time2", for: "Money2")
cache.get("Money")
cache.get("Money1")
cache.set(value: "Time1", for: "Money1")
cache.set(value: "Time1", for: "Money1")
cache.set(value: "Time1", for: "Money1")
cache.get("Money2")
cache.get("Money1")

//An empty digit sequence is considered to have one decoding. It may be assumed that the input contains valid digits from 0 to 9 and there are no leading 0’s, no extra trailing 0’s and no two or more consecutive 0’s.
func countPossibleDecode(string: String) -> Int {
    //Convert to int array
    let intArray = string.map({ Int(String($0)) ?? 0 })
    var n2Count = 1
    var n1Count = 1
    var n2 = 0
    var n1 = 0
    //Traverse int array
    for (index, charNum) in intArray.enumerated() {
        var result = 0
        switch index {
        case 0:
            n1 = charNum
        case 1:
            n2 = charNum
        default:
            //Update two digits
            n1 = n2
            n2 = charNum
        }
        //Checking for single digit
        if n2 > 0 {
            result = n2Count
        }
        //Checking for 26 or more
        if (n1 == 1 || n1 == 2) && n2 < 7 {
            result = result + n1Count
            n1Count = n2Count
            n2Count = result
        }
    }
    return n2Count
}
//121 - "ABA", "AU", "LA"
//1234 - "ABCD", "LCD", "AWD"
countPossibleDecode(string: "121")
countPossibleDecode(string: "1234")


// Implement Trie
//T type should conform to hashable so that it can be used as key in a dictionary
class TrieNode<T: Hashable> {
    var child: [T: TrieNode] = [:]
    var leafNode: Bool = false
    init() {
    }
}

class Trie {
    let root: TrieNode<Character>
    init() {
        root = TrieNode()
    }
    
    /// Insert words in a Trie
    /// - Parameter word: Made of letters
    func insert(word: String) {
        guard !word.isEmpty else {
            return
        }
        var currentNode = root
        //Read each character and store in currentNode following its depth
        for (index, letter) in word.enumerated() {
            if let childNode = currentNode.child[letter] {
                currentNode = childNode
            } else {
                let node = TrieNode<Character>()
                currentNode.child[letter] = node
                //Update current node to connect the letters
                currentNode = node
            }
            if index == word.count - 1 {
                currentNode.leafNode = true
            }
        }
    }
    /// Search string in a Trie data structure
    /// - Parameter word: Searchable string
    func search(word: String) -> Bool {
        // Empty string returns false
        guard !word.isEmpty else {
            return false
        }
        // Fetch root node
        var currentNode = root
        //Read each character of searchable string and check whether corresponding child exists or not
        for (index, letter) in word.enumerated() {
            guard let node = currentNode.child[letter] else {
                return false
            }
            currentNode = node
            if currentNode.leafNode && index == word.count - 1 {
                return true
            }
        }
        return false
    }
}

let trie = Trie()
trie.insert(word: "seed")
trie.insert(word: "weed")
trie.insert(word: "need")
trie.insert(word: "ate")
trie.insert(word: "tend")
trie.insert(word: "rent")
trie.search(word: "rent")
trie.search(word: "aten")
trie.search(word: "need")
//Boggle matrix size
let m = 3
let n = 3
let boogle: [[Character]] = [["r","w","e"], ["t","e","d"], ["s","a","n"]]
//Possible directions to visit
let eightDirections = [(1,0),(0,1),(-1,0),(0,-1),(-1,1),(1,1),(1,-1),(-1,-1)]
var findWords: [String] = []


/// To check the next move is safe or not
/// - Parameters:
///   - i: row
///   - j: column
///   - visited: visited information for row & column
func isSafe(i: Int, j: Int, visited: [[Bool]]) -> Bool {
    return (i >= 0 && j >= 0 && i < m && j < n && !visited[i][j])
}

/// Search possible words from boggle array
/// - Parameters:
///   - root: Trie root node
///   - boggle: 2D Matrix filled with characters
///   - i: row
///   - j: column
///   - visited: visited information for row & column
///   - string: possible string
func searchWord(root: TrieNode<Character>, boggle: [[Character]], i: Int, j: Int, visited: inout [[Bool]], string: String) {
    if root.leafNode && findWords.contains(string) == false {
            findWords.append(string)
    }
    // DFS Implementation
    if isSafe(i: i, j: j, visited: visited) {
        visited[i][j] = true
        for direction in eightDirections {
            let newRow = i + direction.0
            let newCol = j + direction.1
            if isSafe(i: newRow, j: newCol, visited: visited) && (root.child[boggle[newRow][newCol]] != nil) {
                let result = string + [boggle[newRow][newCol]]
                searchWord(root: root.child[boggle[newRow][newCol]]!, boggle: boggle, i: newRow, j: newCol, visited: &visited, string: result)
            }
        }
        visited[i][j] = false
    }
}
/// finding possible words through boggling around boggle matrix
/// - Parameters:
///   - boggle: 2D Matrix
///   - root: Trie root node
func findPossibleWordsInBoogle(_ boggle:[[Character]], root: TrieNode<Character>) {
    var visited = [[false, false, false], [false, false, false], [false, false, false]]
    var result = ""
    for x in 0..<m {
        for y in 0..<n {
            if root.child[boggle[x][y]] != nil {
                result = result + [boggle[x][y]]
                searchWord(root: root.child[boggle[x][y]]!, boggle: boggle, i: x, j: y, visited: &visited, string: result)
                result = ""
            }
        }
    }
}

findPossibleWordsInBoogle(boogle, root: trie.root)
print(findWords)



// Given an array of size n, find the majority element. The majority element is the element that appears more than ⌊ n/2 ⌋ times.
// You may assume that the array is non-empty and the majority element always exist in the array.
class Solution {
// Given sorted array of numbers and a sum. we have to find any two numbers whose sum is equal to the given sum.
// Time Complexity: O(n)
    func findClosestPairInSortedArray(nums: [Int],forValue val:Int) -> (Int, Int) {
        var left = 0
        var right = nums.count - 1
        var result = (-1, -1)
        var minDiffBetweenPairs = Int.max
        while left < right {
            if abs(nums[left] + nums[right] - val) < minDiffBetweenPairs {
                minDiffBetweenPairs = abs(nums[left] + nums[right] - val)
                result = (left, right)
            }
            if (nums[left] + nums[right]) < val {
                left = left + 1
            } else {
                right = right - 1
            }
        }
        print(result)
        return result
    }

    func majorityElement(_ nums: [Int]) -> Int {
        var majIndex = 0
        var count = 1
        //Find possible majority element loops through each element and maintains a count of nums[majIndex]. If the next element is same then increment the count, if the next element is not same then decrement the count, and if the count reaches 0 then changes the majIndex to the current element and set the count again to 1. So, the first phase of the algorithm gives us a major candidate element.
        for i in 1..<nums.count {
            if nums[majIndex] == nums[i] {
                count = count + 1
            }else {
                count = count - 1
            }
            if count == 0 {
                majIndex = i
                count = 1
            }
        }
        var result = 0
        //Validate whether it has majority or not
        for i in 0..<nums.count {
            if nums[i] == nums[majIndex] {
                result = result + 1
            }
        }
        if result > nums.count/2 {
            return nums[majIndex]
        }else {
            return -1
        }
        
    }
}


// Given a m x n matrix, if an element is 0, set its entire row and column to 0. Do it in-place.
class Solution {
    func setZeroes(_ matrix: inout [[Int]]) {
        if matrix.count == 0 {
            return
        }
        //Define two flags for initial row and column to store whether initially row or column contain any zero or not
        var hasZeroInRow = false
        var hasZeroInCol = false
        let rowCount = matrix.count
        let colCount = matrix[0].count
        let rowArr = matrix[0]
        for item in rowArr {
            if item == 0 {
                hasZeroInRow = true
                break
            }
        }
        for i in 0..<rowCount {
             if matrix[i][0] == 0 {
                 hasZeroInCol = true
                 break
             }
        }
        //Check for other zero in remaining rows and column
        for (i,row) in matrix.enumerated() {
            for (j,_) in row.enumerated() {
                if i != 0 && j != 0 && matrix[i][j] == 0 {
                    matrix[i][0] = 0
                    matrix[0][j] = 0
                }
            }
        }
        //Time to make row and col zero
        for (i,row) in matrix.enumerated() {
            for (j,_) in row.enumerated() {
                if i != 0 && j != 0 && (matrix[i][0] == 0 || matrix[0][j] == 0) {
                    matrix[i][j] = 0
                }
            }
        }
        //Make row and col zero if hasZero flags are enabled
        for i in 0..<rowCount {
            if hasZeroInCol == true {
                matrix[i][0] = 0
            }
        }
        
        for i in 0..<colCount {
            if hasZeroInRow == true {
                matrix[0][i] = 0
            }
        }
    }
}

/* Given a sorted array nums, remove the duplicates in-place such that each element appear only once and return the new length.

Do not allocate extra space for another array, you must do this by modifying the input array in-place with O(1) extra memory.

*/
func removeDuplicates(_ nums: inout [Int]) -> Int {
    if nums.count == 0 || nums.count == 1 {
        return nums.count
    }
    var stPoint: Int = 0
    var curPoint: Int = 1
    while curPoint < nums.count {
        if nums[curPoint] != nums[stPoint] {
            stPoint = stPoint + 1
            nums.swapAt(stPoint, curPoint)
        }
        curPoint = curPoint + 1
    }
    return stPoint + 1
}

//Given nums = [0,0,1,1,1,2,2,3,3,4],
//
//Your function should return length = 5, with the first five elements of nums being modified to 0, 1, 2, 3, and 4 respectively.
//It doesn't matter what values are set beyond the returned length.




/* Say you have an array for which the ith element is the price of a given stock on day i.
 
 Design an algorithm to find the maximum profit. You may complete as many transactions as you like (i.e., buy one and sell one share of the stock multiple times).
 
 Note: You may not engage in multiple transactions at the same time (i.e., you must sell the stock before you buy again).
 */
func maxProfit(_ prices: [Int]) -> Int {
    var result = 0
    var i = 0
    var buy = 0
    var sell = 0
    while i < prices.count {
        while (i < prices.count - 1) && (prices[i+1] < prices[i]) {
            i = i + 1
        }
        if i == prices.count - 1 {
            break
        }
        buy = prices[i]
        i = i + 1
        while (i < prices.count) && (prices[i - 1] < prices[i]) {
            i = i + 1
        }
        sell = prices[i-1]
        
        result = result + sell - buy
        print(result)
    }
    return result
}
//Input: [7,1,5,3,6,4]
//Output: 7
//Explanation: Buy on day 2 (price = 1) and sell on day 3 (price = 5), profit = 5-1 = 4.
//Then buy on day 4 (price = 3) and sell on day 5 (price = 6), profit = 6-3 = 3.




//Given an array, rotate the array to the right by k steps, where k is non-negative.

func gcd(_ a:Int,_ b:Int) -> Int {
    if b == 0 {
        return a
    }
    return gcd(b, a%b)
}
func rotate(_ nums: inout [Int], _ diff: Int) {
    var d = diff
    if nums.count == 0 || nums.count == 1 {
        return
    }
    while d > nums.count {
        d = d - nums.count
    }
    let k = nums.count - d
    let nSet = gcd(nums.count, k)

    for i in 0..<nSet {
        let t = nums[i]
        var j = i
        
        while true {
            var x = j + k
            if x >= nums.count {
                x = x - nums.count
            }
            if x == i {
                break
            }
            nums[j] = nums[x]
            j = x
        }
        nums[j] = t
    }
}
//Input: [1,2,3,4,5,6,7] and k = 3
//Output: [5,6,7,1,2,3,4]
var input = [1,2,3,4,5,6,7]
rotate(&input, 3)


//Given an array of integers, find if the array contains any duplicates.
//
//Your function should return true if any value appears at least twice in the array, and it should return false if every element is distinct.

func containsDuplicate(_ nums: [Int]) -> Bool {
    if nums.count == 0 || nums.count == 1 {
        return false
    }
    let result = Set(nums)
    if result.count != nums.count {
        return true
    }
    return false
}
//Input: [1,1,1,3,3,4,3,2,4,2]
//Output: true


//Given a non-empty array of integers, every element appears twice except for one. Find that single one.
//Note:Your algorithm should have a linear runtime complexity. Could you implement it without using extra memory?
func singleNumber(_ nums: [Int]) -> Int {
    
    var result = nums[0]
    for i in 1..<nums.count {
        result = result ^ nums[i]
    }
    return result
}

//Input: [4,1,2,1,2]
//Output: 4


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

 @propertyWrapper
struct Limit<V: Comparable> {
  var value: V
  let min: V
  let max: V

  init(wrappedValue: V, min: V, max: V) {
    value = wrappedValue
    self.min = min
    self.max = max
    assert(value >= min && value <= max)
  }

  var wrappedValue: V {
    get { return value }
    set {
      if newValue < min {
        value = min
      } else if newValue > max {
        value = max
      } else {
        value = newValue
      }
    }
  }
}

@propertyWrapper
struct SpaceRemover {
    private(set) var value: String = ""

    var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    init(initialValue: String) {
        self.wrappedValue = initialValue
    }
}
