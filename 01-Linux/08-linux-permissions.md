### As root run following commands

```
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# useradd -m -s /bin/bash prashant
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# ls -l
total 40
-rw-r--r-- 1 root           root              0 Oct 17 03:39 a
-rw-r--r-- 1 root           root              0 Oct 17 03:39 b
-rw-r--r-- 1 root           root              0 Oct 17 03:39 c
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 clr-debug-pipe-588-5970-in
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 clr-debug-pipe-588-5970-out
srwxrwxrwx 1 root           root              0 Oct 17 03:00 dbus-HkDQ0gysN5
srw------- 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 dotnet-diagnostic-588-5970-socket
-rw-r--r-- 1 root           root             58 Oct 17 03:15 error.txt
-rw-r--r-- 1 root           root            174 Oct 17 03:18 output.txt
drwx------ 2 root           root           4096 Oct 17 02:59 snap-private-tmp
drwxr-xr-x 2 root           root           4096 Oct 17 03:35 sushant
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-logind.service-wE57zy
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-resolved.service-77DiQ2
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-timesyncd.service-u72qur
drwxr-xr-x 2 root           root           4096 Oct 17 03:32 test
-rw-r--r-- 1 root           root             19 Oct 17 03:43 test.sh
-rw-r--r-- 1 root           root             15 Oct 17 03:09 test.txt
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# ls -lrt
total 40
drwx------ 2 root           root           4096 Oct 17 02:59 snap-private-tmp
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-resolved.service-77DiQ2
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-timesyncd.service-u72qur
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-logind.service-wE57zy
srw------- 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 dotnet-diagnostic-588-5970-socket
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 clr-debug-pipe-588-5970-out
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 clr-debug-pipe-588-5970-in
srwxrwxrwx 1 root           root              0 Oct 17 03:00 dbus-HkDQ0gysN5
-rw-r--r-- 1 root           root             15 Oct 17 03:09 test.txt
-rw-r--r-- 1 root           root             58 Oct 17 03:15 error.txt
-rw-r--r-- 1 root           root            174 Oct 17 03:18 output.txt
drwxr-xr-x 2 root           root           4096 Oct 17 03:32 test
drwxr-xr-x 2 root           root           4096 Oct 17 03:35 sushant
-rw-r--r-- 1 root           root              0 Oct 17 03:39 a
-rw-r--r-- 1 root           root              0 Oct 17 03:39 b
-rw-r--r-- 1 root           root              0 Oct 17 03:39 c
-rw-r--r-- 1 root           root             19 Oct 17 03:43 test.sh
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# chmod 774 test
test/     test.sh   test.txt
root@DESKTOP-CL9FNGA:tmp# chmod 774 test
test/     test.sh   test.txt
root@DESKTOP-CL9FNGA:tmp# chmod 774 test.
test.sh   test.txt
root@DESKTOP-CL9FNGA:tmp# chmod 774 test.sh
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# ls -l
total 40
-rw-r--r-- 1 root           root              0 Oct 17 03:39 a
-rw-r--r-- 1 root           root              0 Oct 17 03:39 b
-rw-r--r-- 1 root           root              0 Oct 17 03:39 c
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 clr-debug-pipe-588-5970-in
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 clr-debug-pipe-588-5970-out
srwxrwxrwx 1 root           root              0 Oct 17 03:00 dbus-HkDQ0gysN5
srw------- 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 dotnet-diagnostic-588-5970-socket
-rw-r--r-- 1 root           root             58 Oct 17 03:15 error.txt
-rw-r--r-- 1 root           root            174 Oct 17 03:18 output.txt
drwx------ 2 root           root           4096 Oct 17 02:59 snap-private-tmp
drwxr-xr-x 2 root           root           4096 Oct 17 03:35 sushant
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-logind.service-wE57zy
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-resolved.service-77DiQ2
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-timesyncd.service-u72qur
drwxr-xr-x 2 root           root           4096 Oct 17 03:32 test
-rwxrwxr-- 1 root           root             19 Oct 17 03:43 test.sh
-rw-r--r-- 1 root           root             15 Oct 17 03:09 test.txt
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# chmod 775 test.sh
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# cat test.
test.sh   test.txt
root@DESKTOP-CL9FNGA:tmp# cat test.sh
#/bin/bash

ls -l

root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
```

