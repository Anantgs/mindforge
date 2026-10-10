### File System

```
Here's a breakdown of key directories and their purpose:

/ (Root Directory): The top-level directory, the starting point for all paths. 

/home: Contains the user's personal directories, e.g., /home/user1, /home/user2. 

/root: The home directory of the root user, also known as the superuser. 

/boot: Contains bootloader files and kernel images. 

/bin: Contains basic command-line tools and executables that are essential for the system. 

/sbin: Contains system commands that can only be executed by root or a user with root privileges. 

/dev: Contains special files that represent devices connected to the system, like printers or disks. 

/etc: Contains system-wide configuration files. 

/lib and /lib64: Contains shared libraries that applications use. 

/mnt: A temporary mount point for removable media, like CD-ROMs or USB drives. 

/tmp: Stores temporary files. 

/opt: Contains optional application software packages that are not part of the base system. 

/var: Stores variable data that changes frequently, like logs, caches, and mailboxes. 

/run: Stores information about the running system since the last boot. 

/proc: A pseudo-filesystem that provides information about running processes. 

/usr: Contains user-installed software, libraries, and documentation. 

/sys: A pseudo-filesystem that provides access to the system's hardware and kernel information. 
```


### how to check filesystem info 

```
root@DESKTOP-CL9FNGA:/#
root@DESKTOP-CL9FNGA:/# df -kh
Filesystem      Size  Used Avail Use% Mounted on
none            1.9G     0  1.9G   0% /usr/lib/modules/6.6.87.1-microsoft-standard-WSL2
none            1.9G  4.0K  1.9G   1% /mnt/wsl
drivers         119G  103G   17G  87% /usr/lib/wsl/drivers
/dev/sdd       1007G  8.3G  948G   1% /
none            1.9G   72K  1.9G   1% /mnt/wslg
none            1.9G     0  1.9G   0% /usr/lib/wsl/lib
rootfs          1.9G  2.7M  1.9G   1% /init
none            1.9G  912K  1.9G   1% /run
none            1.9G     0  1.9G   0% /run/lock
none            1.9G     0  1.9G   0% /run/shm
none            1.9G   76K  1.9G   1% /mnt/wslg/versions.txt
none            1.9G   76K  1.9G   1% /mnt/wslg/doc
C:\             119G  103G   17G  87% /mnt/c
D:\             340G   91G  249G  27% /mnt/d
E:\             592G   85G  507G  15% /mnt/e
snapfuse         13M   13M     0 100% /snap/kubectl/3593
snapfuse         13M   13M     0 100% /snap/kubectl/3581
snapfuse         64M   64M     0 100% /snap/core20/2571
snapfuse         45M   45M     0 100% /snap/snapd/23771
snapfuse         51M   51M     0 100% /snap/snapd/24505
snapfuse         64M   64M     0 100% /snap/core20/2582
tmpfs           1.9G   16K  1.9G   1% /run/user/0
overlay        1007G  8.3G  948G   1% /var/lib/docker/overlay2/de61d353ffca223cb005add00193b126792e74e5fb69a3e7bc1b655e8f749f8c/merged
root@DESKTOP-CL9FNGA:/#
```

### user management

```
root@DESKTOP-CL9FNGA:GIT#
root@DESKTOP-CL9FNGA:GIT# cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/run/ircd:/usr/sbin/nologin
_apt:x:42:65534::/nonexistent:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:998:998:systemd Network Management:/:/usr/sbin/nologin
systemd-timesync:x:996:996:systemd Time Synchronization:/:/usr/sbin/nologin
dhcpcd:x:100:65534:DHCP Client Daemon,,,:/usr/lib/dhcpcd:/bin/false
messagebus:x:101:101::/nonexistent:/usr/sbin/nologin
syslog:x:102:102::/nonexistent:/usr/sbin/nologin
systemd-resolve:x:991:991:systemd Resolver:/:/usr/sbin/nologin
uuidd:x:103:103::/run/uuidd:/usr/sbin/nologin
landscape:x:104:105::/var/lib/landscape:/usr/sbin/nologin
polkitd:x:990:990:User for polkitd:/:/usr/sbin/nologin
anantgsaraf123:x:1000:1000:,,,:/home/anantgsaraf123:/bin/bash
vault:x:999:988::/home/vault:/bin/false
consul:x:997:987::/home/consul:/bin/false
rajesh:x:1001:1001::/home/rajesh:/bin/sh
root@DESKTOP-CL9FNGA:GIT#

```

