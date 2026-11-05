## Explore session manager in AWS to login from bastion to other instances

#### URL : https://cloudonaut.io/connect-to-your-ec2-instance-using-ssh-the-modern-way/

#### https://stratusgrid.com/blog/optimizing-remote-access-with-the-ssm-agent-plugin-for-aws-cli

#### https://aws.amazon.com/blogs/mt/use-port-forwarding-in-aws-systems-manager-session-manager-to-connect-to-remote-hosts/

#### https://devopscube.com/aws-ssm/

#### https://dev.to/jajera/secure-remote-access-to-private-ec2-instances-with-aws-ssm-session-manager-1bm9


### Notes 

* while creating session manager i attached following policy to the instance

```
resource "aws_iam_policy" "ssm_iam_policy" {
  name = var.iam_policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:StartSession",
          "ssm:TerminateSession",
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus"
        ]
        Resource = "*"
      }
    ]
  })
}
```

* But i will have to change the policy to following 

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ssm:GetConnectionStatus",
                "ssm:DescribeSessions",
                "ssm:*",
                "ec2messages:*",
                "ssmmessages:*",
                "ssm:TerminateSession",
                "ssm:StartSession"
            ],
            "Resource": "*"
        }
    ]
}
```


While connecting to ssm manager i was getting following error 

```
Dell@DESKTOP-CL9FNGA MINGW64 ~/pems/govind-saraf-420-account
$ aws ssm start-session --target i-08bc463d428367755

SessionManagerPlugin is not found. Please refer to SessionManager Documentation here: http://docs.aws.amazon.com/console/systems-manager/session-
manager-plugin-not-found

Dell@DESKTOP-CL9FNGA MINGW64 ~/pems/govind-saraf-420-account
$

```

I installed ssm plugin for windows frpm here : https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html

then it worked

```
Dell@DESKTOP-CL9FNGA MINGW64 ~
$ aws ssm start-session --target i-08bc463d428367755

Starting session with SessionId: admin-quugx5uedickxq7ddcdfh7auou
sh-4.2$
sh-4.2$
sh-4.2$
sh-4.2$ sudo su -
Last login: Wed Jul 23 18:30:04 UTC 2025 on pts/2
[root@ip-10-0-1-221 ~]#

```

* How to check if ssm is installed or not 

```
[root@ip-10-0-1-132 ~]# systemctl status amazon-ssm-agent
ΓùÅ amazon-ssm-agent.service - amazon-ssm-agent
   Loaded: loaded (/usr/lib/systemd/system/amazon-ssm-agent.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2025-07-23 18:51:04 UTC; 5min ago
 Main PID: 3021 (amazon-ssm-agen)
   CGroup: /system.slice/amazon-ssm-agent.service
           Γö£ΓöÇ3021 /usr/bin/amazon-ssm-agent
           Γö£ΓöÇ3123 /usr/bin/ssm-agent-worker
           Γö£ΓöÇ6450 /usr/bin/ssm-session-worker admin-nxrovggy6akr6l79uviz5pqo34
           ΓööΓöÇ6469 sh

Jul 23 18:51:06 ip-10-0-1-132.ec2.internal amazon-ssm-agent[3021]: 2025-07-23 18:51:06.0893 INFO [CredentialRefresher] S...oop
Jul 23 18:51:06 ip-10-0-1-132.ec2.internal amazon-ssm-agent[3021]: 2025-07-23 18:51:06.1362 INFO EC2RoleProvider Success...als
Jul 23 18:51:06 ip-10-0-1-132.ec2.internal amazon-ssm-agent[3021]: 2025-07-23 18:51:06.1372 INFO [CredentialRefresher] C...ady
Jul 23 18:51:06 ip-10-0-1-132.ec2.internal amazon-ssm-agent[3021]: 2025-07-23 18:51:06.1373 INFO [CredentialRefresher] N...tes
Jul 23 18:51:07 ip-10-0-1-132.ec2.internal amazon-ssm-agent[3021]: 2025-07-23 18:51:07.1585 INFO [amazon-ssm-agent] [Lon...ess
Jul 23 18:51:07 ip-10-0-1-132.ec2.internal amazon-ssm-agent[3021]: 2025-07-23 18:51:07.1634 INFO [amazon-ssm-agent] [Lon...ted
Jul 23 18:51:07 ip-10-0-1-132.ec2.internal amazon-ssm-agent[3021]: 2025-07-23 18:51:07.1634 INFO [amazon-ssm-agent] [Lon...nds
Jul 23 18:55:38 ip-10-0-1-132.ec2.internal useradd[6461]: new group: name=ssm-user, GID=1001
Jul 23 18:55:38 ip-10-0-1-132.ec2.internal useradd[6461]: new user: name=ssm-user, UID=1001, GID=1001, home=/home/ssm-u...bash
Jul 23 18:55:52 ip-10-0-1-132.ec2.internal sudo[6470]: ssm-user : TTY=pts/0 ; PWD=/usr/bin ; USER=root ; COMMAND=/bin/su#040-
Hint: Some lines were ellipsized, use -l to show in full.
[root@ip-10-0-1-132 ~]#
[root@ip-10-0-1-132 ~]#
[root@ip-10-0-1-132 ~]#
[root@ip-10-0-1-132 ~]# yum install amazon-ssm-agent
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
amzn2-core                                                                                             | 3.6 kB  00:00:00
Package amazon-ssm-agent-3.3.2299.0-1.amzn2.x86_64 already installed and latest version
Nothing to do
[root@ip-10-0-1-132 ~]#
[root@ip-10-0-1-132 ~]#

```

