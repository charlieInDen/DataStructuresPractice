import UIKit

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
