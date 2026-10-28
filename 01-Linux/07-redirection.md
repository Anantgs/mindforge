# Linux I/O Redirection — Student Practice

## Learning Objectives

By the end of this exercise, students will be able to:

- Redirect standard output to a file.
- Append output to an existing file.
- Read input from a file.
- Redirect error messages to a file.
- Redirect both standard output and standard error.

## 1. Output Redirection (`>`)

The `>` operator redirects command output to a file. It creates the file if it does not exist and overwrites the file if it already exists.

**Command:**

```bash
echo "Hello Students" > demo.txt
cat demo.txt
```

**Output:**

```text
Hello Students
```

Try overwriting the file:

```bash
echo "This is a new line" > demo.txt
cat demo.txt
```

The previous content is replaced.

## 2. Append Redirection (`>>`)

The `>>` operator adds output to the end of a file without overwriting its existing content.

**Command:**

```bash
echo "Hello Students" > demo.txt
echo "Welcome to Linux" >> demo.txt
cat demo.txt
```

**Output:**

```text
Hello Students
Welcome to Linux
```

## 3. Input Redirection (`<`)

The `<` operator takes input from a file instead of the keyboard.

**Command:**

```bash
cat < demo.txt
```

This displays the contents of `demo.txt`.

Another example:

```bash
wc -l < demo.txt
```

This displays the number of lines in the file.

## 4. Error Redirection (`2>`)

File descriptor `2` represents standard error (stderr). The `2>` operator redirects error messages to a file.

**Command:**

```bash
ls /wrongpath 2> error.txt
cat error.txt
```

The error message is stored in `error.txt` instead of appearing on the terminal.

## 5. Redirect Standard Output and Standard Error

In Bash, `&>` redirects both standard output and standard error to the same file.

**Command:**

```bash
ls /etc /wrongpath &> output.txt
cat output.txt
```

This saves the directory listing from `/etc` and the error caused by `/wrongpath` in `output.txt`.

**Portable alternative:**

```bash
ls /etc /wrongpath > output.txt 2>&1
```

Here:

- `> output.txt` redirects standard output to the file.
- `2>&1` redirects standard error to the same destination as standard output.

**Important:** The order matters. Use `> output.txt 2>&1` to send both streams to the file.

## 6. Redirect Only Standard Output

```bash
ls /etc > listing.txt
```

This saves the directory listing in `listing.txt`.

Display the saved output:

```bash
cat listing.txt
```

## 7. Discard Output Using `/dev/null`

Linux provides `/dev/null`, a special device that discards anything written to it.

Discard standard output:

```bash
ls /etc > /dev/null
```

Discard error messages:

```bash
ls /wrongpath 2> /dev/null
```

Discard both standard output and standard error:

```bash
ls /etc /wrongpath > /dev/null 2>&1
```

## 8. Quick Reference

| Operator | Purpose |
|---|---|
| `>` | Redirect standard output; overwrite a file |
| `>>` | Redirect standard output; append to a file |
| `<` | Read standard input from a file |
| `2>` | Redirect standard error |
| `&>` | Redirect standard output and standard error in Bash |
| `2>&1` | Redirect standard error to the current standard-output destination |
| `/dev/null` | Discard output |

## 9. Student Practice Exercises

1. Write `Linux is fun` into `class.txt` using `>`.
2. Append `Redirection is useful` to `class.txt` using `>>`.
3. Display the contents of `class.txt` using input redirection.
4. Run a command with an invalid path and save its error in `myerror.txt`.
5. List `/etc` and an invalid directory, saving both output and errors in `combined.txt`.
6. Count the lines in `class.txt` using input redirection.
7. Redirect the output of `date` into `today.txt`.
8. Run `ls /wrongpath 2> /dev/null` and observe what appears on the terminal.

## 10. Solutions to Practice Exercises

```bash
# Exercise 1
echo "Linux is fun" > class.txt

# Exercise 2
echo "Redirection is useful" >> class.txt

# Exercise 3
cat < class.txt

# Exercise 4
ls /wrongpath 2> myerror.txt

# Exercise 5
ls /etc /invalid-path > combined.txt 2>&1

# Exercise 6
wc -l < class.txt

# Exercise 7
date > today.txt

# Exercise 8
ls /wrongpath 2> /dev/null
```

## Safety Note

Always practice with files in your working directory. Do not experiment with output redirection (`>`) on system files such as `/var/log/wtmp`, because it can truncate or damage their contents.

## Cleanup

Remove only the practice files created during this exercise:

```bash
rm -i demo.txt error.txt output.txt listing.txt class.txt myerror.txt combined.txt today.txt
```

The `-i` option asks for confirmation before removing each file.
