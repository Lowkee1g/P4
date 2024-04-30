# Define the directory containing test files
TEST_DIR := test

# Define the command to run for each test file
COMMAND := ./main.exe

# Find all .txt files recursively in the test directory
TEST_FILES := $(wildcard $(TEST_DIR)/*/*.txt)

# Define a target to run the command for each test file
run_tests:
	@for file in $(TEST_FILES); do \
        $(COMMAND) $$file; \
    done
