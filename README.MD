# 🐚 SheLLM (WIP)

Pronounced "shell-ell-em".

## Features

- Command-line utilities for LLM workflows
- Simple, modular, fast
- Leverages command-line all-stars like `fzf`, `bat`, etc.
- Lo-Fi LLM chat (powered by `jq`, `bat`, & `fzf`)
  - Anthropic API support
  - Syntax highlighting
  - Line numbers
  - Chat Scrolling
  - Chat Search via `rg` (Coming Soon)
  - Local DB Sync for Chat Output (Coming Soon)
- XML Tag Machine
  - `xcp` - v1 XML Tagging Utility
- Embedding Workflows (Coming Soon)
- LLM-Powered Commit Messages (Coming Soon)

## Structure

```
shellm/
│
├── bin/
│   └── shellm           # Top level executable
│
├── blocks/
│   └── xcp              # XML Tagging Utility
│
├── config/
│   └── .env.example     # Example environment file
│
├── flows/
│   └── chat             # LLM Chat TUI
│
├── .gitignore
└── README.md
```

## Prerequisites

- Bash/Zsh Command Line Environment
- `fzf` for fuzzy finding
- `bat` for output formatting
- `jq` for LLM stream parsing

## Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/moonstream-labs/shellm.git ~/projects/shellm
   ```

2. Create a symlink to make `shellm` accessible from anywhere:

   ```bash
   ln -s ~/projects/shellm/bin/shellm ~/.local/bin/shellm
   ```

3. Ensure `~/.local/bin` is in your PATH. Add the following line to your `~/.bashrc` or `~/.zshrc`:

   ```bash
   export PATH="$HOME/.local/bin:$PATH"
   ```

4. Restart your terminal.

   ```bash
   exec $SHELL
   ```

## Configuration

1. Copy the example environment file:

   ```bash
   cp ~/shellm/config/.env.example ~/projects/shellm/config/.env 
   ```

2. Edit `~/projects/shellm/config/.env` and set your configuration variables:

   ```bash
   ANTHROPIC_API_KEY=your_api_key_here
   # Add any other configuration variables
   ```

## Usage

1. Run `shellm`:

   ```bash
   shellm
   ```
