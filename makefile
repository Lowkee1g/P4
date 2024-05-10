# Define the directory containing test files
TEST_DIR := test

# Define the directory containing output files
OUTPUT_DIR := test

# Define the command to run for each test file
TEST_COMMAND := ./main.exe

# Define the python command
PYTHON_COMMAND := python

# Define the python script to run
PYTHON_SCRIPT := run_script.py

# Find all .txt files recursively in the test directory
TEST_FILES := $(wildcard $(TEST_DIR)/*/*.txt)

# Find all .py files recursively in the output directory
OUTPUT_FILES := $(wildcard $(OUTPUT_DIR)/*/*.py)

# Define a target to run the command for each test file
run_tests:
	@echo "Creating python files..."
	@for file in $(TEST_FILES); do \
		$(TEST_COMMAND) $$file; \
		if [ $$? -ne 0 ]; then \
			echo "Error running test $$file"; \
			exit 1; \
		fi; \
	done
	@echo "Cormen Pseudocode successfully interperet."

run_outputs:
	@echo "Running python files..."
	@success_count=0; \
	failure_count=0; \
	for file in $(OUTPUT_FILES); do \
		$(PYTHON_COMMAND) $(PYTHON_SCRIPT) $$file; \
		if [ $$? -eq 0 ]; then \
			success_count=$$((success_count+1)); \
		else \
			failure_count=$$((failure_count+1)); \
		fi; \
	done; \
	echo "Successes: $$success_count"; \
	echo "Failures: $$failure_count"

all: run_tests run_outputs