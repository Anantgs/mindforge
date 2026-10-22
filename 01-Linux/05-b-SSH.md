
# SSH Management — Complete Notes, Definitions, Commands, and Practical Lab

## Table of Contents

1. Introduction to SSH
2. Important SSH Definitions
3. Why SSH Is Required
4. SSH Architecture
5. How SSH Works
6. SSH vs Telnet vs RDP
7. SSH Installation
8. SSH Service Management
9. Basic SSH Commands
10. SSH Authentication Methods
11. SSH Key Management
12. SSH Configuration
13. SSH User and Access Management
14. Secure File Transfer Using SCP and SFTP
15. SSH Security Best Practices
16. Firewall and Port Management
17. SSH Logs and Monitoring
18. SSH Troubleshooting
19. SSH Client Configuration
20. SSH Tunneling and Port Forwarding
21. SSH Automation
22. SSH Practical Laboratory
23. Common Errors and Solutions
24. Frequently Asked Questions
25. Viva Questions with Answers
26. Practical Assessment
27. Command Cheat Sheet
28. Suggested Teaching Schedule
29. Final Summary
30. Lab Safety Guidelines

---

# 1. Introduction to SSH

## 1.1 What Is SSH?

SSH stands for **Secure Shell**.

SSH is a cryptographic network protocol that allows users to securely connect to and manage remote computers over a network.

It is commonly used by Linux administrators, system administrators, DevOps engineers, cloud engineers, and cybersecurity professionals.

SSH provides encrypted communication between a client computer and a remote server.

For example, an administrator can use SSH to connect to a Linux server located in another building, another city, or a cloud data center.

Instead of physically accessing the server, the administrator can execute commands remotely through a terminal.

### Example

```bash
ssh student@192.168.1.100
```

Explanation:

- `ssh`: Starts the SSH client.
- `student`: Username on the remote system.
- `192.168.1.100`: IP address of the remote server.

After successful authentication, the user receives a remote shell if the account and server permit shell access.

## 1.2 What Is Remote Administration?

Remote administration means managing a computer or server from another computer through a network.

Examples include:

- Installing software on a remote server.
- Creating and managing user accounts.
- Checking server performance.
- Reading system logs.
- Restarting services.
- Transferring files.
- Troubleshooting server problems.

SSH is one of the most common tools for remote administration of Linux and Unix-like systems.

## 1.3 What Is OpenSSH?

OpenSSH is a widely used, open-source implementation of the SSH protocol.

It provides utilities for secure remote access, authentication, file transfer, and tunneling.

Important OpenSSH components include:

- `ssh`: SSH client.
- `sshd`: SSH server daemon.
- `ssh-keygen`: Generates SSH keys.
- `ssh-agent`: Holds private-key credentials for use by client programs.
- `ssh-add`: Adds keys to an SSH agent.
- `scp`: Copies files securely.
- `sftp`: Provides an SSH-based file-transfer interface.
- `ssh-keyscan`: Retrieves server public host keys without authenticating the server.

Important: `ssh-keyscan` does not independently verify that a key belongs to the intended server.

---

# 2. Important SSH Definitions

## 2.1 SSH Client

An SSH client is a program that initiates a secure connection to an SSH server.

Example:

```bash
ssh student@192.168.1.100
```

The computer running this command acts as the SSH client.

## 2.2 SSH Server

An SSH server is a system that accepts SSH connections and provides services to authenticated users.

OpenSSH's server program is commonly called `sshd`.

On Ubuntu and Debian, the service is commonly named `ssh`. On many Red Hat-based systems, it is named `sshd`.

## 2.3 SSH Daemon

A daemon is a background process that provides a service.

The SSH daemon listens for incoming connections and handles connection setup and authentication.

## 2.4 IP Address

An IP address identifies a network interface or endpoint using the Internet Protocol.

Example:

```text
192.168.1.100
```

An SSH client normally needs the server's hostname or IP address to connect.

## 2.5 Port Number

A port number identifies a network service endpoint on a computer.

SSH commonly uses TCP port 22.

The port can be changed in the server configuration.

## 2.6 Authentication

Authentication is the process of verifying the identity of a user or system.

SSH may use passwords, public-key authentication, certificates, or multi-factor authentication, depending on its configuration.

## 2.7 Authorization

Authorization determines what an authenticated user is allowed to do.

For example, a user may be allowed to log in but may not be permitted to run administrative commands.

Authentication answers: "Who are you?"

Authorization answers: "What are you allowed to do?"

## 2.8 Encryption

Encryption transforms readable information into a protected form using cryptographic algorithms.

SSH encrypts session traffic so that an unauthorized observer cannot ordinarily read the transmitted commands and data.

## 2.9 Cryptographic Key

A cryptographic key is information used by a cryptographic algorithm.

SSH uses keys for several purposes, including server identity verification, key-based user authentication, and establishing protected sessions.

## 2.10 Host Key

A host key is a cryptographic key used by an SSH server to establish its identity.

The client checks the server's host-key identity against a trusted source, such as a previously recorded key or a verified fingerprint.

## 2.11 Public Key

A public key is the shareable part of an asymmetric cryptographic key pair.

For SSH user authentication, the server can use an authorized public key to verify proof that the client possesses the corresponding private key.

## 2.12 Private Key

A private key is the secret part of a cryptographic key pair.

It must be protected against unauthorized access.

Never send a private key to an administrator as a substitute for sharing a public key.

## 2.13 SSH Fingerprint

A fingerprint is a compact representation of a cryptographic public key.

Fingerprints help administrators verify that they are connecting to the intended server.

## 2.14 SSH Tunnel

An SSH tunnel forwards network traffic through an SSH connection.

It can be used to access an internal service securely without exposing that service directly to a network.

## 2.15 SSH Hardening

SSH hardening means configuring SSH to reduce the risk of unauthorized access.

Examples include restricting access to specific users, using strong authentication, limiting network exposure, protecting keys, and monitoring logs.

---

# 3. Why Is SSH Required?

SSH is important because modern systems are frequently managed remotely.

## 3.1 Secure Remote Access

SSH protects remote terminal sessions through encryption and cryptographic authentication.

## 3.2 Server Management