### As prashant user run the following commands

```
prashant@DESKTOP-CL9FNGA:~$
prashant@DESKTOP-CL9FNGA:~$
prashant@DESKTOP-CL9FNGA:~$ cd /tmp/
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$ ls -l
total 40
-rw-r--r-- 1 root           root              0 Oct 17 03:39 a
-rw-r--r-- 1 root           root              0 Oct 17 03:39 b
-rw-r--r-- 1 root           root              0 Oct 17 03:39 c
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 clr-debug-pipe-588-5970-in
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 clr-debug-pipe-588-5970-out
srwxrwxrwx 1 root           root              0 Oct 17 03:00 dbus-HkDQ0gysN5
srw------- 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 dotnet-diagnostic-588-5970-socket
-rw-r--r-- 1 root           root             58 Oct 17 03:15 error.txt
-rw-r--r-- 1 root           root            174 Oct 17 03:18 output.txt
drwx------ 2 root           root           4096 Oct 17 02:59 snap-private-tmp
drwxr-xr-x 2 root           root           4096 Oct 17 03:35 sushant
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-logind.service-wE57zy
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-resolved.service-77DiQ2
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-timesyncd.service-u72qur
drwxr-xr-x 2 root           root           4096 Oct 17 03:32 test
-rw-r--r-- 1 root           root             19 Oct 17 03:43 test.sh
-rw-r--r-- 1 root           root             15 Oct 17 03:09 test.txt
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$ ./test.sh
-bash: ./test.sh: Permission denied
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$ ./test.sh
-bash: ./test.sh: Permission denied
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$ ./test.sh
total 40
-rw-r--r-- 1 root           root              0 Oct 17 03:39 a
-rw-r--r-- 1 root           root              0 Oct 17 03:39 b
-rw-r--r-- 1 root           root              0 Oct 17 03:39 c
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 clr-debug-pipe-588-5970-in
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 clr-debug-pipe-588-5970-out
srwxrwxrwx 1 root           root              0 Oct 17 03:00 dbus-HkDQ0gysN5
srw------- 1 anantgsaraf123 anantgsaraf123    0 Oct 17 03:00 dotnet-diagnostic-588-5970-socket
-rw-r--r-- 1 root           root             58 Oct 17 03:15 error.txt
-rw-r--r-- 1 root           root            174 Oct 17 03:18 output.txt
drwx------ 2 root           root           4096 Oct 17 02:59 snap-private-tmp
drwxr-xr-x 2 root           root           4096 Oct 17 03:35 sushant
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-logind.service-wE57zy
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-resolved.service-77DiQ2
drwx------ 3 root           root           4096 Oct 17 02:59 systemd-private-83a6632ce60e49bfa0af5d9a17deaef0-systemd-timesyncd.service-u72qur
drwxr-xr-x 2 root           root           4096 Oct 17 03:32 test
-rwxrwxr-x 1 root           root             19 Oct 17 03:43 test.sh
-rw-r--r-- 1 root           root             15 Oct 17 03:09 test.txt
prashant@DESKTOP-CL9FNGA:/tmp$
prashant@DESKTOP-CL9FNGA:/tmp$
```
 
### Run this as root

