
## top command

#### 1. What are the fields of top command

#### 2. How to change priority of the process

#### 3. 


### QUESTION 1 ::: What will you check if you find that your process is not accissible from outside world

```
root@DESKTOP-CL9FNGA:Dell#
root@DESKTOP-CL9FNGA:Dell# netstat -tulnp |grep -i vault
tcp        0      0 127.0.0.1:8200          0.0.0.0:*               LISTEN      316/vault
root@DESKTOP-CL9FNGA:Dell#
root@DESKTOP-CL9FNGA:Dell#
root@DESKTOP-CL9FNGA:Dell#
root@DESKTOP-CL9FNGA:Dell# netstat -tulnp |grep -i 8200
tcp        0      0 127.0.0.1:8200          0.0.0.0:*               LISTEN      316/vault
root@DESKTOP-CL9FNGA:Dell#
root@DESKTOP-CL9FNGA:Dell#
root@DESKTOP-CL9FNGA:Dell# sytemctl status vault
Command 'sytemctl' not found, did you mean:
  command 'systemctl' from deb systemd (255.4-1ubuntu8.6)
  command 'systemctl' from deb systemctl (1.4.4181-1.1)
Try: apt install <deb name>
root@DESKTOP-CL9FNGA:Dell#  systemctl status vault
● vault.service - Vault Service
     Loaded: loaded (/etc/systemd/system/vault.service; enabled; preset: enabled)
     Active: active (running) since Sat 2025-06-14 09:11:12 UTC; 8min ago
       Docs: https://www.vaultproject.io/docs/
   Main PID: 316 (vault)
      Tasks: 11 (limit: 4625)
     Memory: 459.3M (peak: 459.9M)
        CPU: 7.865s
     CGroup: /system.slice/vault.service
             └─316 /usr/bin/vault server -config=/home/anantgsaraf123/config.hcl

Jun 14 09:13:59 DESKTOP-CL9FNGA vault[316]:                    Mlock: supported: true, enabled: true
Jun 14 09:13:59 DESKTOP-CL9FNGA vault[316]:            Recovery Mode: false
Jun 14 09:13:59 DESKTOP-CL9FNGA vault[316]:                  Storage: raft (HA available)
Jun 14 09:13:59 DESKTOP-CL9FNGA vault[316]:                  Version: Vault v1.18.2, built 2024-11-20T11:24:56Z
Jun 14 09:13:59 DESKTOP-CL9FNGA vault[316]:              Version Sha: e36bac59ddb8e10e8912c0ddb44416c850939855
Jun 14 09:13:59 DESKTOP-CL9FNGA vault[316]: ==> Vault server started! Log data will stream in below:
Jun 14 09:13:59 DESKTOP-CL9FNGA vault[316]: 2025-06-14T09:13:14.188Z [INFO]  proxy environment: http_proxy="" https_proxy="" no_proxy=""
Jun 14 09:13:59 DESKTOP-CL9FNGA vault[316]: 2025-06-14T09:13:16.860Z [INFO]  incrementing seal generation: generation=1
Jun 14 09:13:59 DESKTOP-CL9FNGA vault[316]: 2025-06-14T09:13:59.398Z [INFO]  core: Initializing version history cache for core
Jun 14 09:13:59 DESKTOP-CL9FNGA vault[316]: 2025-06-14T09:13:59.421Z [INFO]  events: Starting event system
root@DESKTOP-CL9FNGA:Dell#
root@DESKTOP-CL9FNGA:Dell#
root@DESKTOP-CL9FNGA:Dell# curl http://localhost:8200
<a href="/ui/">Temporary Redirect</a>.

root@DESKTOP-CL9FNGA:Dell#
root@DESKTOP-CL9FNGA:Dell#
root@DESKTOP-CL9FNGA:Dell#
root@DESKTOP-CL9FNGA:Dell# system
system.ini                      systemd-cat                     systemd-detect-virt             systemd-notify                  systemd-tmpfiles
system.mof                      systemd-cgls                    systemd-escape                  systemd-path                    systemd-tty-ask-password-agent
systemcpl.dll                   systemd-cgtop                   systemd-firstboot               systemd-repart                  systemd-umount
systemctl                       systemd-confext                 systemd-hwdb                    systemd-run                     systeminfo.exe
systemd                         systemd-creds                   systemd-id128                   systemd-socket-activate         systemreset.exe
systemd-ac-power                systemd-cryptenroll             systemd-inhibit                 systemd-stdio-bridge
systemd-analyze                 systemd-cryptsetup              systemd-machine-id-setup        systemd-sysext
systemd-ask-password            systemd-delta                   systemd-mount                   systemd-sysusers
root@DESKTOP-CL9FNGA:Dell# systemctl status firewalld
Unit firewalld.service could not be found.
root@DESKTOP-CL9FNGA:Dell#



```
#### Check the process logs using (less command)
#### check security groups of the instance
#### check nacl
#### check loadbalancer health checks


### QUESTION 3 ::: [1] zombie process, [2] what is a peocess

## LOGS