Administrators can manage services, inspect logs, install updates, and perform other administrative tasks remotely.

## 3.3 Cloud Computing

Cloud virtual machines commonly use SSH for administrative access to Linux instances.

## 3.4 Secure File Transfer

SCP and SFTP allow users to transfer files over SSH-based connections.

## 3.5 Automation

SSH can be used by scripts and configuration-management systems to perform authorized administrative tasks.

## 3.6 Network Device Management

Many routers, switches, firewalls, and other infrastructure devices support SSH-based management.

## 3.7 Common Use Cases

- Linux server administration.
- Cloud virtual machine access.
- Software deployment.
- Remote troubleshooting.
- Secure file transfers.
- Git operations over SSH.
- Access to internal services through tunnels.

---

# 4. SSH Architecture

SSH uses a client-server architecture.

## 4.1 Main Components

### Client

The client initiates the connection.

Example: A laptop running the `ssh` command.

### Server

The server accepts the connection.

Example: An Ubuntu virtual machine running OpenSSH Server.

### Network

The client and server communicate through a network using TCP.

### Host Keys

Host keys allow clients to verify the server's identity.

### User Credentials

The client proves that the user is authorized to access the requested account.

### Encrypted Session

After connection setup, SSH protects session traffic using negotiated cryptographic algorithms.

## 4.2 Architecture Diagram

```text
+--------------------------+
|      SSH Client          |
|                          |
|  ssh student@server      |
|  Private key / Password  |
+------------+-------------+
             |
             | TCP connection
             | Default port 22
             |
             v
+--------------------------+
|      SSH Server           |
|                           |
|  OpenSSH sshd             |
|  Host keys                |
|  Authentication policy    |
|  User accounts            |
+------------+-------------+
             |
             v
+--------------------------+
|   Authenticated Session   |
|                           |
|  Remote shell             |
|  Commands                 |
|  File transfer            |
+--------------------------+
```

## 4.3 Important Point

The SSH server's host key and a user's authentication key serve different purposes.

- The host key helps identify the server.
- The user's private key can prove the user's identity.
- The corresponding user public key is generally installed on the server.

Do not confuse server identity verification with user authentication.

---

# 5. How SSH Works

A simplified SSH connection follows these steps.

## Step 1: Client Initiates a Connection

The client contacts the server's hostname or IP address and TCP port.

Example:

```bash
ssh student@192.168.1.100
```

## Step 2: Protocol Negotiation

The client and server negotiate compatible cryptographic algorithms and SSH protocol capabilities.

## Step 3: Server Identity Verification

The server proves possession of its host key.

The client checks the host-key identity using its trust information.

On a first connection, SSH may ask whether the user trusts the presented host key.

The user should verify the fingerprint through a trusted channel before accepting it.

## Step 4: Session Protection Is Established

The client and server establish cryptographic session keys and use them to protect communication.

## Step 5: User Authentication

The user authenticates using a method permitted by the server.

For example:

- Password authentication.
- Public-key authentication.
- Certificate-based authentication.
- Multi-factor authentication.

## Step 6: Session Starts

After successful authentication and authorization, the server provides the requested service.

This may be an interactive shell, a remote command, or a file-transfer session.

## Step 7: Connection Ends

The user exits the remote session or closes the connection.

```bash
exit
```

---

# 6. SSH vs Telnet vs RDP

| Feature | SSH | Telnet | RDP |
|---|---|---|---|
| Full name | Secure Shell | Teletype Network | Remote Desktop Protocol |
| Main purpose | Secure remote shell | Remote terminal access | Remote graphical desktop |
| Default port | TCP 22 | TCP 23 | TCP 3389 |
| Encryption | Yes | No, by default | Uses security mechanisms such as TLS and/or RDP security, depending on configuration |
| Typical environment | Linux and Unix administration | Legacy systems and controlled labs | Windows desktop administration |
| File transfer | SCP and SFTP | No standard secure file-transfer feature | File transfer can be supported through configured features |
| Security suitability | Preferred for secure remote shell access | Unsuitable for sensitive traffic on untrusted networks | Requires appropriate security configuration |

## Why Is SSH Better Than Telnet?

Traditional Telnet does not encrypt session traffic by default.

SSH protects authentication and session traffic using cryptographic mechanisms.

Therefore, SSH is generally preferred for remote command-line administration.

---

# 7. Installing SSH

The following commands are intended for authorized lab systems.

## 7.1 Install SSH on Ubuntu or Debian

Update package information:

```bash
sudo apt update
```

Install the server:

```bash
sudo apt install openssh-server
```

Check the service:

```bash
sudo systemctl status ssh
```

Start the service:

```bash
sudo systemctl start ssh
```

Enable it at boot:

```bash
sudo systemctl enable ssh
```

Enable and start it in one command:

```bash
sudo systemctl enable --now ssh
```

## 7.2 Install SSH on RHEL, Fedora, or Rocky Linux

On systems using DNF:

```bash
sudo dnf install openssh-server
```

Start and enable the server:

```bash
sudo systemctl enable --now sshd
```

Check its status:

```bash
sudo systemctl status sshd
```

## 7.3 Verify the SSH Installation

Check the client version:

```bash
ssh -V
```

Check whether the server service is running:

```bash
sudo systemctl status ssh
```

For systems using the `sshd` service name:

```bash
sudo systemctl status sshd
```

Check listening TCP sockets:

```bash
sudo ss -tlnp
```

To filter for SSH-related entries:

```bash
sudo ss -tlnp | grep ssh
```

## 7.4 Find the Server IP Address

On Linux:

```bash
ip addr
```

Alternatively:

```bash
hostname -I
```

These commands can show local interface addresses. The address suitable for SSH depends on the network configuration.

---

# 8. SSH Service Management

Service management means controlling and inspecting the background service that accepts SSH connections.

## 8.1 Check Service Status

Ubuntu/Debian:

```bash
sudo systemctl status ssh
```

RHEL-family systems:

```bash
sudo systemctl status sshd
```

The output shows whether the service is active, inactive, or failed.

## 8.2 Start the Service

```bash
sudo systemctl start ssh
```

This starts the service immediately but does not necessarily enable it at boot.

