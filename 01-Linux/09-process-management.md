# Linux Processes — Concepts and Internals

## 1. Why Do We Need Processes?
- A process is a program in execution.
- The operating system uses processes to run multiple programs.
- Each process has its own execution state, resources, and process ID (PID).
- The Linux kernel schedules processes to share CPU time.
- Examples: Running a browser, executing a shell command, or starting a web server.

**Understand:** Why can't the operating system simply execute every program directly without managing it as a process?

## 2. What Happens When a Process Runs in the Background?
- The shell creates a process to execute a command.
- Adding `&` runs the command as a background job.
- The shell can accept new commands while the background job continues.
- The Linux scheduler decides when the process gets CPU time.
- The process may run, wait for I/O, sleep, or terminate.

**Example:**
```bash
sleep 100 &
ps -ef
```

**Understand:** How does the process continue running while the terminal accepts new commands?

## 3. What Are the Different Process States and Types?
- **Running / Runnable:** Executing on a CPU or ready to execute.
- **Interruptible sleep:** Waiting for an event and can generally be interrupted by signals.
- **Uninterruptible sleep:** Waiting inside the kernel, often for I/O to complete.
- **Stopped:** Execution has been paused.
- **Zombie:** The process has terminated, but its exit status has not yet been collected.
- **Orphan:** A living process whose parent has terminated.
- **User process:** Runs application code in user space.
- **Kernel thread:** Performs work inside the kernel.

**Understand:** Why does a process change states instead of continuously running?

## 4. What Is a Zombie Process, and Why Is It Created?
- A zombie is a process that has finished execution but still has an entry in the process table.
- When a child exits, the kernel preserves its termination status and basic information.
- The parent process must collect that status using `wait()` or `waitpid()`.
- Until the status is collected, the child can remain a zombie.
- Zombies use a small amount of kernel process-table information, but they do not continue executing.

**Example scenario:**
1. A parent creates a child process.
2. The child completes its task and exits.
3. The kernel records the child's exit status.
4. The parent does not call `wait()` or `waitpid()`.
5. The child remains a zombie.

**Understand:** Why does Linux preserve information about a process after it has exited?

## 5. What Happens Inside the System When a Process Terminates?
- The process finishes or is terminated by a signal.
- The kernel releases most of its resources, such as its memory mappings and open file descriptors.
- The kernel records the exit status and retains the information needed for the parent to collect it.
- The parent calls `wait()` or `waitpid()` to retrieve the status.
- The kernel reaps the child and removes its remaining process-table entry.

**Understand:** Why doesn't the kernel remove every trace of the process immediately when it exits?

## 6. What Is an Orphan Process, and What Happens to It?
- An orphan is a process whose parent exits before the child.
- The child can continue executing normally.
- Linux reparents it to an appropriate process, commonly PID 1 or a configured subreaper.
- The new parent can collect its exit status when it terminates.

**Understand:** How does Linux prevent a child from being left without a parent to collect its exit status?

## 7. How Does Linux Create a Process?
- `fork()` creates a child process.
- `exec()` replaces the current process image with a new program.
- `clone()` creates a task with configurable resource sharing; Linux uses it to implement processes and threads.
- The kernel assigns process identifiers and manages scheduling and resources.
- The scheduler runs eligible tasks when CPU time is available.

**Understand:** What happens between typing a command in the terminal and seeing its output?

## 8. How Does Linux Manage Multiple Processes?
- The kernel scheduler selects runnable tasks for CPU execution.
- Context switching allows the CPU to switch between tasks.
- Processes may wait for files, network data, user input, or other events.
- Virtual memory and permissions help isolate processes.
- Signals allow processes and users to request actions such as termination or suspension.

**Understand:** How can many programs appear to run simultaneously on a system with a limited number of CPU cores?

## 9. Practical Commands to Observe Process Behavior
```bash
ps -ef
ps -o pid,ppid,stat,cmd -p PID
pstree -p
top
sleep 100 &
echo $!
kill -STOP PID
kill -CONT PID
kill -TERM PID
```

- `ps -ef`: Lists processes.
- `ps ... stat`: Shows a process's state.
- `pstree -p`: Shows parent-child relationships.
- `top`: Monitors processes.
- `echo $!`: Prints the PID of the most recently backgrounded command in the current shell.
- `kill`: Sends a signal to a process.

# Linux Processes

## 1. Why Do We Need Processes?

### What is a Process?
- A **program** is a set of instructions stored on disk.
- A **process** is a program that is currently executing.
- Example: `firefox` is a program; when launched, it runs as one or more processes.

### Why Do We Need Processes?
- **Execute programs:** Run applications and commands.
- **CPU management:** Allow the kernel to schedule multiple tasks across CPU cores.
- **Memory management:** Give processes their own virtual address spaces.
- **Execution tracking:** Track PID, process state, and resource usage.
- **Security:** Apply permissions and control access to resources.
- **Failure isolation:** Allow one process to terminate without necessarily terminating unrelated processes.

### What Happens Behind the Scenes?
1. The user starts a program through a command or graphical application.
2. The shell or application requests execution.
3. The kernel creates or prepares a process to execute the program.
4. The kernel manages its PID, memory, permissions, and other resources.
5. The scheduler selects the process when it is eligible to run.
6. The CPU executes its instructions.
7. The process may continue running, wait for an event, or terminate.

### Real-World Example
- Listening to music while downloading a file and writing code.
- Linux manages the applications as processes and schedules their execution.
- Processes may share CPU time and run concurrently; actual parallel execution depends on available CPU cores.

### Practical Example

```bash
# Start a process in the background
sleep 100 &

# Display process information
ps -ef | grep '[s]leep'

# Display the PID of the background command
echo $!
```

