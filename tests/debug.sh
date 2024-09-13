#!/bin/bash

# Check if a script to debug was provided
if [ $# -eq 0 ]; then
	echo "Usage: $0 <script_to_debug> [script_args...]"
	echo "Error: No script to debug specified."
	exit 1
fi

SCRIPT_TO_DEBUG="$1"
shift # Remove the script name from the arguments

# Generate log file names based on timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
SCRIPT_LOG="script_debug_${TIMESTAMP}.log"
STRACE_LOG="strace_debug_${TIMESTAMP}.log"

echo "Starting debug session for: $SCRIPT_TO_DEBUG"
echo "Script output will be logged to: $SCRIPT_LOG"
echo "Strace output will be logged to: $STRACE_LOG"

# Check if we're on macOS
if [[ "$(uname)" == "Darwin" ]]; then
	# macOS doesn't have strace, use dtruss instead
	# Note: dtruss requires sudo
	{
		sudo dtruss $SCRIPT_TO_DEBUG "$@" 2>$STRACE_LOG
	} | script -q $SCRIPT_LOG
else
	# Linux version
	script -q -c "strace -f -o $STRACE_LOG $SCRIPT_TO_DEBUG $*" "$SCRIPT_LOG"
fi

echo "Debugging complete."
echo "To view script output: tail -n 20 $SCRIPT_LOG"
echo "To view strace/dtruss output: tail -n 20 $STRACE_LOG"

# To monitor the output in real-time while the script is running,
# first run the scripts: ./debug.sh <script_to_debug> [script_args...]
#
# Then, run the following commands in separate terminals:
#
# `tail -f script_debug_*.log` - script output
# `tail -f strace_debug_*.log` - strace/dtruss output.