### To create file we have

```
vim
nano
vi
cat
touch
```

### To check current login user

```
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# who
root     pts/1        2025-06-12 16:52
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# whoami
root
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# uptime
 17:13:27 up 22 min,  1 user,  load average: 0.04, 0.11, 0.22
root@DESKTOP-CL9FNGA:tmp#
```

### copy file 

```

root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# cp -apv rejesh.txt test.txt
'rejesh.txt' -> 'test.txt'
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# ls -l
total 28
-rw-r--r-- 1 root root   52 Jun 12 17:11 rejesh.txt
drwx------ 2 root root 4096 Jun 12 16:51 snap-private-tmp
drwx------ 3 root root 4096 Jun 12 16:51 systemd-private-2ed2448d912246c9b6b540d5b00f6818-systemd-logind.service-dcsrwI
drwx------ 3 root root 4096 Jun 12 16:51 systemd-private-2ed2448d912246c9b6b540d5b00f6818-systemd-resolved.service-HzWkqb
drwx------ 3 root root 4096 Jun 12 16:51 systemd-private-2ed2448d912246c9b6b540d5b00f6818-systemd-timesyncd.service-Vi467P
drwx------ 3 root root 4096 Jun 12 16:51 systemd-private-2ed2448d912246c9b6b540d5b00f6818-wsl-pro.service-XrQow4
-rw-r--r-- 1 root root   52 Jun 12 17:11 test.txt
root@DESKTOP-CL9FNGA:tmp#

```

### To move file

```
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# mv test.txt  /root/
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# cd /root/
root@DESKTOP-CL9FNGA:~# ls -l
total 65980
drwxr-xr-x 3 root root     4096 Apr  8 03:13 GIT
drwxr-xr-x 3 root root     4096 Dec 13 19:24 aws
-rw-r--r-- 1 root root 67517785 Dec 15 17:33 awscliv2.zip
-rwx------ 1 root root    11903 Dec 14 17:09 get_helm.sh
drwxr-xr-x 3 root root     4096 Apr  8 03:12 kong-routing-stack
drwxr-xr-x 2 root root     4096 May 10 20:20 pem
drwx------ 3 root root     4096 Dec 27 06:01 snap
drwxr-xr-x 3 root root     4096 May 31 08:40 terraform
-rw-r--r-- 1 root root       52 Jun 12 17:11 test.txt
drwxr-xr-x 5 root root     4096 Apr  8 03:19 venv
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
```

### head and teil

```
root@DESKTOP-CL9FNGA:etc#
root@DESKTOP-CL9FNGA:etc# head /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
root@DESKTOP-CL9FNGA:etc#
root@DESKTOP-CL9FNGA:etc#
root@DESKTOP-CL9FNGA:etc#
root@DESKTOP-CL9FNGA:etc# tail /etc/passwd
messagebus:x:101:101::/nonexistent:/usr/sbin/nologin
syslog:x:102:102::/nonexistent:/usr/sbin/nologin
systemd-resolve:x:991:991:systemd Resolver:/:/usr/sbin/nologin
uuidd:x:103:103::/run/uuidd:/usr/sbin/nologin
landscape:x:104:105::/var/lib/landscape:/usr/sbin/nologin
polkitd:x:990:990:User for polkitd:/:/usr/sbin/nologin
anantgsaraf123:x:1000:1000:,,,:/home/anantgsaraf123:/bin/bash
vault:x:999:988::/home/vault:/bin/false
consul:x:997:987::/home/consul:/bin/false
rajesh:x:1001:1001::/home/rajesh:/bin/sh
root@DESKTOP-CL9FNGA:etc#
```