## 8.3 Stop the Service

```bash
sudo systemctl stop ssh
```

Stopping SSH prevents new connections from being accepted by that service.

On a remote server, this may prevent further administrative access.

## 8.4 Restart the Service

```bash
sudo systemctl restart ssh
```

Restarting stops and starts the service.

Use caution when managing SSH remotely.

## 8.5 Reload the Service

```bash
sudo systemctl reload ssh
```

Reloading asks the service to re-read its configuration where supported.

## 8.6 Enable SSH at Boot

```bash
sudo systemctl enable ssh
```

This configures the service to start automatically during system startup.

## 8.7 Disable Automatic Startup

```bash
sudo systemctl disable ssh
```

This disables automatic startup but does not necessarily stop a service that is already running.

## 8.8 Important Service Commands

| Command | Explanation |
|---|---|
| `systemctl status ssh` | Shows service status |
| `systemctl start ssh` | Starts the service |
| `systemctl stop ssh` | Stops the service |
| `systemctl restart ssh` | Restarts the service |
| `systemctl reload ssh` | Reloads configuration where supported |
| `systemctl enable ssh` | Enables startup at boot |
| `systemctl disable ssh` | Disables startup at boot |

Use `sshd` instead of `ssh` on systems where that is the service name.

---

# 9. Basic SSH Commands

## 9.1 Connect to a Remote Server

```bash
ssh username@server_ip
```

Example:

```bash
ssh student@192.168.1.100
```

The command requests a connection to the server using the specified username.

## 9.2 Connect to a Hostname

```bash
ssh student@server.example.com
```

The hostname must resolve to the intended server.

## 9.3 Connect Using a Custom Port

```bash
ssh -p 2222 student@192.168.1.100
```

The server must actually listen on TCP port 2222, and network rules must permit access.

## 9.4 Run a Remote Command

```bash
ssh student@192.168.1.100 "hostname"
```

This executes the `hostname` command on the remote server.

Another example:

```bash
ssh student@192.168.1.100 "whoami"
```

The command shows the effective remote username.

## 9.5 Check Disk Space Remotely

```bash
ssh student@192.168.1.100 "df -h"
```

The `df -h` command reports filesystem usage in human-readable units.

## 9.6 Debug an SSH Connection

```bash
ssh -v student@192.168.1.100
```

For more detailed diagnostic output:

```bash
ssh -vvv student@192.168.1.100
```

Verbose output helps identify where connection setup or authentication fails. Avoid sharing logs without reviewing them for sensitive information.

## 9.7 Disconnect

```bash
exit
```

This exits the remote shell.

---

# 10. SSH Authentication Methods

Authentication verifies that the user is permitted to access an account.

## 10.1 Password Authentication

Password authentication uses an account password.

Example:

```bash
ssh student@192.168.1.100
```

The server may prompt for the account password if password authentication is enabled.

Advantages:

- Easy to understand.
- Familiar to beginners.
- Simple for introductory demonstrations.

Disadvantages:

- Passwords may be guessed or stolen.
- Users may reuse weak passwords.
- Automated password attacks can target exposed servers.

## 10.2 Public-Key Authentication

Public-key authentication uses a cryptographic key pair.

The user keeps the private key and the server stores the authorized public key.

The client proves possession of the private key without sending the private key itself to the server.

Advantages:

- Can reduce reliance on passwords.
- Supports strong authentication.
- Works well for controlled automation.
- Can be protected with a passphrase.

## 10.3 Certificate-Based Authentication

SSH certificates allow a trusted certificate authority to issue credentials that identify users or hosts.

Certificates can simplify large-scale key management when supported and properly configured.

## 10.4 Multi-Factor Authentication

Multi-factor authentication requires more than one authentication factor.

An organization may combine a public key with another factor, such as a one-time code.

## 10.5 Which Method Is Recommended?

For many administrative environments, managed public-key authentication is a good choice.

Sensitive environments may also require certificates, multi-factor authentication, or centralized identity management.

The correct method depends on organizational policy and the threat model.

---

# 11. SSH Key Management

## 11.1 What Is an SSH Key Pair?

An SSH key pair consists of a private key and a corresponding public key.

Example files:

```text
~/.ssh/id_ed25519
~/.ssh/id_ed25519.pub
```

The first is the private key. The second is the public key.

## 11.2 Generate an Ed25519 Key Pair

```bash
ssh-keygen -t ed25519 -C "student@example.com"
```

Explanation:

- `ssh-keygen`: Key-generation utility.
- `-t ed25519`: Selects the Ed25519 key type.
- `-C`: Adds a descriptive comment.

The program asks where to save the key and whether to use a passphrase.

Use a passphrase when appropriate.

## 11.3 Display the Public Key

```bash
cat ~/.ssh/id_ed25519.pub
```

The public key can be installed on a server.

Never publish the contents of the private-key file.

## 11.4 Copy the Public Key to a Server

```bash
ssh-copy-id student@192.168.1.100
```

This utility installs a public key into the remote account's authorized-keys file on supported systems.

The remote account and server must permit the required operation.

## 11.5 Connect Using a Specific Key

```bash
ssh -i ~/.ssh/id_ed25519 student@192.168.1.100
```

The `-i` option specifies an identity file.

## 11.6 Protect SSH Key Permissions

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/authorized_keys
```

These are common permission settings for a user's SSH files.

The files must also have appropriate ownership.

## 11.7 What Is an SSH Agent?

An SSH agent holds access to loaded private-key credentials so that client programs can use them without repeatedly asking the user to unlock a passphrase-protected key.

Start an agent in environments where required:

```bash
eval "$(ssh-agent -s)"
```

Add a key:

```bash
ssh-add ~/.ssh/id_ed25519
```

List loaded identities:

```bash
ssh-add -l
```

Remove all identities from the current agent:

```bash
ssh-add -D
```

Agent forwarding should be used cautiously because access to a forwarded agent can create security risks.

## 11.8 SSH Key Revocation and Rotation

Key rotation means replacing a key with a new one.

Revocation means removing or invalidating a credential that should no longer be trusted.

When a user leaves an organization or a key is compromised:

1. Identify systems that trust the key.
2. Remove the public key from the relevant authorized-key entries or central access system.
3. Revoke related certificates or credentials where applicable.
4. Replace compromised keys.
5. Review logs for suspicious activity.

---

# 12. SSH Configuration

SSH has client-side and server-side configuration.

## 12.1 Server Configuration File

The typical OpenSSH server configuration file is:

```text
/etc/ssh/sshd_config
```

This file controls settings used by the SSH server.

## 12.2 Back Up the Configuration

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
```

