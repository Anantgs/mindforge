## Run all the following commands as root

### Install docker on system (check on internet)

### Create a group and users

```
groupadd devops
```

### check in /etc/passwd you will see this group

### now create the users

```
useradd -m vishal -s /bin/bash
useradd -m sushant -s /bin/bash
```

### Add users to group

```
usermod -aG devops vishal
usermod -aG devops sushant
```

### Now give the password to users with passwd command

```
passwd sushant
passwd vishal
```
### now login to sushant or vishal user from other terminal , try following commands

```
sudo systemctl status docker
sudo systemctl stop docker
sudo systemctl start docker
```

### now from the terminal where we are logged in as root edit the sudoers file as root

```
sudo EDITOR=vim visudo
```

```
# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL
%devops ALL=(ALL)  NOPASSWD: ALL
# Allow members of group sudo to execute any command
```

### Now devops group has been given all the permissions . now open another terminal and again login as sushant ot vishal and check if the commands that were not working before are working now or not.

```
sudo systemctl status docker
sudo systemctl stop docker
sudo systemctl start docker
```