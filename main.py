import os
import importlib.util

# Import Array from the root directory
from Array import Array

def import_module_from_directory(base_path, module_name):
    # Construct the full path to the module
    module_path = os.path.join(base_path, module_name)
    # Create a module spec
    spec = importlib.util.spec_from_file_location(module_name, module_path)
    # Create a module from the spec
    module = importlib.util.module_from_spec(spec)
    # Load the module
    spec.loader.exec_module(module)
    return module

# Define a class or a dictionary to hold modules
class TestModules:
    pass

test_modules = TestModules()

def main():
    # Path to the 'test' directory
    test_dir = './test'

    # List directories in the 'test' folder
    for dir_name in os.listdir(test_dir):
        dir_path = os.path.join(test_dir, dir_name)
        if os.path.isdir(dir_path) and not dir_name.startswith('__'):
            algorithm_name = dir_name[2:]  # Adjust slicing if needed based on actual dir names
            result_module_name = f"{algorithm_name}_result.py"
            try:
                # Import the *_result.py module from each subdirectory
                module = import_module_from_directory(dir_path, result_module_name)
                # Save the module to a variable with a sanitized name
                sanitized_name = dir_name.replace(" ", "_").replace("-", "_").lstrip("0123456789")
                setattr(test_modules, sanitized_name, module)
            except FileNotFoundError:
                print(f"No {result_module_name} in {dir_name}")

    # Example usage of Array
    insertionsort()
    optimalBST()
    merge()
    memoizedMatrixChain()
    binarySearchTree()

def insertionsort():
    print("-------------Insertion sort-------------")
    my_array = Array([5, 2, 4, 6, 1, 3])
    # Access and run the INSERTION_SORT function dynamically
    insertion_sort_module = getattr(test_modules, "Insertionsort")
    insertion_sort_module.INSERTION_SORT(my_array)
    print(my_array)

def optimalBST():
    print("-------------Optimal BST-------------")
    p = Array([0.0, 0.15, 0.1, 0.05, 0.1, 0.2])
    q = Array([0.05, 0.1, 0.05, 0.05, 0.05, 0.1])
    n = len(p) - 1
    # Access and run the OptimalBST function dynamically
    optimal_bst_module = getattr(test_modules, "Optimal_BST")
    e, root = optimal_bst_module.OPTIMAL_BST(p, q, n)

    # Print the results
    print("Optimal Expected Search Cost Matrix (e):")
    for row in e:
        print(row)

    print("\nRoot Matrix (root):")
    for row in root:
        print(row)

def merge():
    print("-------------Merge-------------")
    # Example usage:
    # Define the input array and indices
    A = Array([3, 7, 12, 14, 18, 9, 11, 16, 21])
    p = 1
    q = 5
    r = 9

    # Print the sorted array
    # Access and run the Merge function dynamically
    merge_module = getattr(test_modules, "Merge")
    merge_module.MERGE(A, p, q, r)
    print("Sorted array after merging:", A)

def memoizedMatrixChain():
    print("-------------Memoized Matrix Chain-------------")
    p = Array([30, 35, 15, 5, 10, 20, 25])
    # Access and run the MemoizedMatrixChain function dynamically
    memoized_matrix_chain_module = getattr(test_modules, "Memoized_Matrix_Chain")
    matrix = memoized_matrix_chain_module.MEMOIZED_MATRIX_CHAIN(p)

    print(matrix)

def recursiveMatrixChain():
    print("-------------Recursive matrix chain-------------")
    # Access and run the RecursiveMatrixChain function dynamically
    recursive_matrix_chain_module = getattr(test_modules, "RecursiveMatrixChain")
    recursive_matrix_chain_module.RecursiveMatrixChain()

def matrixChainOrder():
    print("-------------Matrix chain order-------------")
    # Access and run the Matrix_Chain_Order function dynamically
    matrix_chain_order_module = getattr(test_modules, "MatrixChainOrder")
    matrix_chain_order_module.Matrix_Chain_Order()

