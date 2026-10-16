* Logging is crucial for managing Linux servers, as it allows administrators to understand what is happening at any given time, including connections, user activity, and even troubleshooting hardware issues. Log files can provide a wide range of information for almost every use case.

* In Linux, log files are commonly found in the `/var/log` directory. While many log files end with a `.log` extension (e.g., `boot.log`), this is not always consistent, and some may have no extension or a different naming convention. Different Linux distributions may also name their log files differently; for instance, Fedora and Ubuntu (and related Debian-based systems) have some distinct log file names, though there's often overlap within distribution families.

Here are the commands used for log management, explained with examples:

*   **`cat`**
    *   **Purpose:** This command is used to display the content of text-based log files. It's a straightforward way to view the entire content of a file. However, for log files requiring root access, it must be prefixed with `sudo`.
    *   **Examples:**
        *   To view the `boot.log` file, which pertains to the boot process and is useful for troubleshooting boot issues:
            **`sudo cat boot.log`** (Note: A normal user might not have permission, so `sudo` is often required.)
        *   To view the `dnf.log` file (specific to Fedora and Red Hat-based systems), which shows a history of recently installed packages:
            **`cat dnf.log`**
        *   To view the `auth.log` file (common on Ubuntu/Debian systems), which contains login attempts and authorization-related events:
            **`sudo cat /var/log/auth.log`**
        *   To view the `syslog` file (system log), which records general system events and can be useful for troubleshooting hardware issues, like USB device detection:
            **`cat syslog`** (May require `sudo` if permissions are denied.)
        *   To view package history on Ubuntu/Debian systems, located in `/var/log/apt/history.log`:
            **`cat history.log`** (Usually viewable without `sudo`.)

*   **`ls`**
    *   **Purpose:** Used to list the contents of directories, including log files in `/var/log`. This helps to identify available log files.
    *   **Examples:**
        *   To list log files within the `/var/log` directory:
            **`ls`**
            **`ls -litr`**
            **`ls -ltr`**

*   **`last`**
    *   **Purpose:** This command is specifically used to view the contents of the `wtmp` (or `WTMP`) binary log file, which records all login and logout events. Attempting to `cat` a binary log file will result in unreadable characters.
    *   **Example:**
        *   To check login and logout events from the `wtmp` file:
            **`last`**

*   **`lastb`**
    *   **Purpose:** Similar to `last`, but used for the `btmp` (or `BTMP`) binary log file. The `btmp` file contains records of *bad* (failed) login attempts, useful for identifying potential intrusion attempts.
    *   **Example:**
        *   To view bad login attempts, optionally showing the hostname, matching DNS names, and full timestamps:
            **`sudo lastb -adF`** (The `-a` shows hostname, `-d` matches DNS, `-F` gives full times.)

*   **`tail -f`**
    *   **Purpose:** The `tail` command typically shows the last portion of a file. When combined with the `-f` (follow) option, it allows you to view the output of a text-based log file in real-time as new entries are added. This is an "important trick" for troubleshooting.
    *   **Examples:**
        *   To follow the `auth.log` file for real-time login attempt monitoring:
            **`sudo tail -f /var/log/auth.log`**
        *   To follow the `syslog` file, useful for real-time monitoring of system events, such as when inserting or removing a USB device:
            **`sudo tail -f syslog`** (The source describes this usage but doesn't explicitly show the full command typed out, only `tail this log file`. This example combines the command with the concept from the source.)

*   **`dmesg`**
    *   **Purpose:** This is a dedicated command to view the kernel log file, `dmesg.log`. It shows system-related events, particularly important for troubleshooting hardware as it reflects how the Linux kernel perceives attached devices. It's similar to `syslog` but provides more detailed, kernel-specific information, often with colorization when viewed via the command.
    *   **Example:**
        *   To view kernel messages, including hardware detection events:
            **`sudo dmesg`** (May require `sudo` to run, despite the file being potentially viewable without it.)

*   **`journalctl`**
    *   **Purpose:** Specific to systems that use `systemd` (like Fedora, Ubuntu, Debian, Arch). It allows you to inspect logs pertaining to specific *units* or *services* running on the system.
    *   **Examples:**
        *   To view log entries specific to a particular service, like SSH:
            **`journalctl -u ssh`**
        *   To follow the logs of a specific service in real-time, similar to `tail -f` but focused on a `systemd` unit:
            **`journalctl -fu ssh`** (Here, `-f` is for follow and `-u` for unit.)

These commands provide essential tools for understanding, monitoring, and troubleshooting events on a Linux system by interacting with its various log files.


* What is log management 

    * We can setup a cron to clean the logs automatically or to zip the log files
    
    1. Check if you have a logrotate config for Logstash:

    ```
       cat /etc/logrotate.d/logstash
    ```

    2. If you don't have a logrotate config for Logstash, you can create one:

    ```
       sudo vim /etc/logrotate.d/logstash
    ```

    3. Add the following configuration to the file:

    ```
       /var/log/logstash/*.log {
            daily
            rotate 7
            compress
            missingok
            notifempty
            copytruncate
       }
    ```

    4. Save and close the file.

    5. Logrotate will now automatically rotate, compress, and remove old log files for Logstash.

    ```
        sudo logrotate --debug /etc/logrotate.conf
    ```


* We had issue with logrotation of logstash.log file and because of that the disk space was increasing so what we did next is:

    * stop logstash service
    * copy the logs to s3 bucket , may be they will be used in future
    * We found that rsyslogs were getting dumped inside the logfile so we commented rsyslog file configuration to stop it from dumping logs into logstash.conf file
    * we restarted the logstash service and it started working fine

