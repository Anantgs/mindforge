### What is a Shell Script?

A **shell script is a series of commands written in a file** that the shell reads and executes, just as if you typed them directly into a terminal. In essence, the shell acts as a small programming environment. Many important parts of a Unix system, including Linux, are actually shell scripts. If you've worked with MS-DOS, you can think of them as very powerful `.BAT` files.

**Key Basics**:
*   **Shebang**: Shell scripts generally begin with `#!/bin/sh`. This line is called a "shebang" and it indicates that the `/bin/sh` program should execute the commands in the script file. It's crucial that **no whitespace appears at the beginning of the script file** before the shebang. You might also see `#!/usr/bin/python` for Python scripts or similar for other scripting languages.
*   **Comments**: A `#` character at the beginning of a line indicates that the line is a comment. The shell ignores anything on a line after a `#`. Comments are useful for explaining parts of your scripts that are difficult to understand.
*   **Execution**: To run a script, it must have the **executable bit set**. The read bit must also be set for the shell to read the file. The easiest way to set this is with `chmod +rx script`. If you don't want other users to read and execute it, you can use the absolute mode `700`. You can execute a script by placing its file in one of the directories in your **command path** and then running its name. Alternatively, you can run `./script` if it's in your current working directory, or use its full pathname.

### Core Concepts in Shell Scripting

