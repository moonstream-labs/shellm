#!/bin/zsh
# utils.sh
# Current Working Version

error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Log verbose messages
log_verbose() {
    if $verbose; then
        echo "[INFO] $1" >&2
    fi
}

# Display usage information
usage() {
    cat <<EOF
Usage: xtag [options] [file ...]

Description: Generates XML tags and copies the content to the clipboard.

Options:
  -i            <instructions> tags
  -x            <context> tags
  -f            <filetree> tags
  -b            <codebase> tags
  -d [n]        <document> tags within <documents>, n is # of documents (default: 1)
  -e [n]        <example> tags within <examples>, n is # of examples (default: 1)
  -c [n]        <file> tags within <code>, n is # of code files (default: 1)
  -r [n]        <step> tags within <reasoning>, n is # of steps (default: 1)
  -s [path]     save output to file path (default: clipboard)
  -m [dir]      save output as multiple files in directory (default: current directory)
  -v            Verbose mode (provide detailed output)
  -h, --help    Display help message and exit

Examples:
  xtag -i                            # Generate <instructions> template
  xtag -d 2 file1.txt file2.txt      # Process 2 files as <document> tags
  xtag -e "Meta description" f1.txt  # Process file as <example> with meta
  xtag -c 3 a.py b.py c.py -s out.xml # Process 3 files as <code> and save to file

EOF
    exit 0
}

# Function to print the tag structure (for debugging)
print_tag_structure() {
    for key in ${(k)TAG_STRUCTURE}; do
        echo "$key: ${TAG_STRUCTURE[$key]}"
    done
}