### grep command to check if word exist in a file or not

```
root@DESKTOP-CL9FNGA:etc#
root@DESKTOP-CL9FNGA:etc# grep -i rajesh /etc/passwd
rajesh:x:1001:1001::/home/rajesh:/bin/sh
root@DESKTOP-CL9FNGA:etc#
root@DESKTOP-CL9FNGA:etc#
root@DESKTOP-CL9FNGA:etc#
root@DESKTOP-CL9FNGA:etc# grep -i test /etc/passwd
root@DESKTOP-CL9FNGA:etc#
```

### man command

```
man ls
```

```
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# ls -k
GIT  aws  awscliv2.zip  get_helm.sh  kong-routing-stack  pem  snap  terraform  test.txt  venv
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# ls -lk
total 65980
drwxr-xr-x 3 root root     4096 Apr  8 03:13 GIT
drwxr-xr-x 3 root root     4096 Dec 13 19:24 aws
-rw-r--r-- 1 root root 67517785 Dec 15 17:33 awscliv2.zip
-rwx------ 1 root root    11903 Dec 14 17:09 get_helm.sh
drwxr-xr-x 3 root root     4096 Apr  8 03:12 kong-routing-stack
drwxr-xr-x 2 root root     4096 May 10 20:20 pem
drwx------ 3 root root     4096 Dec 27 06:01 snap
drwxr-xr-x 3 root root     4096 May 31 08:40 terraform
-rw-r--r-- 1 root root       52 Jun 12 17:11 test.txt
drwxr-xr-x 5 root root     4096 Apr  8 03:19 venv
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# ls -lh
total 65M
drwxr-xr-x 3 root root 4.0K Apr  8 03:13 GIT
drwxr-xr-x 3 root root 4.0K Dec 13 19:24 aws
-rw-r--r-- 1 root root  65M Dec 15 17:33 awscliv2.zip
-rwx------ 1 root root  12K Dec 14 17:09 get_helm.sh
drwxr-xr-x 3 root root 4.0K Apr  8 03:12 kong-routing-stack
drwxr-xr-x 2 root root 4.0K May 10 20:20 pem
drwx------ 3 root root 4.0K Dec 27 06:01 snap
drwxr-xr-x 3 root root 4.0K May 31 08:40 terraform
-rw-r--r-- 1 root root   52 Jun 12 17:11 test.txt
drwxr-xr-x 5 root root 4.0K Apr  8 03:19 venv
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
```

### to check version of linux

```
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# hostname
DESKTOP-CL9FNGA
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# uname
Linux
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# uname -n
DESKTOP-CL9FNGA
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
```

### df command to  check disk space

```
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# df -kh
Filesystem      Size  Used Avail Use% Mounted on
none            1.9G     0  1.9G   0% /usr/lib/modules/6.6.87.1-microsoft-standard-WSL2
none            1.9G  4.0K  1.9G   1% /mnt/wsl
drivers         119G  103G   16G  87% /usr/lib/wsl/drivers
/dev/sdd       1007G  8.3G  948G   1% /
none            1.9G   76K  1.9G   1% /mnt/wslg
none            1.9G     0  1.9G   0% /usr/lib/wsl/lib
rootfs          1.9G  2.7M  1.9G   1% /init
none            1.9G  912K  1.9G   1% /run
none            1.9G     0  1.9G   0% /run/lock
none            1.9G     0  1.9G   0% /run/shm
none            1.9G   76K  1.9G   1% /mnt/wslg/versions.txt
none            1.9G   76K  1.9G   1% /mnt/wslg/doc
C:\             119G  103G   16G  87% /mnt/c
D:\             340G   91G  249G  27% /mnt/d
E:\             592G   85G  507G  15% /mnt/e
snapfuse         13M   13M     0 100% /snap/kubectl/3593
snapfuse         13M   13M     0 100% /snap/kubectl/3581
snapfuse         64M   64M     0 100% /snap/core20/2571
snapfuse         45M   45M     0 100% /snap/snapd/23771
snapfuse         51M   51M     0 100% /snap/snapd/24505
snapfuse         64M   64M     0 100% /snap/core20/2582
tmpfs           1.9G   16K  1.9G   1% /run/user/0
overlay        1007G  8.3G  948G   1% /var/lib/docker/overlay2/de61d353ffca223cb005add00193b126792e74e5fb69a3e7bc1b655e8f749f8c/merged
root@DESKTOP-CL9FNGA:~#
```

