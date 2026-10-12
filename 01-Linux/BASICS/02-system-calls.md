# Linux System Calls in Detail

> *Last Updated: 23 Jul, 2025*

A **system call** is a procedure that provides the interface between a process and the operating system. It is the way by which a computer program requests a service from the kernel of the operating system.

Different operating systems execute different system calls.

In Linux, making a system call involves transferring control from unprivileged **user mode** to privileged **kernel mode**; the details of this transfer vary from architecture to architecture. The libraries take care of collecting the system-call arguments and, if necessary, arranging those arguments in the special form necessary to make the system call.

---

## Categories of System Calls

System calls are divided into 5 categories mainly:

| Category | Description |
|----------|-------------|
| Process Control | Process creation, termination, etc. |
| File Management | File operations like create, read, write |
| Device Management | Device buffer operations |
| Information Maintenance | Information transfer between OS and user |
| Communication | Inter-process communication |

---

## 1. Process Control

This system calls perform the task of process creation, process termination, etc.

**Linux System calls:** `fork()`, `exit()`, `exec()`

### `fork()`

- A new process is created by the `fork()` system call
- A new process may be created with `fork()` without a new program being run—the new sub-process simply continues to execute exactly the same program that the first (parent) process was running
- It is one of the most widely used system calls under process management

### `exit()`

- The `exit()` system call is used by a program to terminate its execution
- The operating system reclaims resources that were used by the process after the `exit()` system call

### `exec()`

- A new program will start executing after a call to `exec()`
- Running a new program does not require that a new process be created first: any process may call `exec()` at any time
- The currently running program is immediately terminated, and the new program starts executing in the context of the existing process

---

## 2. File Management

File management system calls handle file manipulation jobs like creating a file, reading, and writing, etc.

**Linux System calls:** `open()`, `read()`, `write()`, `close()`

### `open()`

- It is the system call to open a file
- This system call just opens the file; to perform operations such as read and write, we need to execute different system calls

### `read()`

- This system call opens the file in reading mode
- We cannot edit the files with this system call
- Multiple processes can execute the `read()` system call on the same file simultaneously

### `write()`

- This system call opens the file in writing mode
- We can edit the files with this system call
- Multiple processes cannot execute the `write()` system call on the same file simultaneously

### `close()`

- This system call closes the opened file

---

## 3. Device Management

Device management does the job of device manipulation like reading from device buffers, writing into device buffers, etc.

**Linux System call:** `ioctl()`

### `ioctl()`

- `ioctl()` is referred to as **Input and Output Control**
- `ioctl` is a system call for device-specific input/output operations and other operations which cannot be expressed by regular system calls

---

## 4. Information Maintenance

It handles information and its transfer between the OS and the user program. In addition, OS keeps the information about all its processes and system calls are used to access this information.

**Linux System calls:** `getpid()`, `alarm()`, `sleep()`

### `getpid()`

- `getpid` stands for **Get the Process ID**
- The `getpid()` function shall return the process ID of the calling process
- The `getpid()` function shall always be successful and no return value is reserved to indicate an error

### `alarm()`

- This system call sets an alarm clock for the delivery of a signal that when it has to be reached
- It arranges for a signal to be delivered to the calling process

### `sleep()`

- This system call suspends the execution of the currently running process for some interval of time
- Meanwhile, during this interval, another process is given chance to execute

---

## 5. Communication

These types of system calls are specially used for inter-process communications.

### IPC Models

Two models are used for inter-process communication:

1. **Message Passing** — processes exchange messages with one another
2. **Shared Memory** — processes share memory region to communicate

**Linux System calls:** `pipe()`, `shmget()`, `mmap()`

### `pipe()`

- The `pipe()` system call is used to communicate between different Linux processes
- It is mainly used for inter-process communication
- The `pipe()` system function is used to open file descriptors

### `shmget()`

- `shmget` stands for **shared memory segment**
- It is mainly used for shared memory communication
- This system call is used to access the shared memory and access the messages in order to communicate with the process

### `mmap()`

- This function call is used to map or unmap files or devices into memory
- The `mmap()` system call is responsible for mapping the content of the file to the virtual memory space of the process

---

## Summary

These are the various system calls involved in the Linux operating system, organized by their primary function categories.