A backup provides a recovery point if a change causes problems.

## 12.3 Edit the Configuration

```bash
sudo nano /etc/ssh/sshd_config
```

Use a text editor to inspect or modify the file.

Some distributions also use additional configuration files through an `Include` directive. Effective settings may therefore depend on more than one file.

## 12.4 Important Server Settings

### Port

```text
Port 22
```

Defines a listening port. Port 22 is the standard SSH port.

### PermitRootLogin

```text
PermitRootLogin no
```

Disables direct root login when this setting is effective.

Administrators can instead use a named account with controlled privilege escalation.

### PubkeyAuthentication

```text
PubkeyAuthentication yes
```

Enables public-key authentication.

### PasswordAuthentication

```text
PasswordAuthentication no
```

Disables password authentication when this setting is effective.

Before applying this setting, verify that key-based access works for all required administrative accounts and that a recovery path exists.

### AllowUsers

```text
AllowUsers student
```

Restricts login to the listed users.

Add only accounts that should be allowed to connect.

### AllowGroups

```text
AllowGroups sshusers
```

Restricts access to members of specified groups.

Ensure that the intended administrative users belong to the allowed group.

### MaxAuthTries

```text
MaxAuthTries 4
```

Sets a limit on authentication attempts per connection. Choose a value suitable for the environment.

## 12.5 Validate the Configuration

```bash
sudo sshd -t
```

The command checks SSH server configuration syntax and some related validity conditions.

No output generally indicates that the syntax check succeeded.

## 12.6 Inspect Effective Settings

```bash
sudo sshd -T
```

This displays effective server settings in a normalized form.

Some settings may depend on connection-specific conditions, so use appropriate options when diagnosing conditional configuration.

## 12.7 Apply Configuration Changes

Ubuntu/Debian:

```bash
sudo systemctl reload ssh
```

RHEL-family systems:

```bash
sudo systemctl reload sshd
```

If reload is unsupported or inappropriate for the change, follow the platform's documented procedure.

## 12.8 Safe Remote Configuration Procedure

1. Back up the current configuration.
2. Make one change at a time.
3. Validate the configuration using `sshd -t`.
4. Keep the current administrative session open.
5. Reload or apply the change using the appropriate procedure.
6. Test a second connection in a new terminal.
7. Confirm that the intended authentication method works.
8. Close the original session only after successful verification.

Never experiment with SSH access settings on a production server without a recovery plan.

---

# 13. SSH User and Access Management

SSH access should follow the principle of least privilege.

This means giving each user only the access required to perform their work.

## 13.1 Create a Lab User

On a Linux lab server:

```bash
sudo adduser student
```

The exact user-creation command may vary by distribution.

## 13.2 Create the SSH Directory

When needed:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```

These commands apply to the current user's home directory.

## 13.3 Create an Authorized-Keys File

```bash
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

The file contains public keys authorized for that account.

Appropriate ownership is also required.

## 13.4 Restrict Access to Selected Users

In the server configuration:

```text
AllowUsers student adminuser
```

Only list the intended accounts.

Validate the configuration and verify administrative access before applying restrictive settings.

## 13.5 Remove a User's Key

Edit the relevant user's authorized-keys file and remove the specific public-key entry.

```bash
nano ~/.ssh/authorized_keys
```

If keys are managed centrally, remove the credential from the central management system instead.

## 13.6 User Account Management vs SSH Management

SSH management controls remote access.

Linux account management controls the underlying users, groups, passwords, permissions, and privileges.

Both areas must be configured correctly for secure access.

---

# 14. Secure File Transfer Using SCP and SFTP

## 14.1 What Is SCP?

SCP stands for Secure Copy Protocol in the historical protocol sense and is also the name of the OpenSSH file-copy utility.

Modern OpenSSH `scp` uses SFTP over SSH by default. Older implementations and explicit legacy modes may behave differently.

SCP is useful for copying files between computers.

### Copy a Local File to a Remote Server

```bash
scp file.txt student@192.168.1.100:~/
```

### Copy a Remote File to the Local Machine

```bash
scp student@192.168.1.100:~/file.txt ./
```

### Copy a Directory

```bash
scp -r project/ student@192.168.1.100:~/
```

## 14.2 What Is SFTP?

SFTP stands for SSH File Transfer Protocol.

It provides file-transfer operations over an SSH connection.

Connect:

```bash
sftp student@192.168.1.100
```

Common SFTP commands:

```text
pwd
lpwd
ls
lls
cd directory
lcd local_directory
put file.txt
get file.txt
mkdir new_directory
bye
```

Explanation:

- `pwd`: Shows the remote working directory.
- `lpwd`: Shows the local working directory.
- `ls`: Lists remote files.
- `lls`: Lists local files.
- `cd`: Changes the remote directory.
- `lcd`: Changes the local directory.
- `put`: Uploads a file.
- `get`: Downloads a file.
- `mkdir`: Creates a remote directory.
- `bye`: Ends the SFTP session.

## 14.3 SCP vs SFTP

SCP is convenient for straightforward copy operations.

SFTP is useful when users need an interactive file-transfer session and commands for navigating directories.

Both can use SSH to protect data in transit.

---

# 15. SSH Security Best Practices

## 15.1 Use Strong Authentication

Prefer managed public-key authentication or other approved strong authentication methods.

Use unique, protected credentials.

## 15.2 Protect Private Keys

- Never share private keys.
- Use appropriate file permissions.
- Protect keys with passphrases where practical.
- Store backups securely.
- Remove keys that are no longer needed.

## 15.3 Disable Direct Root Login Where Appropriate

Example:

```text
PermitRootLogin no
```

Use named accounts and controlled privilege escalation instead.

## 15.4 Restrict Users