```
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# find /usr -type f -name whoami
/usr/lib/byobu/whoami
/usr/bin/whoami
root@DESKTOP-CL9FNGA:~#
```

```
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# find /var -type f -size 10M
/var/cache/apt/archives/docker-ce-rootless-extras_5%3a27.3.1-1~ubuntu.24.04~noble_amd64.deb
/var/lib/docker/overlay2/57dbadaf2dac9b8d9b14fd823438b5472c9eb11e7ef3cc0a83a237db68a59dff/diff/usr/share/elasticsearch/jdk/jmods/jdk.localedata.jmod
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
```

### To check binary location

```
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# which who
/usr/bin/who
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# which whoami
/usr/bin/whoami
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# which top
/usr/bin/top
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
```

### how to check ipaddress

```
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# ifconfig
docker0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        inet6 fe80::42:91ff:fe6f:7703  prefixlen 64  scopeid 0x20<link>
        ether 02:42:91:6f:77:03  txqueuelen 0  (Ethernet)
        RX packets 384  bytes 87059 (87.0 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 419  bytes 91268 (91.2 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.28.76.177  netmask 255.255.240.0  broadcast 172.28.79.255
        inet6 fe80::215:5dff:fec2:7225  prefixlen 64  scopeid 0x20<link>
        ether 00:15:5d:c2:72:25  txqueuelen 1000  (Ethernet)
        RX packets 1017  bytes 184934 (184.9 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 569  bytes 114190 (114.1 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

vethdede826: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::e0c1:20ff:feb6:18fa  prefixlen 64  scopeid 0x20<link>
        ether e2:c1:20:b6:18:fa  txqueuelen 0  (Ethernet)
        RX packets 384  bytes 92435 (92.4 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 434  bytes 92414 (92.4 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:15:5d:c2:72:25 brd ff:ff:ff:ff:ff:ff
    inet 172.28.76.177/20 brd 172.28.79.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::215:5dff:fec2:7225/64 scope link
       valid_lft forever preferred_lft forever
3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:91:6f:77:03 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:91ff:fe6f:7703/64 scope link
       valid_lft forever preferred_lft forever
5: vethdede826@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default
    link/ether e2:c1:20:b6:18:fa brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::e0c1:20ff:feb6:18fa/64 scope link
       valid_lft forever preferred_lft forever
root@DESKTOP-CL9FNGA:~#
```

### du command is used to check disk usage of files and directories

