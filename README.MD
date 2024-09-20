# 🐚 SheLLM (WIP)

Pronounced "shell-ell-em".

## Features

- Shell-based framework for OS LLM Workflows
- Simple, modular, customizable
- Leverages command-line all-stars like `fzf`, `bat`, `tmux`, etc.
- Sexy TUI for LLM chat (powered by [`llm`](https://github.com/simonw/llm), `bat`, & `fzf`)
  - Syntax highlighting
  - Line numbers
  - Scrolling
  - Search (Coming Soon)

## Structure

```
shellm/
├── bin/
│   └── shellm           # Top level executable
├── config/
│   └── .env.example # Example environment file
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

1. Run `shellm`:

   ```bash
   shellm
   ```