### Key Takeaways
- A program is passive; a process is executing.
- The kernel manages process execution and resources.
- Each process has a PID and an execution state.
- The scheduler determines when eligible processes run.
- Processes help Linux manage multiple applications efficiently.

## 2. What Happens When a Process Runs in the Background?

### What Is a Background Process?
- A background process runs without requiring the shell to wait for it to finish before accepting another command.
- In Bash, `&` starts a command asynchronously as a background job.
- The process can continue running while you execute other commands in the terminal.
- Background execution does not mean the process always runs on a separate CPU core.

### Why Do We Need Background Processes?
- Run long-running commands without blocking the shell.
- Execute multiple tasks concurrently.
- Run scripts, downloads, and other jobs while continuing to work.
- Start tasks that do not require immediate interaction.

### What Happens Behind the Scenes?
1. You enter a command followed by `&`.
2. The shell starts the command as a background job.
3. The shell typically creates a child process and executes the requested program.
4. The shell returns the prompt without waiting for the command to finish.
5. The kernel schedules the process when it is eligible to run.
6. The process continues until it finishes, stops, or is terminated.

**Note:** Background jobs are managed by the shell. They are not automatically independent of the terminal or guaranteed to survive logout.

### Foreground vs Background

- **Foreground:** The shell waits for the command to finish before accepting another command.
- **Background:** The shell returns the prompt while the command continues running.

### Practical Example

```bash
# Run a command in the background
sleep 100 &

# Display its PID
echo $!

# List background jobs in the current shell
jobs -l

# Inspect the process
ps -o pid,ppid,stat,cmd -p $!

# Continue using the terminal
date

# Wait for the background process to finish
wait
```

### What Is `$!`?
- `$!` contains the PID of the most recently backgrounded command in the current shell.
- It is useful for identifying and managing a background process.

### What Is `nohup`?
- `nohup` makes a command ignore the hangup signal (`SIGHUP`).
- It can help a command continue after terminal disconnection.
- It does not automatically restart failed commands or manage services.

```bash
nohup sleep 300 > output.log 2>&1 &
```

### Important Points
- `&` starts a background job; it does not create a permanent service.
- The shell tracks its background jobs.
- The kernel manages process scheduling and execution.
- Interactive background jobs may be stopped if they attempt to read from the terminal.
- Terminal closure and shell configuration can affect background jobs.

### Key Takeaways
- Foreground jobs occupy the shell's command interaction until they finish or are suspended.
- Background jobs allow the shell to accept additional commands.
- The shell manages jobs, while the kernel manages process execution.
- `jobs`, `$!`, and `ps` help you inspect background execution.

# 2. What Happens When a Process Runs in the Background?

When we run a command with `&`, Linux allows it to execute in the background while the shell accepts new commands. The shell starts the command as a job and, typically, creates a child process to execute it. The kernel manages the process, assigns a PID, allocates necessary resources, and schedules it when CPU time is available. The process can run, sleep while waiting for an event, or terminate independently of the shell's next command.

### Example
```bash
sleep 100 &
echo $!
ps -ef | grep '[s]leep'
jobs
```

- `&` runs the command as a background job.
- `$!` displays the PID of the most recently backgrounded command.
- `ps` displays process information.
- `jobs` lists background and stopped jobs managed by the current shell.

**Key takeaway:** Background execution is a shell job-control feature. The Linux kernel schedules the process, while the shell allows you to continue working without waiting for that command to finish.

## 3. Process States and Lifecycle

A Linux process moves through different states during its lifetime. It can be **running or runnable (R)** when executing or waiting for CPU time, **interruptible sleep (S)** when waiting for an event, **uninterruptible sleep (D)** when waiting for certain kernel operations, **stopped (T)** when paused, or **zombie (Z)** when it has terminated but its parent has not collected its exit status. These states help the Linux kernel manage CPU scheduling, waiting tasks, and process termination.

### Practice
```bash
sleep 100 &
ps -o pid,ppid,stat,cmd -p $!
top
```

**Key takeaway:** A process changes states depending on whether it is executing, waiting, stopped, or terminated.

## 4. Zombie and Orphan Processes

A **zombie process** is a process that has terminated, but its parent has not collected its exit status using `wait()` or `waitpid()`. An **orphan process** is a process whose parent has terminated while the child is still running. Linux reparents the orphan to another process, commonly PID 1 or a configured subreaper. Zombies retain a small amount of process-table information, while orphan processes can continue executing normally.

### Practice
```bash
ps -eo pid,ppid,stat,cmd
```

**Key takeaway:** Zombies have exited but have not been reaped; orphans are still running after their parent exits.


## 5. Process Creation, Management, and Signals

Linux creates processes using mechanisms such as `fork()` and `clone()`, while `exec()` replaces a process's program with a new one. Each process has a PID and is managed by the kernel scheduler, which allocates CPU time. We can inspect processes using `ps` and `top`, find them using `pgrep`, and control them using signals such as `SIGTERM` (graceful termination), `SIGKILL` (forced termination), `SIGSTOP` (pause), and `SIGCONT` (resume). The `nice` and `renice` commands adjust scheduling niceness, while `jobs`, `bg`, `fg`, and `nohup` help manage shell jobs and background execution. The `/proc` filesystem provides information about process memory, status, and resources. Understanding these concepts helps troubleshoot high CPU usage, memory problems, unresponsive processes, and Linux services.

### Practice
```bash
ps -ef
top
pgrep -a sleep
sleep 100 &
kill -TERM $!
cat /proc/PID/status
```

**Key takeaway:** Linux provides process creation mechanisms, scheduling, signals, and monitoring tools to manage application execution and system resources.