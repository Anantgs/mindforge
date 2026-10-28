2.  **Special Variables**: Shell scripts use special Bourne shell variables, which are like other shell variables but some cannot be changed.
    *   **`$1`, `$2`, ...**: These variables contain the values of the script's command-line parameters (arguments).
    *   **`$#`**: This variable holds the **number of arguments** passed to a script. It's especially important for picking through arguments in loops.
    *   **`$@`**: Represents **all of a script's arguments**. It's very useful for passing them to another command inside the script, ensuring proper quoting.
    *   **`$0`**: Holds the **name of the script** itself. Useful for generating diagnostic messages, such as error messages that include the script's name.
    *   **`$$`**: Holds the **process ID (PID)** of the shell running the script.
    *   **`$?`**: Holds the **exit code of the last command** that the shell executed. This is critical for controlling script flow and error handling.

### Examples

1. $1, $2, … (Positional parameters)

```
#!/bin/sh
echo "First argument: $1"
echo "Second argument: $2"
echo "Third argument: $3"
```
#### Run

```
./myscript.sh apple banana cherry

```

#### Output

```
First argument: apple
Second argument: banana
Third argument: cherry

```

2. $# (Number of arguments)

```
#!/bin/sh
echo "You passed $# arguments."

```

#### Run:

```
./myscript.sh one two three

```

#### Output:

```
You passed 3 arguments.

```

3. $@ (All arguments — individually quoted)

```
#!/bin/sh
echo "All arguments individually:"
for arg in "$@"; do
    echo "$arg"
done

```

#### Run:

```
./myscript.sh one two three

```

#### Output:

```
All arguments individually:
one
two
three

```

4. $0 (Script name)

```
#!/bin/sh
echo "This script is called: $0"
```

#### Run:

```
./myscript.sh

```

#### Output:

```
This script is called: ./myscript.sh

```

5. $$ (Process ID)

```
#!/bin/sh
echo "My process ID is: $$"

```

#### Run:

```
./myscript.sh

```

#### Output:

```
This script's PID is: 12345

```

6. $? (Exit status of last command)

```
#!/bin/sh
ls /etc/passwd
echo "Exit status of last command: $?"

ls /not/a/real/file
echo "Exit status of last command: $?"

```

#### Run:

```
./myscript.sh

```

#### Output:

```
/etc/passwd
Exit status of last command: 0
ls: cannot access '/not/a/real/file': No such file or directory
Exit status of last command: 2

```