Use `AllowUsers`, `AllowGroups`, centralized identity management, or other access controls as appropriate.

## 15.5 Use Firewalls

Permit SSH only from trusted management networks where feasible.

## 15.6 Verify Host Keys

Verify fingerprints through a trusted channel.

A changed host-key warning can indicate a legitimate rebuild, a changed destination, or a security issue.

Do not blindly accept a changed key.

## 15.7 Keep Software Updated

Install supported OpenSSH and operating-system security updates.

## 15.8 Monitor Authentication Logs

Review failed and successful logins for suspicious patterns.

## 15.9 Apply Least Privilege

Do not give every SSH user administrative privileges.

## 15.10 Consider Multi-Factor Authentication

Use additional authentication factors where required by the risk level and organizational policy.

## 15.11 Understand Brute-Force Protection

Brute-force protection can include network restrictions, rate limits, centralized authentication controls, monitoring, and intrusion-prevention tools.

No single tool replaces secure configuration and patching.

## 15.12 Is Changing the Default Port Enough?

No.

Changing port 22 to another port may reduce noise from simple automated scans, but it does not replace authentication, firewall restrictions, monitoring, or software updates.

---

# 16. Firewall and Port Management

## 16.1 What Is a Firewall?

A firewall controls network traffic according to configured rules.

It can allow or block traffic based on addresses, ports, protocols, and connection characteristics.

## 16.2 What Is TCP Port 22?

TCP port 22 is the standard port for SSH.

A server may use a different port if configured to do so.

## 16.3 Check UFW Status

On systems using UFW:

```bash
sudo ufw status
```

## 16.4 Allow SSH Through UFW

```bash
sudo ufw allow 22/tcp
```

This permits TCP port 22 through UFW.

Only apply the rule if it matches the intended access policy.

## 16.5 Restrict SSH to a Trusted Network

Example:

```bash
sudo ufw allow from 192.168.1.0/24 to any port 22 proto tcp
```

The subnet is an example. Replace it with the actual trusted management network.

## 16.6 Verify Listening Ports

```bash
sudo ss -tlnp
```

This lists listening TCP sockets.

## 16.7 Important Warning

Before changing firewall rules on a remote server:

- Confirm the correct SSH port.
- Confirm the source IP or management network.
- Preserve an authorized recovery path.
- Avoid locking yourself out.
- Test the connection after making changes.

Cloud security groups, network ACLs, host firewalls, and intermediate firewalls may all affect connectivity.

---

# 17. SSH Logs and Monitoring

Logs help administrators investigate authentication attempts, service failures, and suspicious activity.

## 17.1 What Is a Log File?

A log records events produced by a system or application.

SSH-related logs may record authentication successes, failures, configuration errors, and service events.

## 17.2 View Ubuntu/Debian SSH Service Logs

```bash
sudo journalctl -u ssh
```

View recent entries:

```bash
sudo journalctl -u ssh -n 50
```

Follow new entries:

```bash
sudo journalctl -u ssh -f
```

## 17.3 View RHEL-Family SSH Logs

```bash
sudo journalctl -u sshd
```

Follow new entries:

```bash
sudo journalctl -u sshd -f
```

## 17.4 Authentication Log Files

Depending on the distribution and logging configuration, authentication messages may also appear in files such as:

```text
/var/log/auth.log
/var/log/secure
```

For example, on systems using `/var/log/auth.log`:

```bash
sudo tail -f /var/log/auth.log
```

On systems using `/var/log/secure`:

```bash
sudo tail -f /var/log/secure
```

Not every distribution uses both files.

## 17.5 What Should Administrators Monitor?

- Repeated failed authentication attempts.
- Successful logins at unusual times.
- Unexpected accounts accessing the server.
- Changes to authorized keys.
- Unexpected SSH configuration changes.
- Service crashes and startup failures.
- Access from unfamiliar network addresses.

Log monitoring should follow organizational privacy, retention, and incident-response policies.

---

# 18. SSH Troubleshooting

Troubleshooting means identifying and correcting the cause of a problem.

A good troubleshooting process starts with the exact error message and checks one possible cause at a time.

## 18.1 Connection Timed Out

### Meaning

The client did not establish the expected connection within the permitted time.

### Possible Causes

- Incorrect IP address or hostname.
- Server is unreachable.
- Firewall blocks the traffic.
- Routing problem.
- Wrong port.
- Network outage.

### Checks

```bash
ssh -vvv student@192.168.1.100
```

Check server-side listening sockets:

```bash
sudo ss -tlnp
```

Ping may be useful as an initial network test, but some networks block ICMP traffic.

## 18.2 Connection Refused

### Meaning

The destination actively refused the TCP connection, often because no service is listening on that address and port.

### Possible Causes

- SSH service is stopped.
- Wrong port.
- Server is not listening on the expected interface.
- A firewall or network device is rejecting connections.

### Checks

```bash
sudo systemctl status ssh
```

Or:

```bash
sudo systemctl status sshd
```

Then:

```bash
sudo ss -tlnp
```

## 18.3 Permission Denied (publickey)

### Meaning

The server did not accept the attempted public-key authentication.

### Possible Causes

- Wrong username.
- Incorrect private key.
- Public key missing from `authorized_keys`.
- Incorrect file ownership or permissions.
- Authentication policy blocks the key.
- Account restrictions.

### Checks

```bash
ssh -vvv student@192.168.1.100
```

Check the server's SSH logs and authorized-key configuration.

## 18.4 Host Key Verification Failed

### Meaning

The server's presented host key does not match the client's stored trust information, or verification otherwise failed.

### Possible Causes

- Server was rebuilt.
- Host key was changed.
- DNS or IP now points to another server.
- Potential interception or unauthorized infrastructure changes.

### Correct Response

1. Stop and investigate.
2. Verify the intended server and its fingerprint through a trusted channel.
3. Determine why the key changed.
4. Update trusted host information only after verification.

Never blindly delete the old key and accept the new one.

## 18.5 SSH Service Fails to Start

### Check Configuration Syntax

```bash
sudo sshd -t
```

### Check Service Status

```bash
sudo systemctl status ssh
```

Or:

```bash
sudo systemctl status sshd
```

