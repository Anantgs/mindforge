# Linux Shells: An Overview

* This document provides a comprehensive overview of Linux shells, explaining their purpose and detailing various types available.

## What is a Linux Shell?

* A shell is a **program that acts as an interface between a user and the kernel**. When a user logs into a system or opens a console window, the kernel runs a new shell instance. The kernel is the core of any operating system, responsible for process control, management, execution, and ensuring proper utilization of system resources.

* Through a shell, users can **give commands to the kernel and receive responses**, enabling the execution of programs and utilities. Essentially, a shell is a program used to execute other programs on your system.

## Why Do We Need a Shell?

* Shells are powerful tools because they allow interaction with the kernel. **Without the ability to interact with the kernel, a user cannot access the utilities offered by their machine’s operating system**. Shells are an important part of any Linux user session, providing a means to accomplish tasks.

## Different Types of Shells in Linux

* Each shell possesses unique properties, making some more efficient for specific uses than others.

### 1. The Bourne Shell (sh)

*   **Developed by:** Steve Bourne at AT&T Bell Labs.
*   **Regarded as:** The first UNIX shell.
*   **Key Characteristics:**
    *   Gained popularity due to its **compact nature and high speeds of operation**.
    *   Is the **default shell for Solaris OS** and used for all Solaris system administration scripts.
*   **Major Drawbacks:**
    *   **Lacks in-built functionality for logical and arithmetic operations**.
    *   **Cannot recall previously used commands**.
    *   Lacks comprehensive features for interactive use.
*   **Complete Path-name:** `/bin/sh` and `/sbin/sh`.
*   **Default Prompt:** `#` for root user, `$` for non-root users.

### 2. The GNU Bourne-Again Shell (bash)

*   **More popularly known as:** Bash.
*   **Designed to be:** Compatible with the Bourne shell.
*   **Key Characteristics:**
    *   **Incorporates useful features from other shells** like the Korn shell and C shell.
    *   **Allows users to automatically recall previously used commands and edit them** using arrow keys, unlike the Bourne shell.
*   **Complete Path-name:** `/bin/bash`.
*   **Default Prompt:** `bash-VersionNumber#` for root user, `bash-VersionNumber$` for non-root users.

### 3. The C Shell (csh)

*   **Developed by:** Bill Joy at the University of California.
*   **Purpose:** Created to include useful programming features.
*   **Key Characteristics:**
    *   **In-built support for arithmetic operations**.
    *   Syntax similar to the C programming language.
    *   **Incorporated command history**, a feature missing in the Bourne shell.
    *   A prominent feature is "**aliases**".
*   **Complete Path-name:** `/bin/csh`.
*   **Default Prompt:** `hostname#` for root user, `hostname%` for non-root users.

### 4. The Korn Shell (ksh)

*   **Developed by:** David Korn at AT&T Bell Labs.
*   **Purpose:** Created to **improve upon the Bourne shell**.
*   **Key Characteristics:**
    *   Essentially a **superset of the Bourne shell**, supporting everything the Bourne shell does while adding new functionalities.
    *   Offers **in-built support for arithmetic operations** and interactive features similar to the C shell.
    *   Can run scripts made for the Bourne shell and also supports scripts written for the C shell.
    *   Offers **string, array, and function manipulation similar to the C programming language**.
    *   **Faster than most other shells in Linux**, including the C shell.
*   **Complete Path-name:** `/bin/ksh`.
*   **Default Prompt:** `#` for root user, `$` for non-root users.

### 5. The Z Shell (zsh)

*   **Also known as:** zsh.
*   **Description:** An **extension of the `sh` shell** with many improvements for customization. Considered a modern shell.
*   **Noteworthy Features:**
    *   Generate filenames based on given conditions.
    *   **Plugins and theming support**.
    *   Index of built-in functions.
    *   Command completion.
*   **Complete Path-name:** `/bin/zsh`.
*   **Default Prompt:** `<hostname>#` for root user, `<hostname>%` for non-root users.

## Summary Table of Shells

| Shell                      | Complete path-name       | Prompt for root user | Prompt for non-root user |
| :------------------------- | :----------------------- | :------------------- | :----------------------- |
| Bourne shell (sh)          | `/bin/sh` and `/sbin/sh` | `#`                  | `$`                      |
| GNU Bourne-Again shell (bash) | `/bin/bash`              | `bash-VersionNumber#`| `bash-VersionNumber$`    |
| C shell (csh)              | `/bin/csh`               | `#`                  | `%`                      |
| Korn shell (ksh)           | `/bin/ksh`               | `#`                  | `$`                      |
| Z Shell (zsh)              | `/bin/zsh`               | `<hostname>#`        | `<hostname>%`            |


## Conclusion

* **Shells are one of, if not the most powerful tools available to a Linux user**. It is practically impossible for a person to utilize the features and functionality offered by the kernel installed on their system without shells. While these are the most commonly used types, many other shell types are worth exploring.