```
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# cd /var/
root@DESKTOP-CL9FNGA:var# du -sm * |sort -nr |head
2790    lib
433     log
309     cache
2       backups
1       tmp
1       spool
1       snap
1       opt
1       mail
1       local
root@DESKTOP-CL9FNGA:var#
root@DESKTOP-CL9FNGA:var# cd lib/
root@DESKTOP-CL9FNGA:lib# du -sm * |sort -nr |head
2137    docker
429     snapd
181     apt
35      dpkg
6       ubuntu-advantage
4       command-not-found
1       xml-core
1       vim
1       update-notifier
1       update-manager
root@DESKTOP-CL9FNGA:lib# cd docker/
root@DESKTOP-CL9FNGA:docker#
root@DESKTOP-CL9FNGA:docker#
root@DESKTOP-CL9FNGA:docker# du -sm * |sort -nr |head
2128    overlay2
4       image
3       containers
2       buildkit
1       volumes
1       tmp
1       swarm
1       runtimes
1       plugins
1       network
root@DESKTOP-CL9FNGA:docker# cd overlay2/
root@DESKTOP-CL9FNGA:overlay2# du -sm * |sort -nr |head
505     57dbadaf2dac9b8d9b14fd823438b5472c9eb11e7ef3cc0a83a237db68a59dff
330     de61d353ffca223cb005add00193b126792e74e5fb69a3e7bc1b655e8f749f8c
215     65ec7ded57f06dcb463e4b38faae2175df59ea9c443e67d66bb1ceb3889b7ec7
163     4a03a69429a1c12a8afadd99d87b46d79fc9838295a523cecb88b2dfc6c2bab0
156     d6cc22a53ca77197da0679027a45b96839771e6030fe1a87ff6c6b4986ea8b7e
107     0f17abe53ffaa85d66ccfdbd4a432965d32740ed1c541051171b2b0f62dffc75
84      51b08ef665c90c7297d2d91ac5294d0b36c7911412ddfc65cceee5e276b0ac12
84      282c1445abcc4512e047b764e9050ba6e32905eb41fa4d8aa47ebfa52b7a9298
82      b094af4b0ca0c94bf60c48a825a759a020dbe8c86c686c0849ad592a0349bdf7
71      fa1553bbc9160c8fc69191521db53f07cfd81c37fb03cfe76d8a745cf6917057
root@DESKTOP-CL9FNGA:overlay2#
```

### ls command is used to list files and directories

```
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# ls -l
total 65980
drwxr-xr-x 3 root root     4096 Apr  8 03:13 GIT
drwxr-xr-x 3 root root     4096 Dec 13 19:24 aws
-rw-r--r-- 1 root root 67517785 Dec 15 17:33 awscliv2.zip
-rwx------ 1 root root    11903 Dec 14 17:09 get_helm.sh
drwxr-xr-x 3 root root     4096 Apr  8 03:12 kong-routing-stack
drwxr-xr-x 2 root root     4096 May 10 20:20 pem
drwx------ 3 root root     4096 Dec 27 06:01 snap
drwxr-xr-x 3 root root     4096 May 31 08:40 terraform
-rw-r--r-- 1 root root       52 Jun 12 17:11 test.txt
drwxr-xr-x 5 root root     4096 Apr  8 03:19 venv
root@DESKTOP-CL9FNGA:~#
```

### how to change the permission of the file

```
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# chmod 777 test.txt
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# ls -l
total 65980
drwxr-xr-x 3 root root     4096 Apr  8 03:13 GIT
drwxr-xr-x 3 root root     4096 Dec 13 19:24 aws
-rw-r--r-- 1 root root 67517785 Dec 15 17:33 awscliv2.zip
-rwx------ 1 root root    11903 Dec 14 17:09 get_helm.sh
drwxr-xr-x 3 root root     4096 Apr  8 03:12 kong-routing-stack
drwxr-xr-x 2 root root     4096 May 10 20:20 pem
drwx------ 3 root root     4096 Dec 27 06:01 snap
drwxr-xr-x 3 root root     4096 May 31 08:40 terraform
-rwxrwxrwx 1 root root       52 Jun 12 17:11 test.txt
drwxr-xr-x 5 root root     4096 Apr  8 03:19 venv
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# chmod 600 test.txt
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# ls -l
total 65980
drwxr-xr-x 3 root root     4096 Apr  8 03:13 GIT
drwxr-xr-x 3 root root     4096 Dec 13 19:24 aws
-rw-r--r-- 1 root root 67517785 Dec 15 17:33 awscliv2.zip
-rwx------ 1 root root    11903 Dec 14 17:09 get_helm.sh
drwxr-xr-x 3 root root     4096 Apr  8 03:12 kong-routing-stack
drwxr-xr-x 2 root root     4096 May 10 20:20 pem
drwx------ 3 root root     4096 Dec 27 06:01 snap
drwxr-xr-x 3 root root     4096 May 31 08:40 terraform
-rw------- 1 root root       52 Jun 12 17:11 test.txt
drwxr-xr-x 5 root root     4096 Apr  8 03:19 venv
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~#
```

### what are special permissions and how to add them