### Inspect Logs

```bash
sudo journalctl -u ssh
```

Or:

```bash
sudo journalctl -u sshd
```

Review the actual error and correct the underlying problem.

## 18.6 Permission Problems in the SSH Directory

Check permissions and ownership:

```bash
ls -ld ~/.ssh
ls -l ~/.ssh
```

Common permissions include:

```text
~/.ssh                 700
~/.ssh/id_ed25519      600
~/.ssh/authorized_keys 600
```

These are examples, not universal requirements for every file or configuration.

---

# 19. SSH Client Configuration

The SSH client can store connection preferences to avoid repeatedly typing long commands.

## 19.1 Client Configuration File

The common per-user file is:

```text
~/.ssh/config
```

## 19.2 Example Configuration

```text
Host labserver
    HostName 192.168.1.100
    User student
    Port 22
    IdentityFile ~/.ssh/id_ed25519
```

## 19.3 Connect Using the Alias

Instead of typing the full connection command:

```bash
ssh student@192.168.1.100
```

Use:

```bash
ssh labserver
```

SSH reads the matching client configuration.

## 19.4 Protect the Client Configuration

A common permission is:

```bash
chmod 600 ~/.ssh/config
```

Review configuration files before sharing them because they may reveal usernames, internal hostnames, or network details.

---

# 20. SSH Tunneling and Port Forwarding

## 20.1 What Is SSH Tunneling?

SSH tunneling forwards network traffic through an SSH connection.

It can allow a client to reach a service that is accessible from the SSH server but not directly from the client's network.

## 20.2 Local Port Forwarding

Local port forwarding makes a local port forward traffic to a destination reachable from the remote SSH server.

Example:

```bash
ssh -L 8080:127.0.0.1:80 student@192.168.1.100
```

Explanation:

- `-L`: Creates local port forwarding.
- `8080`: Local port on the client.
- `127.0.0.1:80`: Destination as reached from the SSH server.
- `student@192.168.1.100`: SSH server and account.

If the forwarding succeeds and the destination service is reachable, the client can access the forwarded service through its local port.

For example, a local application might connect to:

```text
http://127.0.0.1:8080
```

This is an example only. Use the tunnel solely for services you are authorized to access.

## 20.3 Remote Port Forwarding

Remote port forwarding makes a port on the remote side forward traffic to a destination reachable from the client side.

Example:

```bash
ssh -R 9000:127.0.0.1:3000 student@192.168.1.100
```

The remote SSH server's port 9000 forwards to port 3000 on the client side, subject to SSH server policy and binding settings.

## 20.4 Dynamic Port Forwarding

Dynamic forwarding provides a local SOCKS proxy.

Example:

```bash
ssh -D 1080 student@192.168.1.100
```

Applications configured to use the local SOCKS proxy can send supported traffic through the SSH connection.

## 20.5 Security Considerations

- Use tunneling only with authorization.
- Restrict forwarding where it is not needed.
- Understand which services become reachable.
- Protect the SSH account and host.
- Avoid exposing forwarded ports to unintended interfaces.

---

# 21. SSH Automation

## 21.1 What Is Automation?

Automation means using scripts or tools to perform repetitive tasks with limited manual intervention.

SSH is commonly used to run authorized remote commands and support deployment workflows.

## 21.2 Example: Run a Remote Command

```bash
ssh student@192.168.1.100 "uptime"
```

This displays the remote system's uptime and load information.

## 21.3 Example: Run a Command on Several Lab Servers

```bash
for host in 192.168.1.100 192.168.1.101
do
    ssh student@"$host" "hostname"
done
```

This example connects to each listed server and runs `hostname`.

It assumes the servers are reachable and the user has authorized access.

## 21.4 Automation Best Practices

- Use dedicated accounts with limited privileges.
- Protect private keys and credentials.
- Avoid embedding passwords in scripts.
- Check command exit statuses.
- Handle connection failures.
- Log relevant operations.
- Use configuration-management tools where appropriate.
- Review scripts before running them on multiple systems.

## 21.5 Non-Interactive Commands

The SSH client can execute a remote command and return its exit status.

Example:

```bash
ssh student@192.168.1.100 "df -h"
```

Automation should not disable host-key checking blindly. Establish trusted host identities in advance.

---

# 22. SSH Practical Laboratory

## Lab Title

**Installing, Configuring, Securing, and Troubleshooting SSH**

## Objective

By completing this lab, students will learn to:

1. Explain SSH architecture.
2. Install OpenSSH Server.
3. Start and inspect the SSH service.
4. Connect to a remote Linux server.
5. Generate an SSH key pair.
6. Configure public-key authentication.
7. Transfer files using SCP and SFTP.
8. Inspect SSH configuration and logs.
9. Apply basic security controls.
10. Diagnose common SSH errors.

## Requirements

- A Linux client.
- A Linux server or virtual machine.
- Network connectivity between the systems.
- An authorized non-root lab account.
- Administrative privileges on the lab server for service-management exercises.

## Task 1: Install OpenSSH Server

On Ubuntu/Debian:

```bash
sudo apt update
sudo apt install openssh-server
```

Check the service:

```bash
sudo systemctl status ssh
```

Expected result: Students should identify whether the service is active.

## Task 2: Find the Server IP Address

On the server:

```bash
ip addr
```

Identify the appropriate IP address for the lab network.

Do not assume that a loopback, container, or isolated virtual-network address is reachable from the client.

## Task 3: Connect to the Server

From the client:

```bash
ssh student@SERVER_IP
```

Replace `SERVER_IP` with the actual server address.

Students should identify the host-key verification prompt and verify the fingerprint before accepting it.

## Task 4: Run Remote Commands

Inside the SSH session:

```bash
hostname
whoami
uname -a
df -h
```

Students should explain the output of each command.

## Task 5: Generate an SSH Key Pair

On the client:

```bash
ssh-keygen -t ed25519 -C "student@example.com"
```

Students should identify the private-key and public-key files.

## Task 6: Configure Key-Based Authentication

Install the public key:

```bash
ssh-copy-id student@SERVER_IP
```

Test the connection:

```bash
ssh student@SERVER_IP
```