```
root@DESKTOP-CL9FNGA:/#
root@DESKTOP-CL9FNGA:/# cd /app-dir/
root@DESKTOP-CL9FNGA:app-dir#
root@DESKTOP-CL9FNGA:app-dir#
root@DESKTOP-CL9FNGA:app-dir#
root@DESKTOP-CL9FNGA:app-dir# touch a
root@DESKTOP-CL9FNGA:app-dir# touch b
root@DESKTOP-CL9FNGA:app-dir# touch c
root@DESKTOP-CL9FNGA:app-dir#
root@DESKTOP-CL9FNGA:app-dir#
root@DESKTOP-CL9FNGA:app-dir#
root@DESKTOP-CL9FNGA:app-dir# ls -l
total 0
-rw-r--r-- 1 root root 0 Oct 17 03:52 a
-rw-r--r-- 1 root root 0 Oct 17 03:52 b
-rw-r--r-- 1 root root 0 Oct 17 03:52 c
root@DESKTOP-CL9FNGA:app-dir#
root@DESKTOP-CL9FNGA:app-dir#
root@DESKTOP-CL9FNGA:app-dir#
root@DESKTOP-CL9FNGA:app-dir# ls -l
total 0
-rw-r--r-- 1 root root 0 Oct 17 03:52 a
-rw-r--r-- 1 root root 0 Oct 17 03:52 b
-rw-r--r-- 1 root root 0 Oct 17 03:52 c
root@DESKTOP-CL9FNGA:app-dir#
root@DESKTOP-CL9FNGA:app-dir#
root@DESKTOP-CL9FNGA:app-dir#
root@DESKTOP-CL9FNGA:app-dir# cd ..
root@DESKTOP-CL9FNGA:/#
root@DESKTOP-CL9FNGA:/# ls -l
total 3496
drwxr-xr-x   3 root root    4096 May 20  2025 app
drwxr-xr-x   2 root root    4096 Oct 17 03:52 app-dir
drwxr-xr-x   2 root root    4096 Aug 16  2025 backup
lrwxrwxrwx   1 root root       7 Apr 22  2024 bin -> usr/bin
drwxr-xr-x   2 root root    4096 Feb 26  2024 bin.usr-is-merged
drwxr-xr-x   2 root root    4096 Apr 22  2024 boot
drwxr-xr-x  15 root root    3820 Oct 17 02:59 dev
drwxr-xr-x 103 root root    4096 Oct 17 03:44 etc
drwxr-xr-x   8 root root    4096 Oct 17 03:44 home
-rwxr-xr-x   1 root root 3476152 Oct  7 21:21 init
lrwxrwxrwx   1 root root       7 Apr 22  2024 lib -> usr/lib
drwxr-xr-x   2 root root    4096 Apr  8  2024 lib.usr-is-merged
lrwxrwxrwx   1 root root       9 Apr 22  2024 lib64 -> usr/lib64
drwx------   2 root root   16384 Nov 23  2024 lost+found
drwxr-xr-x   2 root root    4096 Sep 27  2024 media
drwxr-xr-x   8 root root    4096 May  8  2025 mnt
drwxr-xr-x   6 root root    4096 Apr 22  2025 opt
dr-xr-xr-x 195 root root       0 Oct 17 02:58 proc
drwx------  41 root root    4096 Oct 17 03:43 root
drwxr-xr-x  22 root root     700 Oct 17 03:19 run
lrwxrwxrwx   1 root root       8 Apr 22  2024 sbin -> usr/sbin
drwxr-xr-x   2 root root    4096 Mar 31  2024 sbin.usr-is-merged
drwxr-xr-x  10 root root    4096 Apr 24 16:39 snap
drwxr-xr-x   3 root root    4096 May  6  2025 srv
dr-xr-xr-x  12 root root       0 Oct 17 03:50 sys
drwxr-xr-x   3 root root    4096 Aug 16  2025 test
drwxrwxrwt   9 root root   12288 Oct 17 03:43 tmp
drwxr-xr-x  12 root root    4096 Sep 27  2024 usr
drwxr-xr-x  13 root root    4096 Nov 23  2024 var
root@DESKTOP-CL9FNGA:/#
root@DESKTOP-CL9FNGA:/#
root@DESKTOP-CL9FNGA:/#
root@DESKTOP-CL9FNGA:/# chmod 754 /app
app/     app-dir/
root@DESKTOP-CL9FNGA:/# chmod 754 /app
app/     app-dir/
root@DESKTOP-CL9FNGA:/# chmod 754 /app-dir/
root@DESKTOP-CL9FNGA:/#
root@DESKTOP-CL9FNGA:/#
root@DESKTOP-CL9FNGA:/#
root@DESKTOP-CL9FNGA:/# chmod 755 /app-dir/
root@DESKTOP-CL9FNGA:/#
root@DESKTOP-CL9FNGA:/#
root@DESKTOP-CL9FNGA:/#
```

