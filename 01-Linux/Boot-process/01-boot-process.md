## What is systemd?
 
* systemd is a system and service manager for Linux operating systems. It is the default initialization system for major Linux distributions. systemd is not directly initiated by the user, but installed through the /sbin/init and started during the early boot. systemd acts as the init system that brings up and maintains user space services when run as the first process on boot (PID 1). PID 1 is known as init and is the first Linux user-mode process created. It runs until the system shutdown.

* systemd owns PID 1, and is started directly by the kernel. All other processes are started directly by systemd or one of its child processes. systemd mounts the host's file system and manages temporary files. It is backward compatible with the SysV init scripts. SysV is an initialization system that predates systemd.

* In systemd, a unit is a resource that the system knows how to operate on and manage. This is the primary object that the systemd tools use. These resources are defined with configuration files called unit files.

* systemctl is the central management tool for controlling the init system. It is used to examine and control the state of the systemd system and service manager.

* Targets in systemd are groups of related units that act as synchronization points during a system boot. Target unit files have a .target file extension. Target units group together various systemd units through a chain of dependencies.

* For troubleshooting, you can use journalctl, which is used to query and display log messages from the systemd journal.

* For more information on systemd, you can refer to https://systemd.io and man 1 systemd.

## Linux boot process
 
* The Linux boot process is the initial stage of the operating system's startup. It is the process by which the operating system loads the memory, initializes the components and prepares to execute user applications.

### The Linux boot process is divided into four main stages:

#### Stage 1: BIOS

* When you power on your computer, your computer starts BIOS (Basic Input/Output System) and performs a POST (Power On Self Test). This is an integrity check that probes the hardware functionality of components such as hard disks, SSD, keyboard, RAM, USB ports and any other hardware. If the hardware works as expected, the boot process moves on to the next stage.

#### Stage 2: The boot loader

* Once POST is complete, BIOS searches for and loads the boot loader program stored in the MBR (Master Boot Record). The MBR is a 512-byte code that is usually located at /dev/sda or /dev/hda depending on your hard drive architecture. The MBR can also be located on a live USB or DVD installation of Linux. BIOS loads and executes this MBR code.

* There are three main boot loaders in Linux: LILO, GRUB and GRUB2. The GRUB2 (Grand Unified Bootloader) boot loader is the latest and primary boot loader in modern Linux distributions. The GRUB2 configuration file is located at /boot/grub2/grub2.cfg. Once BIOS locates the GRUB2 boot loader, It executes and loads it into the main memory (RAM).

#### Stage 3: Linux kernel initialization

* The Linux kernel is the heart of the operating system. In your Linux system, the kernel interfaces with the hardware, controls memory management and manages processes. The boot loader loads the selected Linux kernel. The kernel self extracts from a compressed version and mounts the root file system. It then runs the /sbin/init program.

#### Stage 4: systemd

* The kernel loads systemd, which is a system and service manager for Linux operating systems. systemd then runs all the other initialization processes.

#### 2.2 Boot process with systemd
 
* Once the kernel loads systemd, systemd takes over and starts the other system services that are required to bring the system up and running. This includes services such as networking service, the login manager, etc.

* The boot process is parallelized in the order in which specific target units are executed. systemd uses the /etc/systemd/system/default.target file to determine the target that the Linux system should boot into. This file is a link to graphical.target which boots the graphical login manager. systemd activates all target units that are dependencies of default.target as well as recursively all dependencies of these dependencies. Once all the services are started, your system is ready to use and the login manager displays. You can now log in and start using the system.

#### 2.3 Analyzing the system boot process performance with the systemd-analyze command
 
* Use the **systemd-analyze** command to analyze the performance of the system boot process. The command can also be used to retrieve other state and tracing information from the system and service manager. It is used to check that unit files are correct and also to access special functions useful for advanced system manager debugging.