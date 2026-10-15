

```
tar -cfz archive.tar.gz folder/	

zip -r archive.zip folder/	

gzip file.txt

unzip archive.zip	

tar -xzf archive.tar.gz	
```


### COMMANDS

```
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# cd /tmp/
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# cp -apv /etc/ssh .
'/etc/ssh' -> './ssh'
'/etc/ssh/ssh_config.d' -> './ssh/ssh_config.d'
'/etc/ssh/ssh_config' -> './ssh/ssh_config'
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# ls -lrt
total 24
drwxr-xr-x 3 root           root           4096 Oct  9 06:41 ssh
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-logind.service-ivhnzh
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-wsl-pro.service-gBrEbL
drwx------ 2 root           root           4096 Oct 15 03:42 snap-private-tmp
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-resolved.service-rYzZ5N
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-timesyncd.service-CIWdbU
srw------- 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 dotnet-diagnostic-552-4488-socket
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 clr-debug-pipe-552-4488-out
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 clr-debug-pipe-552-4488-in
srwxrwxrwx 1 root           root              0 Oct 15 03:42 dbus-udIKCB0OAP
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# zip -r ssh.zip ssh
  adding: ssh/ (stored 0%)
  adding: ssh/ssh_config (deflated 52%)
  adding: ssh/ssh_config.d/ (stored 0%)
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# ls -l
total 24
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 clr-debug-pipe-552-4488-in
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 clr-debug-pipe-552-4488-out
srwxrwxrwx 1 root           root              0 Oct 15 03:42 dbus-udIKCB0OAP
srw------- 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 dotnet-diagnostic-552-4488-socket
drwx------ 2 root           root           4096 Oct 15 03:42 snap-private-tmp
drwxr-xr-x 3 root           root           4096 Oct  9 06:41 ssh
-rw-r--r-- 1 root           root           1268 Oct 15 03:55 ssh.zip
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-logind.service-ivhnzh
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-resolved.service-rYzZ5N
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-timesyncd.service-CIWdbU
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# rm -rf ssh
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# ls -l
total 20
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 clr-debug-pipe-552-4488-in
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 clr-debug-pipe-552-4488-out
srwxrwxrwx 1 root           root              0 Oct 15 03:42 dbus-udIKCB0OAP
srw------- 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 dotnet-diagnostic-552-4488-socket
drwx------ 2 root           root           4096 Oct 15 03:42 snap-private-tmp
-rw-r--r-- 1 root           root           1268 Oct 15 03:55 ssh.zip
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-logind.service-ivhnzh
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-resolved.service-rYzZ5N
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-timesyncd.service-CIWdbU
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# unzip ssh.zip
Archive:  ssh.zip
   creating: ssh/
  inflating: ssh/ssh_config
   creating: ssh/ssh_config.d/
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# ls -l
total 24
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 clr-debug-pipe-552-4488-in
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 clr-debug-pipe-552-4488-out
srwxrwxrwx 1 root           root              0 Oct 15 03:42 dbus-udIKCB0OAP
srw------- 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 dotnet-diagnostic-552-4488-socket
drwx------ 2 root           root           4096 Oct 15 03:42 snap-private-tmp
drwxr-xr-x 3 root           root           4096 Oct  9 06:41 ssh
-rw-r--r-- 1 root           root           1268 Oct 15 03:55 ssh.zip
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-logind.service-ivhnzh
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-resolved.service-rYzZ5N
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-timesyncd.service-CIWdbU
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# ls -l ssh
total 8
-rw-r--r-- 1 root root 1649 Aug  9  2024 ssh_config
drwxr-xr-x 2 root root 4096 Aug  9  2024 ssh_config.d
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# cd ssh/
root@DESKTOP-CL9FNGA:ssh#
root@DESKTOP-CL9FNGA:ssh#
root@DESKTOP-CL9FNGA:ssh# ls -l
total 8
-rw-r--r-- 1 root root 1649 Aug  9  2024 ssh_config
drwxr-xr-x 2 root root 4096 Aug  9  2024 ssh_config.d
root@DESKTOP-CL9FNGA:ssh#
root@DESKTOP-CL9FNGA:ssh#
root@DESKTOP-CL9FNGA:ssh#
root@DESKTOP-CL9FNGA:ssh#
root@DESKTOP-CL9FNGA:ssh# gzip ssh_config
root@DESKTOP-CL9FNGA:ssh#
root@DESKTOP-CL9FNGA:ssh#
root@DESKTOP-CL9FNGA:ssh# ls -l
total 8
drwxr-xr-x 2 root root 4096 Aug  9  2024 ssh_config.d
-rw-r--r-- 1 root root  821 Aug  9  2024 ssh_config.gz
root@DESKTOP-CL9FNGA:ssh#
root@DESKTOP-CL9FNGA:ssh#
root@DESKTOP-CL9FNGA:ssh#
root@DESKTOP-CL9FNGA:ssh# gunzip ssh_config.gz
root@DESKTOP-CL9FNGA:ssh#
root@DESKTOP-CL9FNGA:ssh#
root@DESKTOP-CL9FNGA:ssh# ls -l
total 8
-rw-r--r-- 1 root root 1649 Aug  9  2024 ssh_config
drwxr-xr-x 2 root root 4096 Aug  9  2024 ssh_config.d
root@DESKTOP-CL9FNGA:ssh#


root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# tar -cvzf ssh.tar.gz ssh
ssh/
ssh/ssh_config
ssh/ssh_config.d/
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# ls -l
total 28
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 clr-debug-pipe-552-4488-in
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 clr-debug-pipe-552-4488-out
srwxrwxrwx 1 root           root              0 Oct 15 03:42 dbus-udIKCB0OAP
srw------- 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 dotnet-diagnostic-552-4488-socket
drwx------ 2 root           root           4096 Oct 15 03:42 snap-private-tmp
drwxr-xr-x 3 root           root           4096 Oct 15 03:56 ssh
-rw-r--r-- 1 root           root            973 Oct 15 03:59 ssh.tar.gz
-rw-r--r-- 1 root           root           1268 Oct 15 03:55 ssh.zip
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-logind.service-ivhnzh
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-resolved.service-rYzZ5N
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-timesyncd.service-CIWdbU
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#

root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# rm -rf ssh
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#

root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# tar -xvzf ssh.tar.gz
ssh/
ssh/ssh_config
ssh/ssh_config.d/
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp# ls -l
total 28
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 clr-debug-pipe-552-4488-in
prwx------ 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 clr-debug-pipe-552-4488-out
srwxrwxrwx 1 root           root              0 Oct 15 03:42 dbus-udIKCB0OAP
srw------- 1 anantgsaraf123 anantgsaraf123    0 Oct 15 03:42 dotnet-diagnostic-552-4488-socket
drwx------ 2 root           root           4096 Oct 15 03:42 snap-private-tmp
drwxr-xr-x 3 root           root           4096 Oct 15 03:56 ssh
-rw-r--r-- 1 root           root            973 Oct 15 03:59 ssh.tar.gz
-rw-r--r-- 1 root           root           1268 Oct 15 03:55 ssh.zip
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-logind.service-ivhnzh
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-resolved.service-rYzZ5N
drwx------ 3 root           root           4096 Oct 15 03:42 systemd-private-ffc99721211f4fce8000025e8dca666f-systemd-timesyncd.service-CIWdbU
root@DESKTOP-CL9FNGA:tmp#
root@DESKTOP-CL9FNGA:tmp#

```