Expected result: The client should authenticate using the configured key, assuming the server policy permits it.

## Task 7: Transfer a File

Create a sample file:

```bash
echo "SSH practical exercise" > lab.txt
```

Copy it to the server:

```bash
scp lab.txt student@SERVER_IP:~/
```

Verify it remotely:

```bash
ssh student@SERVER_IP "cat ~/lab.txt"
```

## Task 8: Inspect SSH Service and Configuration

Check service status:

```bash
sudo systemctl status ssh
```

Check listening sockets:

```bash
sudo ss -tlnp
```

Inspect the configuration:

```bash
sudo nano /etc/ssh/sshd_config
```

Validate syntax:

```bash
sudo sshd -t
```

Students should identify the port, authentication settings, and root-login policy.

## Task 9: Review Logs

On Ubuntu/Debian:

```bash
sudo journalctl -u ssh
```

On systems using `sshd`:

```bash
sudo journalctl -u sshd
```

Students should identify service events and relevant authentication failures.

## Task 10: Troubleshooting Exercise

The instructor can introduce a controlled issue in the isolated lab, such as an incorrect username or a stopped SSH service.

Students must:

1. Record the exact error.
2. Identify possible causes.
3. Check connectivity and service status.
4. Inspect verbose SSH output.
5. Review relevant logs.
6. Correct the issue.
7. Confirm that access works again.

Only introduce faults that can be safely reversed.

## Lab Completion Checklist

- [ ] Installed or verified OpenSSH Server.
- [ ] Identified the server IP address.
- [ ] Connected to the server.
- [ ] Executed remote commands.
- [ ] Generated an SSH key pair.
- [ ] Configured key-based authentication.
- [ ] Transferred a file using SCP.
- [ ] Inspected the SSH service.
- [ ] Validated server configuration.
- [ ] Reviewed logs.
- [ ] Explained common troubleshooting steps.

---

# 23. Common SSH Errors and Solutions

| Error | Meaning | Suggested Checks |
|---|---|---|
| Connection timed out | Connection did not complete in time | Check network, IP, port, routing, and firewalls |
| Connection refused | Connection was actively rejected | Check service status, listening address, port, and firewall |
| Permission denied (publickey) | Public-key authentication was not accepted | Check username, key, authorized_keys, permissions, and policy |
| Host key verification failed | Host identity verification failed | Verify the server fingerprint and investigate changes |
| Could not resolve hostname | Hostname could not be resolved | Check spelling and DNS configuration |
| No route to host | Network path is unavailable or rejected | Check routing, interfaces, and network filtering |
| Too many authentication failures | Too many identities or attempts may have been tried | Inspect agent identities and use the intended key |
| Connection reset | Connection was unexpectedly closed | Inspect server logs, network devices, and service health |

A correct troubleshooting process relies on actual diagnostic output rather than guessing.

---

# 24. Frequently Asked Questions

## Q1. What is SSH?

SSH is a cryptographic network protocol for secure remote access and related services.

## Q2. What is the default SSH port?

TCP port 22.

## Q3. What is the SSH server program called?

In OpenSSH, the server program is called `sshd`.

## Q4. What is the difference between SSH and Telnet?

SSH protects communication through encryption. Traditional Telnet does not encrypt traffic by default.

## Q5. What is the difference between a public key and a private key?

The public key can be distributed to systems that should trust it for authentication. The private key must remain secret.

## Q6. What is `authorized_keys`?

It is a file that commonly lists public keys authorized for SSH login to a particular account.

## Q7. What is `known_hosts`?

It stores host identities that an SSH client has previously trusted or otherwise recorded.

## Q8. What is `sshd_config`?

It is the primary OpenSSH server configuration file on many systems.

## Q9. What is SCP?

SCP is an OpenSSH utility for copying files over SSH-based connections.

## Q10. What is SFTP?

SFTP is the SSH File Transfer Protocol, used for file transfer over an SSH connection.

## Q11. How do you check SSH service status?

Ubuntu/Debian commonly use:

```bash
sudo systemctl status ssh
```

Many RHEL-family systems use:

```bash
sudo systemctl status sshd
```

## Q12. How do you validate SSH configuration?

```bash
sudo sshd -t
```

## Q13. Why should direct root login be restricted?

Direct root access increases the impact of credential compromise and makes individual administrative activity harder to attribute. Named accounts and controlled privilege escalation are often preferable.

## Q14. What is SSH tunneling?

SSH tunneling forwards network traffic through an SSH connection.

## Q15. What should you do if a host-key warning appears?

Verify the server's identity and fingerprint through a trusted channel. Investigate the change before updating stored host-key information.

---

# 25. Viva Questions with Answers

## Basic Level

### 1. What does SSH stand for?

Secure Shell.

### 2. What is the default SSH port?

TCP port 22.

### 3. Which command connects to a remote server?

```bash
ssh username@server_ip
```

### 4. What does `sshd` do?

It is the OpenSSH server program that accepts and handles SSH connections.

### 5. What is a remote server?

A computer or system accessed over a network from another device.

### 6. Which command exits an SSH shell?

```bash
exit
```

### 7. Which command displays the SSH client version?

```bash
ssh -V
```

### 8. Which protocol does SSH use for its standard transport?

SSH commonly operates over TCP.

## Intermediate Level

### 9. What is public-key authentication?

It is an authentication method in which the client proves possession of a private key corresponding to a public key trusted by the server.

### 10. Which command generates an Ed25519 key pair?

```bash
ssh-keygen -t ed25519
```

### 11. What is the purpose of `authorized_keys`?

It lists public keys permitted to authenticate to a user's account.

### 12. What is the purpose of `known_hosts`?

It stores host identities used by the SSH client to verify server identity.

### 13. How do you transfer a file to a remote server?

```bash
scp file.txt username@server_ip:~/
```

### 14. How do you check listening ports?

```bash
sudo ss -tlnp
```

### 15. How do you validate SSH server configuration?

```bash
sudo sshd -t
```

## Advanced Level

### 16. What is SSH tunneling?

Forwarding traffic through an SSH connection to reach another network service.

### 17. Why should host-key verification not be disabled casually?

It helps prevent clients from trusting an impersonating server.