#### 1. How to check the logs of the process

```

root@DESKTOP-CL9FNGA:log#
root@DESKTOP-CL9FNGA:log# cd /var/log
root@DESKTOP-CL9FNGA:log# less auth.log


 file or directory
2025-06-12T16:51:17.185161+00:00 DESKTOP-CL9FNGA login[363]: PAM adding faulty module: pam_lastlog.so
2025-06-12T16:52:01.887609+00:00 DESKTOP-CL9FNGA login[363]: pam_unix(login:session): session opened for user root(uid=0) by root(uid=0)
2025-06-12T16:52:02.191621+00:00 DESKTOP-CL9FNGA systemd-logind[291]: New session 1 of user root.
2025-06-12T16:52:02.586908+00:00 DESKTOP-CL9FNGA (systemd): pam_unix(systemd-user:session): session opened for user root(uid=0) by root(uid=0)
2025-06-12T16:52:06.737115+00:00 DESKTOP-CL9FNGA login[615]: ROOT LOGIN  on '/dev/pts/1'
2025-06-12T17:08:44.185521+00:00 DESKTOP-CL9FNGA useradd[1017]: new group: name=rajesh, GID=1001
2025-06-12T17:08:44.189209+00:00 DESKTOP-CL9FNGA useradd[1017]: new user: name=rajesh, UID=1001, GID=1001, home=/home/rajesh, shell=/bin/sh, from=/dev/pts/0
2025-06-12T17:17:02.241877+00:00 DESKTOP-CL9FNGA CRON[1097]: pam_unix(cron:session): session opened for user root(uid=0) by root(uid=0)
2025-06-12T17:17:02.390773+00:00 DESKTOP-CL9FNGA CRON[1097]: pam_unix(cron:session): session closed for user root
2025-06-12T17:34:43.431772+00:00 DESKTOP-CL9FNGA polkitd[1761]: Loading rules from directory /etc/polkit-1/rules.d
2025-06-12T17:34:43.444090+00:00 DESKTOP-CL9FNGA polkitd[1761]: Loading rules from directory /usr/share/polkit-1/rules.d
2025-06-12T17:34:43.506126+00:00 DESKTOP-CL9FNGA polkitd[1761]: Finished loading, compiling and executing 4 rules
2025-06-12T17:34:43.536232+00:00 DESKTOP-CL9FNGA polkitd[1761]: Acquired the name org.freedesktop.PolicyKit1 on the system bus
2025-06-12T18:17:03.923473+00:00 DESKTOP-CL9FNGA CRON[2742]: pam_unix(cron:session): session opened for user root(uid=0) by root(uid=0)
2025-06-12T18:17:04.641307+00:00 DESKTOP-CL9FNGA CRON[2742]: pam_unix(cron:session): session closed for user root
2025-06-14T09:11:15.645587+00:00 DESKTOP-CL9FNGA systemd-logind[314]: New seat seat0.
2025-06-14T09:11:16.066357+00:00 DESKTOP-CL9FNGA login[353]: PAM unable to dlopen(pam_lastlog.so): /usr/lib/security/pam_lastlog.so: cannot open shared object file: No such file or directory
2025-06-14T09:11:16.066480+00:00 DESKTOP-CL9FNGA login[353]: PAM adding faulty module: pam_lastlog.so
2025-06-14T09:11:50.316892+00:00 DESKTOP-CL9FNGA login[353]: pam_unix(login:session): session opened for user root(uid=0) by root(uid=0)
2025-06-14T09:11:51.296139+00:00 DESKTOP-CL9FNGA systemd-logind[314]: New session 1 of user root.
2025-06-14T09:11:52.986394+00:00 DESKTOP-CL9FNGA (systemd): pam_unix(systemd-user:session): session opened for user root(uid=0) by root(uid=0)
2025-06-14T09:11:59.077407+00:00 DESKTOP-CL9FNGA login[681]: ROOT LOGIN  on '/dev/pts/1'
2025-06-14T09:17:01.822342+00:00 DESKTOP-CL9FNGA CRON[1339]: pam_unix(cron:session): session opened for user root(uid=0) by root(uid=0)
2025-06-14T09:17:01.859147+00:00 DESKTOP-CL9FNGA CRON[1339]: pam_unix(cron:session): session closed for user root
2025-06-14T09:25:29.392621+00:00 DESKTOP-CL9FNGA polkitd[1825]: Loading rules from directory /etc/polkit-1/rules.d
2025-06-14T09:25:29.399949+00:00 DESKTOP-CL9FNGA polkitd[1825]: Loading rules from directory /usr/share/polkit-1/rules.d
2025-06-14T09:25:29.522979+00:00 DESKTOP-CL9FNGA polkitd[1825]: Finished loading, compiling and executing 4 rules
2025-06-14T09:25:29.524299+00:00 DESKTOP-CL9FNGA polkitd[1825]: Acquired the name org.freedesktop.PolicyKit1 on the system bus
~
~
~


```

#### logs reside in /var/log folder

#### 2. How to check the logs of the process

#### Answer: for every process there is a log file

