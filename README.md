# Cormen Pseudocode to Python Compiler

This project is an OCaml-based compiler that translates algorithm pseudocode (in the style of the famous "Introduction to Algorithms" textbook by Cormen et al.) into executable Python code.

## Project Overview

The compiler parses pseudocode from `.txt` files and generates corresponding Python implementations in `_result.py` files. It includes implementations of classic algorithms like:

- Insertion Sort
- Merge Sort
- Bubble Sort
- Dynamic Programming algorithms (Matrix Chain, Cut Rod, Optimal BST)
- Heap operations
- Greedy algorithms
- And many more!

## Prerequisites

- Docker (for containerized development)
- OR OCaml (5.x), dune (3.x), and menhir (if running locally)

## Getting Started with Docker/Dev Container

### Option 1: Using VS Code Dev Containers (Recommended)

1. **Install Prerequisites:**
   - [VS Code](https://code.visualstudio.com/)
   - [Docker Desktop](https://www.docker.com/products/docker-desktop)
   - [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for VS Code

2. **Open in Dev Container:**
   ```bash
   # Clone the repository
   git clone https://github.com/Lowkee1g/P4.git
   cd P4
   
   # Open in VS Code
   code .
   ```

3. **Reopen in Container:**
   - Press `F1` or `Ctrl+Shift+P` (Windows/Linux) / `Cmd+Shift+P` (Mac)
   - Type "Dev Containers: Reopen in Container"
   - Wait for the container to build (first time may take a few minutes)

4. **Build and Run:**
   ```bash
   # The container should have everything ready
   # Build the project
   make build
   
   # Run tests (compile all pseudocode files)
   make run_tests
   ```

### Option 2: Building Docker Image Manually

1. **Build the Docker image:**
   ```bash
   docker build -t cormen-compiler .
   ```

2. **Run the container:**
   ```bash
   docker run -it -v $(pwd):/workspaces/P4 cormen-compiler
   ```

3. **Inside the container:**
   ```bash
   # Build the project
   make build
   
   # Run tests
   make run_tests
   ```


## Makefile Targets

- `make build` - Compile the OCaml compiler
- `make run_tests` - Process all pseudocode files silently
- `make run_debug` - Process all files with verbose output
- `make test` - Build and run tests (requires Python3 for validation)
- `make python` - Run Python validation scripts (requires Python3)

## Project Structure

```
.
├── dockerfile           # Docker configuration
├── README.md           # This file
├── makefile            # Build automation
├── dune-project        # Dune project configuration
├── lexer.mll           # Lexical analyzer
├── parser.mly          # Parser grammar (menhir)
├── ast.ml              # Abstract Syntax Tree definitions
├── interp.ml           # Interpreter/code generator
├── main.ml             # Main entry point
├── Array.py            # Python Array helper class
└── test/               # Test pseudocode files
    ├── 01InsertionSort/
    │   ├── InsertionSort.txt           # Input pseudocode
    │   └── InsertionSort_result.py     # Generated Python
    ├── 02Optimal-BST/
    ├── 03Merge/
    └── ...
```

## How It Works

1. **Lexer** (`lexer.mll`) - Tokenizes the input pseudocode
2. **Parser** (`parser.mly`) - Builds an Abstract Syntax Tree (AST)
3. **Interpreter** (`interp.ml`) - Traverses the AST and generates Python code
4. **Output** - Writes the Python code to `*_result.py` files

## Example

**Input** (`InsertionSort.txt`):
```
INSERTION-SORT(A)
for j = 2 to A.length
    key = A[j]
    i = j - 1
    while i > 0 and A[i] > key
        A[i + 1] = A[i]
        i = i - 1
    A[i + 1] = key
```

**Output** (`InsertionSort_result.py`):
```python
def INSERTION_SORT(A):
    for j in range(2, len(A) + 1):
        key = A[j]
        i = j - 1
        while i > 0 and A[i] > key:
            A[i + 1] = A[i]
            i = i - 1
        A[i + 1] = key
```

## Troubleshooting

### Line Ending Issues
If you see errors like "illegal character with ASCII code: 13", the text files have Windows line endings. Fix with:
```bash
find . -name "*.txt" -type f -exec sed -i 's/\r$//' {} \;
```

### Parser Warnings
The warnings about shift/reduce conflicts are expected and can be safely ignored. They come from the menhir parser generator.

### Missing Dependencies
If you get "Program X not found" errors:
```bash
opam install dune menhir
eval $(opam env)
```

## Contributing

Feel free to add more algorithm implementations by creating new `.txt` files in the `test/` directory following the Cormen pseudocode style.

## License

This is an educational project for learning compiler construction and algorithm implementation.
