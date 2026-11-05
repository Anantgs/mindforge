### Reference URL : https://medium.com/@sudhir_thakur/s3-vs-efs-vs-fsx-navigating-awss-storage-labyrinth-7d278b754dd9

###  Create FSX file system and while creating check the security group and VPC on which it has to be attached

### Once the file system is created, go to the security group of filesystem and add inbound rule for NFS protocol (port 2049) from the VPC CIDR range

### Go to the EC2 instance and check if the NFS client is installed, if not, install it using the command:

```
df -T

sudo yum install -y amazon-efs-utils

mkdir /test

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-0341dd183cca12acb.efs.us-east-1.amazonaws.com:/ /test

df -T

cd /test/

ls -l
```