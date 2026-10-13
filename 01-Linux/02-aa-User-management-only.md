* Creation with specific options (e.g., assigning to an existing group, setting shell type, adding comments, creating a home directory in a specific location):

    ▪ Syntax: useradd -G <existing_group> -s <shell_type> -c <comment> -m -d <directory_location> <username>

    ▪ Example: useradd -G qa -s /bin/bash -c "Part of QA Team" -m -d /home/victor victor

* To identify if user is present or not

    ▪ Syntax: id <username>

    ▪ Example: id victor

* To change the primary group of a user

    ▪ Syntax: usermod -g <new_group> <username>

    ▪ Example: usermod -g dev victor

* To add a user to additional groups

    ▪ Syntax: usermod -aG <additional_group> <username>

    ▪ Example: usermod -aG dev victor

* To change the login shell of a user

    ▪ Syntax: usermod -s <new_shell> <username>

    ▪ Example: usermod -s /bin/zsh victor

* To change the user's home directory

    ▪ Syntax: usermod -d <new_directory> <username>

    ▪ Example: usermod -d /home/new_victor victor

* To change the user's password

    ▪ Syntax: passwd <username>

    ▪ Example: passwd victor

* To delete a user

    ▪ Syntax: userdel <username>

    ▪ Example: userdel victor

* To delete a user along with their home directory

    ▪ Syntax: userdel -r <username>

    ▪ Example: userdel -r victor

* Files used in user management

    ▪ /etc/passwd: Contains user account information, including username, password (hashed), user ID (UID), group ID (GID), home directory, and login shell.

    ▪ /etc/shadow: Contains password information for user accounts, including hashed passwords, password expiration dates, and other security-related information.

    ▪ /etc/group: Contains group information, including group name, group ID (GID), and list of members.

    ▪ /etc/gshadow: Contains password information for groups, including hashed passwords and group administrators.

    ▪ /etc/sudoers: Contains information about users and groups who have sudo privileges.

    ▪ /var/log/auth.log: A log file that records authentication-related events, such as successful and unsuccessful login attempts, password changes, and account lockouts.

    ▪ /etc/chage: Contains information about user account aging, such as password expiration dates and account lockout policies.

    ▪ /etc/login.defs: Contains system-wide settings for user account management, such as password policy and account 
    lockout policies.

    ▪ /etc/skel contains user skeleton

* Add user to developer group and give some accesses to thet user to commands that are belong to developer group.


