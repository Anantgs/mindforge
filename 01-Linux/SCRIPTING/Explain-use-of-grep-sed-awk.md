
```
[root@ip-172-31-93-236 /]#
[root@ip-172-31-93-236 /]#
[root@ip-172-31-93-236 /]# ls -l |grep -i rakesh
drwxr-xr-x.   3 root root  4096 Jun  7 07:21 rakesh
[root@ip-172-31-93-236 /]#
[root@ip-172-31-93-236 /]#
[root@ip-172-31-93-236 /]#
[root@ip-172-31-93-236 /]# vim test.txt
[root@ip-172-31-93-236 /]#
[root@ip-172-31-93-236 /]#
[root@ip-172-31-93-236 /]#
[root@ip-172-31-93-236 /]#
[root@ip-172-31-93-236 /]# cat test.txt |grep -i Partition
Partition – Spreads your instances across logical partitions such that groups of instances in one partition do not share the underlying hardware with groups of instances in different partitions. This strategy is typically used by large distributed and replicated workloads, such as Hadoop, Cassandra, and Kafka.
Amazon EC2 instance placement strategies influence instance placement. Partition strategy spreads instances across logical partitions. Cluster strategy packs instances close together. Spread rack/host strategies reduce correlated failures.
[root@ip-172-31-93-236 /]#
```

## how to use grep, sed, and awk in Linux

```
root@DESKTOP-CL9FNGA:log#
root@DESKTOP-CL9FNGA:log# cat /etc/passwd |grep -i rajesh
rajesh:x:1001:1001::/home/rajesh:/bin/sh
root@DESKTOP-CL9FNGA:log#
root@DESKTOP-CL9FNGA:log#
root@DESKTOP-CL9FNGA:log#
root@DESKTOP-CL9FNGA:log# cat /etc/passwd |grep -i rajesh | awk '{print $1}'
rajesh:x:1001:1001::/home/rajesh:/bin/sh
root@DESKTOP-CL9FNGA:log#
root@DESKTOP-CL9FNGA:log#
root@DESKTOP-CL9FNGA:log# cat /etc/passwd |grep -i rajesh | awk -F ":" '{print $1}'
rajesh
root@DESKTOP-CL9FNGA:log#
root@DESKTOP-CL9FNGA:log#
root@DESKTOP-CL9FNGA:log#
```

## How to write a script to checl if user exist or not

```
root@DESKTOP-CL9FNGA:~#
root@DESKTOP-CL9FNGA:~# cat user-script.sh
#! /bin/bash

read -p "Enter user name: " name
echo "The entered username is : $name"
user=`cat /etc/passwd |grep -i $name | awk -F ":" '{print $1}'`
if [ "$user" == "$name" ]
then
        echo "user $name  exists"
else
        echo "user $name doesnot exists"
fi
root@DESKTOP-CL9FNGA:~#

```