def extendedBottomUpCutRod():
    print("-------------Extended bottom up cut rod-------------")
    # Access and run the ExtendedBottomUpCutRod function dynamically
    extended_bottom_up_cut_rod_module = getattr(test_modules, "ExtendedBottomUpCutRod")
    extended_bottom_up_cut_rod_module.ExtendedBottomUpCutRod()

def bubbleSort():
    print("-------------Bubble sort-------------")
    # Access and run the BubbleSort function dynamically
    bubble_sort_module = getattr(test_modules, "BubbleSort")
    bubble_sort_module.BubbleSort()

def squareMatrixMultiply():
    print("-------------Square Matrix multiply-------------")
    # Access and run the SquareMatrixMultiply function dynamically
    square_matrix_multiply_module = getattr(test_modules, "SquareMatrixMultiply")
    square_matrix_multiply_module.SquareMatrixMultiply()

def squareMatrixMultiplyRecursive():
    print("-------------Square matrix multiply recursive-------------")
    # Access and run the SquareMatrixMultiplyRecursive function dynamically
    square_matrix_multiply_recursive_module = getattr(test_modules, "SquareMatrixMultiplyRecursive")
    square_matrix_multiply_recursive_module.SquareMatrixMultiplyRecursive()

def heapIncreaseKey():
    print("-------------Heap increase key-------------")
    # Access and run the HeapIncreaseKey function dynamically
    heap_increase_key_module = getattr(test_modules, "HeapIncreaseKey")
    heap_increase_key_module.HeapIncreaseKey()       

def findMaxCrossingSubarray():
    print("-------------Find max crossing sub array-------------")
    # Access and run the FindMaxCrossingSubarray function dynamically
    find_max_crossing_subarray_module = getattr(test_modules, "FindMaxCrossingSubarray")
    find_max_crossing_subarray_module.FindMaxCrossingSubarray()

def randomizeInPlace():
    print("-------------Randomize in place-------------")
    # Access and run the RandomizeInPlace function dynamically
    randomize_in_place_module = getattr(test_modules, "RandomizeInPlace")
    randomize_in_place_module.RandomizeInPlace()

def randomSample():
    print("-------------random sample-------------")
    # Access and run the RandomSample function dynamically
    random_sample_module = getattr(test_modules, "RandomSample")
    random_sample_module.RandomSample()

def onLineMaximum():
    print("-------------On line maximum-------------")
    # Access and run the OnLineMaximum function dynamically
    on_line_maximum_module = getattr(test_modules, "OnLineMaximum")
    on_line_maximum_module.OnLineMaximum()

def greedyActivitySelector():
    print("-------------Greddy activity selector-------------")
    # Access and run the GreedyActivitySelector function dynamically
    greedy_activity_selector_module = getattr(test_modules, "GreedyActivitySelector")
    greedy_activity_selector_module.GreedyActivitySelector()

def printPath():
    print("-------------Print path-------------")
    # Access and run the PrintPath function dynamically
    print_path_module = getattr(test_modules, "PrintPath")
    print_path_module.PrintPath()        

def binarySearchTree():
    # Create a TreeNode class
    class TreeNode:
        def __init__(self, key):
            self.key = key
            self.left = None
            self.right = None

    # Create a binary search tree
    root = TreeNode(13)
    node7 = TreeNode(7)
    node15 = TreeNode(15)
    node3 = TreeNode(3)
    node8 = TreeNode(8)
    node14 = TreeNode(14)
    node19 = TreeNode(19)
    node18 = TreeNode(18)

    root.left = node7
    root.right = node15

    node7.left = node3
    node7.right = node8

    node15.left = node14
    node15.right = node19

    node19.left = node18
    print("-------------Binary Search Tree-------------")
    # Access and run the BinarySearchTree function dynamically
    binary_search_tree_module = getattr(test_modules, "BST")
    binary_search_tree_module.TREE_INSERT(root, TreeNode(10))
    print("Found the node with the value: ",binary_search_tree_module.TREE_SEARCH(root, 7).key)
    print("Highest value in the tree: ", binary_search_tree_module.TREE_MAXIMUM(root).key)
    print("Lowest value in the tree: ", binary_search_tree_module.TREE_MINUMUM(root).key)

if __name__ == "__main__":
    main()
