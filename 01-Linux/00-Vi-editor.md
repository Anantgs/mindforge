# Vi/Vim Editor — Notes, Options, and Commands

## 1. Introduction

**Vim (Vi Improved)** is a free, open-source, and powerful text editor. It is an improved version of the traditional Unix editor called `vi`.

Vim is commonly used by programmers, Linux users, and system administrators to create, edit, and manage text files and source code.

It is available on Linux, macOS, and Windows. If you are new to Vim, a built-in tutorial is available by running `vimtutor` from the terminal.

## 2. Features of Vim Editor

- **Modal Editing:** Provides different modes for editing and navigating text.
- **Lightweight:** Uses relatively few system resources.
- **Keyboard-Based:** Most operations can be performed using keyboard shortcuts.
- **Syntax Highlighting:** Displays code elements in different colors.
- **Search and Replace:** Helps find and replace text quickly.
- **Customization:** Allows users to customize settings using a configuration file.
- **Multiple File Support:** Supports working with multiple files and windows.
- **Cross-Platform:** Available on different operating systems.

## 3. Modes of Vim Editor

Vim has different modes for performing different operations.

### 3.1 Normal Mode

Normal Mode is the default mode used for navigation and editing commands.

Examples:
- `h` — Move left
- `j` — Move down
- `k` — Move up
- `l` — Move right
- `dd` — Delete a line
- `yy` — Copy a line

Press `Esc` to return to Normal Mode.

### 3.2 Insert Mode

Insert Mode is used to type and insert text into a file.

Commands to enter Insert Mode:

- `i` — Insert before the cursor
- `I` — Insert at the beginning of the line
- `a` — Insert after the cursor
- `A` — Insert at the end of the line
- `o` — Create a new line below
- `O` — Create a new line above

Press `Esc` to exit Insert Mode and return to Normal Mode.

### 3.3 Visual Mode

Visual Mode is used to select text.

- `v` — Select characters
- `V` — Select entire lines
- `Ctrl + v` — Select a block of text

After selecting text, use commands such as `y` to copy or `d` to delete.

### 3.4 Command-Line Mode

Command-Line Mode is used to save files, quit Vim, change settings, and perform other operations.

Press `:` in Normal Mode to enter Command-Line Mode.

Examples:
- `:w` — Save the file
- `:q` — Quit Vim
- `:wq` — Save and quit
- `:q!` — Quit without saving changes

## 4. Basic Vim Commands

| Command | Description |
|---|---|
| `i` | Insert text before the cursor |
| `a` | Insert text after the cursor |
| `o` | Open a new line below |
| `Esc` | Return to Normal Mode |
| `x` | Delete a character |
| `dd` | Delete the current line |
| `yy` | Copy the current line |
| `p` | Paste after the cursor or below the line |
| `P` | Paste before the cursor or above the line |
| `u` | Undo the last change |
| `Ctrl + r` | Redo an undone change |
| `r` | Replace one character |
| `.` | Repeat the last change |
| `J` | Join the current line with the next line |

## 5. Cursor Movement Commands

| Command | Description |
|---|---|
| `h` | Move left |
| `j` | Move down |
| `k` | Move up |
| `l` | Move right |
| `w` | Move forward by a word |
| `b` | Move backward by a word |
| `0` | Move to the beginning of the line |
| `^` | Move to the first non-blank character |
| `$` | Move to the end of the line |
| `gg` | Move to the first line of the file |
| `G` | Move to the last line of the file |
| `:10` | Go to line number 10 |
| `Ctrl + f` | Move forward one screen |
| `Ctrl + b` | Move backward one screen |

## 6. Saving and Exiting Commands

These commands are entered after pressing `:` in Normal Mode.

| Command | Description |
|---|---|
| `:w` | Save the file |
| `:q` | Quit Vim if there are no unsaved changes |
| `:wq` | Save and quit |
| `:x` | Save and quit if changes were made |
| `:q!` | Quit without saving changes |
| `:w filename.txt` | Save the file with a specified name |
| `:e filename.txt` | Open another file |

**Note:** The command `:q!` discards unsaved changes. Use it carefully.

## 7. Search and Replace Commands

| Command | Description |
|---|---|
| `/word` | Search forward for a word |
| `?word` | Search backward for a word |
| `n` | Move to the next search result |
| `N` | Move to the previous search result |
| `:%s/old/new/g` | Replace all occurrences throughout the file |
| `:%s/old/new/gc` | Replace occurrences after confirmation |
| `:s/old/new/g` | Replace all occurrences on the current line |

### Example

To replace every occurrence of `hello` with `welcome`, use:

```vim
:%s/hello/welcome/g
```

