# xtag

This guide provides a detailed overview of the `xtag` script, its components, and how they work together to generate XML tags and process files.

## Introduction

The `xtag` script is a versatile tool designed to generate various types of XML tag structures for documentation, code representation, reasoning, and more. It can process files, generate empty templates, and output the results to the clipboard or files. The script's modular design allows for easy maintenance and extension.

## File Structure

The `xtag` script is composed of four main files:

- `xtag`: The main executable script
- `core.sh`: Contains core functions for tag structure and manipulation
- `utils.sh`: Contains utility functions and usage information
- `output.sh`: Handles output operations

---

## `xtag` (Main Script)

The `xtag` script is the entry point of the program. It sources the other script files and contains the main logic for parsing command-line options and executing the appropriate functions.

### Key Components

- **Option Parsing**: Uses `getopts` to parse command-line options, setting variables for tag type, number of items, save paths, and verbosity.
- **Main Logic**:
  - Checks for `--help` option before parsing other options
  - Generates the tag structure using `make_xtags`
  - Processes files if provided using `fill_tags`
  - Generates output using `make_xtags` again
  - Handles output using `handle_output`

### Execution Flow

1. Checks for `--help` option
2. Sources other script files
3. Parses command-line options
4. Checks if a tag type was specified
5. Generates initial tag structure
6. Processes files if provided
7. Generates final output
8. Handles output (clipboard, single file, or multiple files)

---

## `core.sh`

This file contains the core functions for creating and manipulating tag structures.

### Key Functions

#### `init_tag_structure`

- Initializes a global associative array `TAG_STRUCTURE`
- Sets up the structure based on the tag type and number of items
- Handles different tag types: instructions, context, repomap, codebase, version, document, example, code, and reasoning

#### `make_xtags`

- Generates XML tags based on the tag structure
- Uses a case statement to handle different tag types
- Builds the XML structure with placeholders for content
- Includes special handling for the `version` tag type

#### `fill_tags`

- Populates the tag structure with actual content from files
- Handles different tag types and their specific requirements
- Reads file contents and updates the `TAG_STRUCTURE` accordingly
- Includes handling for the `version` tag type

### Execution Flow

1. `init_tag_structure` is called to set up the basic structure
2. `make_xtags` generates the initial XML structure with placeholders
3. If files are provided, `fill_tags` populates the structure with actual content
4. `make_xtags` is called again to generate the final XML output

---

## `utils.sh`

This file contains utility functions and the usage information for the script.

### Key Functions

#### `error_exit`

- Displays an error message and exits the script

#### `log_verbose`

- Logs messages when verbose mode is enabled

#### `usage`

- Displays the help message with usage information and examples
- Includes information about both `-h` and `--help` options

#### `print_tag_structure`

- A debug function to print the contents of the `TAG_STRUCTURE` array

### Usage

These utility functions are used throughout the other scripts for error handling, logging, and providing user information. The `usage` function can be triggered by either the `-h` or `--help` options, with `--help` taking precedence.

---

## `output.sh`

This file handles the output operations of the script.

### Key Functions

#### `handle_output`

- Determines how to handle the output based on provided options
- Can save to a single file, multiple files, or copy to clipboard

#### `save_single_file`

- Saves the output content to a single file

#### `save_multiple_files`

- Saves the output as multiple files in a directory
- Creates a new directory if needed
- Uses `awk` to split the content into separate files based on tag structure

### Execution Flow

1. `handle_output` is called with the final content and output options
2. Based on the options, it either:
   - Copies the content to the clipboard
   - Calls `save_single_file` to save to a single file
   - Calls `save_multiple_files` to save as multiple files

---

## Overall Functionality

The `xtag` script provides a flexible system for generating XML tag structures and processing files into these structures. It can handle various tag types, including instructions, context, repomap, codebase, version, documents, examples, code, and reasoning steps.

The script allows users to:

- Generate empty tag templates
- Process one or more files into a tag structure
- Save output to the clipboard, a single file, or multiple files
- Display usage information with `-h` or `--help` options

The modular design separates concerns into different files, making the code more maintainable and extensible. The core functionality of creating and manipulating tag structures is separated from the input/output operations and utility functions, allowing for easier updates and potential additions of new tag types or processing methods in the future.

### Error Handling and Verbose Logging

The script includes robust error handling through the `error_exit` function, which displays error messages and terminates the script when necessary. The `log_verbose` function allows for detailed logging when verbose mode is enabled, helping with debugging and providing more information about the script's execution.

### Extending the Script

To add a new tag type to the `xtag` script:

1. Update the `init_tag_structure` function in `core.sh` to handle the new tag type.
2. Add appropriate cases in the `make_xtags` and `fill_tags` functions to generate and populate the new tag structure.
3. Update the option parsing in the main `xtag` script to recognize the new tag type.
4. Update the `usage` function in `utils.sh` to include information about the new tag type and its usage.

This modular approach allows for easy extension of the script's capabilities while maintaining its overall structure and functionality.