1.  **Quoting and Literals**: One of the most confusing aspects of shell scripting is when and why to use quotation marks and other punctuation.
    *   **Literals**: Often, you want to create a **literal**, which is a string that you want the shell to pass to the command line untouched. This is important for special characters like `$` or `*`.
    *   **Single Quotes (`''`)**: The easiest way to create a literal and make the shell leave a string alone is to enclose the entire string in single quotes. For example, `echo '$100'` will print `$100`. **All characters between single quotes, including spaces, make up a single parameter**. When you need a literal, **always turn to single quotes first** as you're guaranteed no substitutions will occur.
    *   **Double Quotes (`""`)**: Double quotes work like single quotes, except that the shell **expands any variables** that appear within them. For example, `echo "There is no * in my path: $PATH"` will substitute the `PATH` variable but not the `*`.
    *   **Backslash (`\`)**: You can use a backslash before a single quote character to pass a literal single quote. For example, `echo I don\'t like contractions`. Oddly, you can also enclose a single quote inside double quotes.
    *   **Shell Expansions**: Remember that the shell performs variable, glob, and other substitutions *before* running the command. The results of these substitutions are then passed to the command. This is why `grep r.*t /etc/passwd` can sometimes mysteriously fail if your current directory contains files that match `r.*t`, as the shell would expand it before `grep` sees it.

### Controlling Script Flow

1.  **Exit Codes**: When a Unix program finishes, it leaves an **exit code** for the parent process that started it.
    *   A **zero (0) exit code typically means the program ran without a problem**.
    *   A **non-zero exit code usually indicates an error**, though some programs (like `diff` and `grep`) use non-zero codes for normal conditions (e.g., `grep` returns 1 if no match is found, 0 if it finds a match). Always check the manual page for a program's exit codes if you're unsure.
    *   When a script aborts abnormally, use `exit 1` (or another non-zero number) to pass an exit code back to its parent process.

2.  **Conditionals**: The Bourne shell has special constructs for conditional execution.
    *   **`if/then/else`**: These keywords allow commands to be executed based on a condition. The shell runs the command after `if`, and if its **exit code is 0 (success)**, it executes commands after `then`. If the exit code is not 0 and an `else` clause exists, those commands are run. The conditional ends with `fi`.
    *   **`[ ]` (the `test` command)**: The `[` character is an **actual program** (also known as `test`) on Unix systems that performs tests for shell script conditionals. It uses **exit codes** (0 for true, non-zero for false) to signal the result of the test. For example, `[ -f file ]` checks if `file` is a regular file. Common tests include **file tests** (`-f` for regular file, `-d` for directory, `-e` for existence, `-s` for non-empty file, `-r` for readable, `-w` for writable, `-x` for executable, `-u` for setuid, `-g` for setgid, `-k` for sticky), **string tests** (`=` for equality, `!=` for inequality, `-z` for empty string, `-n` for non-empty string), and **arithmetic tests** (`-eq` for equal, `-ne` for not equal, `-lt` for less than, `-gt` for greater than, `-le` for less than or equal, `-ge` for greater than or equal). Remember that `=` is for string equality, while `-eq` is for numeric equality.
    *   **`elif`**: This keyword allows you to string multiple `if` conditionals together.
    *   **`&&` (AND) and `||` (OR) Logical Constructs**: These provide quick one-line conditionals. `command1 && command2` runs `command2` only if `command1` succeeds (exit code 0). `command1 || command2` runs `command2` only if `command1` fails (non-zero exit code).
    *   **`case`**: This construct is exceptionally useful for **matching strings and patterns**. It matches a variable's value against various patterns and executes commands until it encounters `;;`, then skips to `esac`. It supports single strings, multiple strings separated by `|`, and wildcards like `*` or `?`. A single `*` can be used as a default case.

3.  **Loops**: Shell scripts support `for` and `while` loops.
    *   **`for` loops**: These are "for each" loops that iterate over a list of values. For example, `for str in one two three; do echo $str; done`.
    *   **`while` loops**: These loops continue as long as a command's **exit code is zero**. They break when a non-zero exit code is encountered. The `break` statement can also exit a `while` loop. An `until` loop is similar but breaks on a zero exit code. The sources suggest that if you find yourself using `while` loops very often, you might consider using a language like `awk` or Python instead.

### Advanced Features and Utilities

1.  **Command Substitution**: The shell can redirect a command's standard output back to the shell's own command line. This means you can use a command's output as an argument to another command or store it in a shell variable by enclosing the command in **`$()`**. The traditional syntax uses backticks (`` ` ``) but `$( )` is a newer, POSIX standard form and generally easier to read.
2.  **Temporary File Management**: When creating temporary files, ensure filenames are distinct to avoid conflicts.
    *   **`mktemp`**: This command creates unique temporary filenames. You provide a template (e.g., `/tmp/im1.XXXXXX`), and `mktemp` replaces `XXXXXX` with unique characters.
    *   **`trap`**: If a script is aborted (e.g., with Ctrl-C), temporary files can be left behind. The `trap` command can create a **signal handler** to catch signals (like `INT` for Ctrl-C) and perform cleanup, such as removing temporary files. You must use `exit` in the handler to explicitly end script execution.
3.  **Here Documents (`<<EOF`)**: This feature allows you to print a large section of text or feed a lot of text to another command without using multiple `echo` commands. The text block starts after `<<MARKER` and ends when `MARKER` appears on a line by itself. Shell variables inside here documents are expanded.
4.  **Important Shell Script Utilities**:
    *   **`basename`**: Strips the extension from a filename or removes directories from a full pathname. Useful for filename manipulation within scripts.
    *   **`awk`**: A powerful programming language often used to **pick specific fields out of an input stream**. For example, `ls -l | awk '{print $5}'` prints the fifth field (file size) of `ls` output.
    *   **`sed`**: A "stream editor" that takes an input stream, alters it according to an expression, and prints the results to standard output. It's commonly used for **substituting text based on regular expressions** (`s/exp/text/`) or **deleting lines** (`3,6d`).
    *   **`xargs`**: Useful for running a command on a large number of files from standard input, often piped from `find`. For security and robustness, use `find ... -print0 | xargs -0 command` to handle filenames with spaces or newlines.
    *   **`expr`**: Performs arithmetic operations in shell scripts (e.g., `expr 1 + 2` prints 3). However, it's considered clumsy and slow; for frequent math, use a language like Python instead.
    *   **`exec`**: A built-in shell feature that **replaces the current shell process with the program you name after `exec`**. It carries out the `exec()` system call. When used in a script, the script and the shell running it are replaced by the new command, meaning **there's no return**.
5.  **Subshells**: To alter the environment temporarily without permanent changes, use a **subshell**. Commands put in parentheses `()` are executed by a new shell process, which has a copy of the original shell's environment. When the subshell exits, its environmental changes disappear, leaving the original shell unaffected. For example, `(cd uglydir; uglyprogram)` executes `uglyprogram` in `uglydir` without changing the original shell's directory.
6.  **Including Other Files**: Use the **dot (`.`) operator** to include another file's commands directly into your script. This syntax does not start a subshell, making it useful for sharing configuration files among a group of scripts.
7.  **Reading User Input**: The `read` command reads a line of text from the standard input and stores it in a variable.

### When (Not) to Use Shell Scripts

Shell scripts excel at **simplifying and automating tasks that can be performed at the command line**, especially for manipulating batches of files.

However, there are limitations. For **complex tasks** such as:
*   Picking apart strings
*   Performing repeated arithmetic computations
*   Accessing complex databases
*   Requiring complex functions and control structures beyond what the shell provides

It's generally **better to use a more powerful scripting language** like **Python, Perl, or awk**, or even a compiled language like C. The sources advise keeping shell scripts short to avoid "monstrosities". If you find yourself writing convoluted scripts, especially with complex string or arithmetic operations, consider switching to another language.
