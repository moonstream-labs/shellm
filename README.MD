# 🐚 SheLLM (WIP)

## Table of Contents

Pronounced "shell-ell-em".

## Features

- Shell-based framework for OS LLM Workflows
- Simple, modular, customizable
- Leverages `fzf`, `bat`, `tmux`, etc.
- Sexy `bat`-powered TUI for LLM chat

## Structure

```
shellm/
├── bin/
│   └── shellm           # Top level executable
├── config/
│   └── shellm.env.example # Example environment file
├── workflows/
│   └── chat            # LLM Chat TUI
├── .gitignore
└── README.md
```

## Prerequisites

- Bash/Zsh Command Line Environment
- `fzf` for fuzzy finding
- `bat` for output formatting
- `llm` CLI

## Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/yourusername/aios.git ~/projects/aios
   ```

2. Create a symlink to make AIOS accessible from anywhere:

   ```bash
   ln -s ~/projects/aios/bin/aios ~/.local/bin/aios
   ```

3. Ensure `~/.local/bin` is in your PATH. Add the following line to your `~/.bashrc` or `~/.zshrc`:

   ```bash
   export PATH="$HOME/.local/bin:$PATH"
   ```

4. Source your updated rc file or restart your terminal.

## Configuration

1. Copy the example environment file:

   ```bash
   cp ~/projects/aios/config/aios.env.example ~/projects/aios/config/aios.env
   ```

2. Edit `~/projects/aios/config/aios.env` and set your configuration variables:

   ```bash
   OPENAI_API_KEY=your_api_key_here
   # Add any other configuration variables
   ```

## Usage

1. Run AIOS:

   ```bash
   aios
   ```

2. Use the fuzzy finder to select a workflow.

3. Follow the prompts for the selected workflow.

### Chat Workflow

The default chat workflow provides an interactive interface to communicate with an LLM:

- Enter your messages at the prompt.
- The LLM's responses will be displayed with formatting.
- Type `q` to exit the chat workflow.

## Creating New Workflows

1. Create a new script in the `workflows/` directory:

   ```bash
   touch ~/projects/aios/workflows/my_new_workflow
   chmod +x ~/projects/aios/workflows/my_new_workflow
   ```

2. Edit the new workflow script, starting with:

   ```bash
   #!/bin/bash
   # ~/projects/aios/workflows/my_new_workflow

   # Function to output system messages
   system_msg() {
       echo "$@" >&3
   }

   # Function to output debug messages
   debug_msg() {
       echo "$@" >&4
   }

   # Your workflow logic here
   main() {
       system_msg "Starting My New Workflow"
       # ...
   }

   # Set up file descriptors
   exec 3>&1
   exec 4>/dev/null

   # Run the main function
   main "$@"

   # Clean up file descriptors
   exec 3>&-
   exec 4>&-
   ```

3. Implement your workflow logic in the `main` function.

4. The new workflow will now be available when running `aios`.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