Explanation:

- `%` — Apply the command to all lines.
- `s` — Substitute text.
- `hello` — Original text.
- `welcome` — Replacement text.
- `g` — Replace all matches on each line.

## 8. Vim Options

Vim options are settings that control the editor's behavior and appearance. They can be changed using the `:set` command.

| Option | Description |
|---|---|
| `:set number` | Display line numbers |
| `:set nonumber` | Hide line numbers |
| `:set relativenumber` | Display relative line numbers |
| `:set ruler` | Display the cursor position |
| `:set showmatch` | Highlight matching brackets |
| `:set ignorecase` | Ignore case when searching |
| `:set smartcase` | Make searches case-sensitive when uppercase letters are included |
| `:set hlsearch` | Highlight search results |
| `:set nohlsearch` | Disable search-result highlighting |
| `:set wrap` | Wrap long lines visually |
| `:set nowrap` | Display long lines without visual wrapping |
| `:set tabstop=4` | Set tab display width to four columns |
| `:set shiftwidth=4` | Set indentation width to four columns |
| `:set expandtab` | Use spaces instead of tab characters when indenting |
| `:set autoindent` | Automatically indent new lines based on the previous line |
| `:set mouse=a` | Enable mouse support if available |
| `:set option?` | Display the current value of an option |

### Example: Enable Line Numbers

```vim
:set number
```

This command displays line numbers on the left side of the editor.

### Example: Configure Indentation

```vim
:set tabstop=4
:set shiftwidth=4
:set expandtab
:set autoindent
```

These settings configure four-column indentation and use spaces instead of tab characters for indentation operations.

## 9. Working with Multiple Files and Windows

| Command | Description |
|---|---|
| `:e file.txt` | Open a file |
| `:ls` | List available buffers |
| `:bn` | Switch to the next buffer |
| `:bp` | Switch to the previous buffer |
| `:sp file.txt` | Split the window horizontally |
| `:vsp file.txt` | Split the window vertically |
| `Ctrl + w`, then `w` | Switch between windows |
| `:only` | Keep only the current window |
| `:bd` | Remove the current buffer from the buffer list |

**Buffer:** A buffer is Vim's in-memory representation of a file.

**Window:** A window is a view used to display a buffer.

## 10. How to Create and Edit a File

Follow these steps to create and edit a file using Vim.

### Step 1: Open the Terminal

Open the terminal on your computer.

### Step 2: Open Vim

Enter the following command:

```bash
vim example.txt
```

This opens `example.txt` or creates it when you save it if it does not already exist.

### Step 3: Enter Insert Mode

Press:

```text
i
```

### Step 4: Type Text

Enter the following text:

```text
Welcome to Vim Editor.
Vim is a powerful text editor.
```

### Step 5: Save the File

Press `Esc`, then type:

```vim
:w
```

Press `Enter` to save.

### Step 6: Exit Vim

Type:

```vim
:q
```

Press `Enter` to exit if there are no unsaved changes.

You can also save and exit in one step using `:wq`.

## 11. Advantages of Vim

- Free and open-source.
- Fast and efficient for text editing.
- Requires relatively few system resources.
- Useful for editing files on remote servers.
- Provides powerful search and replace features.
- Supports many programming languages.
- Highly customizable.
- Useful for Linux system administration.

## 12. Disadvantages of Vim

- Difficult for beginners to learn initially.
- Requires practice to remember commands.
- Modal editing can be confusing at first.
- Advanced features may require configuration.
- The terminal-based interface may be less intuitive for users accustomed to graphical editors.

## 13. Applications of Vim

Vim is commonly used for:

- Writing and editing source code.
- Creating shell scripts.
- Editing Linux configuration files.
- Managing files on remote servers.
- Writing text documents.
- Performing quick edits in terminal environments.

## 14. Conclusion

Vim is a powerful, lightweight, and customizable text editor. Its different modes, keyboard commands, search and replace features, and configurable options make it useful for programmers and system administrators.

Although Vim requires practice to learn, understanding its basic modes and commands makes text editing faster and more efficient.

## 15. Quick Reference

| Task | Command |
|---|---|
| Start typing | `i` |
| Return to Normal Mode | `Esc` |
| Save | `:w` |
| Quit | `:q` |
| Save and quit | `:wq` |
| Quit without saving | `:q!` |
| Delete a line | `dd` |
| Copy a line | `yy` |
| Paste | `p` |
| Undo | `u` |
| Redo | `Ctrl + r` |
| Show line numbers | `:set number` |
| Search for a word | `/word` |
| Replace all matches | `:%s/old/new/g` |
| Go to the last line | `G` |
| Go to the first line | `gg` |