### 18. Why might public-key authentication fail?

The username, key, authorized-key entry, file permissions, account policy, or server configuration may be incorrect.

### 19. What is the purpose of `AllowUsers`?

It restricts SSH access to explicitly listed user accounts.

### 20. Why should an administrator keep an existing SSH session open during configuration changes?

It provides a recovery path if the new configuration prevents further connections.

### 21. Is changing the SSH port sufficient security?

No. Strong authentication, access restrictions, patching, key protection, and monitoring remain important.

### 22. What is the difference between authentication and authorization?

Authentication verifies identity. Authorization determines permitted actions.

### 23. What is the role of an SSH agent?

It provides access to loaded private-key credentials for authentication by client programs.

### 24. What is the difference between local and remote port forwarding?

Local forwarding exposes a local port that sends traffic to a destination reachable from the remote side. Remote forwarding exposes a remote-side port that forwards traffic toward a destination reachable from the client side.

### 25. What is the purpose of SSH logs?

They help administrators investigate service events, authentication attempts, and connection problems.

---

# 26. Practical Assessment

## Exercise 1: Basic Connection

**Task:** Connect to an authorized lab server.

**Expected command:**

```bash
ssh student@SERVER_IP
```

**Assessment criteria:**
- Correct username.
- Correct destination.
- Host identity verification.
- Successful authentication.

## Exercise 2: Key Generation

**Task:** Generate an Ed25519 key pair.

**Expected command:**

```bash
ssh-keygen -t ed25519
```

**Assessment criteria:**
- Correct key type.
- Correct understanding of public and private keys.
- Appropriate private-key protection.

## Exercise 3: File Transfer

**Task:** Upload a file using SCP.

**Expected command:**

```bash
scp lab.txt student@SERVER_IP:~/
```

**Assessment criteria:**
- Correct source path.
- Correct remote account.
- Successful transfer and verification.

## Exercise 4: Configuration Validation

**Task:** Validate the server configuration.

**Expected command:**

```bash
sudo sshd -t
```

**Assessment criteria:**
- Correct command.
- Correct interpretation of output.
- Understanding of safe change procedures.

## Exercise 5: Troubleshooting

**Task:** Diagnose a connection failure.

**Assessment criteria:**
- Interprets the error message.
- Checks network reachability and service status.
- Uses verbose output when useful.
- Reviews server logs.
- Applies an appropriate correction.

## Suggested Marking Scheme

| Component | Marks |
|---|---:|
| SSH concepts and definitions | 10 |
| Basic SSH commands | 15 |
| SSH key management | 20 |
| File transfer | 10 |
| Server configuration | 15 |
| Security best practices | 15 |
| Troubleshooting | 15 |
| **Total** | **100** |

---

# 27. SSH Command Cheat Sheet

| Task | Command |
|---|---|
| Connect to server | `ssh user@server_ip` |
| Connect using a custom port | `ssh -p 2222 user@server_ip` |
| Run remote command | `ssh user@server_ip "hostname"` |
| Debug SSH connection | `ssh -vvv user@server_ip` |
| Generate an Ed25519 key | `ssh-keygen -t ed25519` |
| Copy public key | `ssh-copy-id user@server_ip` |
| Use a specific private key | `ssh -i ~/.ssh/id_ed25519 user@server_ip` |
| Copy file to server | `scp file.txt user@server_ip:~/` |
| Copy file from server | `scp user@server_ip:~/file.txt ./` |
| Start SFTP | `sftp user@server_ip` |
| Check service on Ubuntu/Debian | `sudo systemctl status ssh` |
| Check service on RHEL-family systems | `sudo systemctl status sshd` |
| Validate configuration | `sudo sshd -t` |
| Show effective settings | `sudo sshd -T` |
| Check listening sockets | `sudo ss -tlnp` |
| View Ubuntu/Debian service logs | `sudo journalctl -u ssh` |
| View RHEL-family service logs | `sudo journalctl -u sshd` |
| Inspect SSH client version | `ssh -V` |
| Exit a remote shell | `exit` |

---

# 28. Suggested Teaching Schedule

| Session | Topic | Duration |
|---|---|---|
| 1 | SSH introduction, definitions, and architecture | 30 minutes |
| 2 | SSH installation and service management | 45 minutes |
| 3 | Basic SSH commands and remote execution | 45 minutes |
| 4 | Authentication and SSH key management | 60 minutes |
| 5 | SSH server configuration and user management | 60 minutes |
| 6 | SCP, SFTP, and SSH client configuration | 45 minutes |
| 7 | Security, firewalls, and log monitoring | 60 minutes |
| 8 | Tunneling, automation, and troubleshooting | 60 minutes |
| 9 | Practical lab and assessment | 90 minutes |

The durations are suggestions and can be adjusted according to students' experience.

---

# 29. Final Summary

SSH is a fundamental technology for secure remote administration.

A student who completes this guide should understand:

- The meaning and purpose of SSH.
- The client-server architecture.
- How SSH establishes protected connections.
- The difference between host keys and user authentication keys.
- How to install and manage OpenSSH Server.
- How to connect to remote systems.
- How to generate and protect SSH key pairs.
- How to configure SSH access.
- How to transfer files securely.
- How to use firewalls and security controls.
- How to inspect SSH logs.
- How to troubleshoot common failures.
- How to use SSH tunnels and authorized automation.

## Recommended Learning Sequence

Introduction → Definitions → Architecture → Installation → Commands → Authentication → Key Management → Configuration → File Transfer → Security → Monitoring → Troubleshooting → Practical Assessment

---

# 30. Lab Safety Guidelines

- Perform exercises only on systems you own or are authorized to administer.
- Never disclose private SSH keys.
- Verify server fingerprints before trusting new host keys.
- Do not disable host-key checking simply to bypass a warning.
- Back up SSH configuration before modifying it.
- Validate configuration syntax before applying changes.
- Keep an existing administrative session open during remote configuration changes.
- Test a second connection before closing the original session.
- Restrict SSH access to the intended users and networks.
- Avoid unnecessary administrative privileges.
- Document changes and restore temporary lab settings when finished.
- Never experiment with disruptive SSH settings on production systems without approval and a recovery plan.