### Run this as user 

```
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$ mkdir /app-dir
mkdir: cannot create directory ‘/app-dir’: Permission denied
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$ cd /app
app/     app-dir/
prashant@DESKTOP-CL9FNGA:/$ cd /app
app/     app-dir/
prashant@DESKTOP-CL9FNGA:/$ cd /app-dir/
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$ ls -l
total 0
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$ ls -l
total 0
-rw-r--r-- 1 root root 0 Oct 17 03:52 a
-rw-r--r-- 1 root root 0 Oct 17 03:52 b
-rw-r--r-- 1 root root 0 Oct 17 03:52 c
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$ ls -l
ls: cannot open directory '.': Permission denied
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$
prashant@DESKTOP-CL9FNGA:/app-dir$ cd ..
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$ ls -lrt
total 3496
drwxr-xr-x   2 root root    4096 Feb 26  2024 bin.usr-is-merged
drwxr-xr-x   2 root root    4096 Mar 31  2024 sbin.usr-is-merged
drwxr-xr-x   2 root root    4096 Apr  8  2024 lib.usr-is-merged
lrwxrwxrwx   1 root root       8 Apr 22  2024 sbin -> usr/sbin
lrwxrwxrwx   1 root root       9 Apr 22  2024 lib64 -> usr/lib64
lrwxrwxrwx   1 root root       7 Apr 22  2024 lib -> usr/lib
drwxr-xr-x   2 root root    4096 Apr 22  2024 boot
lrwxrwxrwx   1 root root       7 Apr 22  2024 bin -> usr/bin
drwxr-xr-x  12 root root    4096 Sep 27  2024 usr
drwxr-xr-x   2 root root    4096 Sep 27  2024 media
drwx------   2 root root   16384 Nov 23  2024 lost+found
drwxr-xr-x  13 root root    4096 Nov 23  2024 var
drwxr-xr-x   6 root root    4096 Apr 22  2025 opt
drwxr-xr-x   3 root root    4096 May  6  2025 srv
drwxr-xr-x   8 root root    4096 May  8  2025 mnt
drwxr-xr-x   3 root root    4096 May 20  2025 app
drwxr-xr-x   3 root root    4096 Aug 16  2025 test
drwxr-xr-x   2 root root    4096 Aug 16  2025 backup
drwxr-xr-x  10 root root    4096 Apr 24 16:39 snap
-rwxr-xr-x   1 root root 3476152 Oct  7 21:21 init
dr-xr-xr-x 196 root root       0 Oct 17 02:58 proc
drwxr-xr-x  15 root root    3820 Oct 17 02:59 dev
drwxr-xr-x  22 root root     700 Oct 17 03:19 run
drwx------  41 root root    4096 Oct 17 03:43 root
drwxrwxrwt   9 root root   12288 Oct 17 03:43 tmp
drwxr-xr-x   8 root root    4096 Oct 17 03:44 home
drwxr-xr-x 103 root root    4096 Oct 17 03:44 etc
dr-xr-xr-x  12 root root       0 Oct 17 03:50 sys
drwxr-xr--   2 root root    4096 Oct 17 03:52 app-dir
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$ ls -l app
app/     app-dir/
prashant@DESKTOP-CL9FNGA:/$ ls -l app-dir/
ls: cannot access 'app-dir/a': Permission denied
ls: cannot access 'app-dir/b': Permission denied
ls: cannot access 'app-dir/c': Permission denied
total 0
-????????? ? ? ? ?            ? a
-????????? ? ? ? ?            ? b
-????????? ? ? ? ?            ? c
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$ ls -l app-dir/
total 0
-rw-r--r-- 1 root root 0 Oct 17 03:52 a
-rw-r--r-- 1 root root 0 Oct 17 03:52 b
-rw-r--r-- 1 root root 0 Oct 17 03:52 c
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$
prashant@DESKTOP-CL9FNGA:/$

```