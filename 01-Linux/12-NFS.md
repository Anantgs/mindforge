# AWS EC2 – NFS Server and Client Installation Guide

## 1. Introduction

NFS (Network File System) allows multiple Linux servers to share files and directories over a network.

In AWS, we can configure one EC2 instance as an NFS server and another EC2 instance as an NFS client.

### Architecture

| Component | Details |
|---|---|
| NFS Server | EC2 Instance 1 |
| NFS Client | EC2 Instance 2 |
| Server Private IP | 10.0.1.10 |
| Client Private IP | 10.0.1.20 |
| Shared Directory | /data/shared |
| Client Mount Point | /mnt/nfs |
| NFS Version | NFSv4 |
| NFS Port | TCP 2049 |

Note: Replace example IP addresses with your actual EC2 private IP addresses.

---

# PART 1: NFS SERVER-SIDE INSTALLATION

## Step 1: Connect to NFS Server

Connect to your first EC2 instance using SSH or EC2 Instance Connect.

Check the operating system:

```bash
cat /etc/os-release
```

## Step 2: Install NFS packages

For Amazon Linux 2023:

```bash
sudo dnf install -y nfs-utils
```

For Amazon Linux 2:

```bash
sudo yum install -y nfs-utils
```

## Step 3: Create a shared directory

```bash
sudo mkdir -p /data/shared
```

Set permissions for lab practice:

```bash
sudo chmod 777 /data/shared
```

Create a test file:

```bash
sudo touch /data/shared/server-file.txt
```

## Step 4: Configure NFS exports

Open the exports configuration file:

```bash
sudo vi /etc/exports
```

Add the following line:

```text
/data/shared 10.0.1.20(rw,sync,no_subtree_check)
```

Explanation:

- /data/shared – Directory to share.
- 10.0.1.20 – NFS client private IP.
- rw – Read and write permissions.
- sync – Synchronous write operations.
- no_subtree_check – Disables subtree checking.

## Step 5: Start NFS service

Enable and start the NFS service:

```bash
sudo systemctl enable --now nfs-server
```

Check service status:

```bash
sudo systemctl status nfs-server
```

## Step 6: Apply NFS export configuration

```bash
sudo exportfs -rav
```

Verify exported directories:

```bash
sudo exportfs -v
```

## Step 7: Verify NFS port

NFSv4 uses TCP port 2049.

Check whether the server is listening:

```bash
sudo ss -tlnp | grep 2049
```

## Step 8: Configure AWS Security Group

Go to:

AWS Console → EC2 → Security Groups → NFS Server Security Group → Inbound Rules.

Add the following rule:

| Type | Protocol | Port | Source |
|---|---|---|---|
| NFS | TCP | 2049 | NFS Client Security Group |

Use the client security group as the source. Do not expose NFS to the public internet.

---

# PART 2: NFS CLIENT-SIDE INSTALLATION

## Step 1: Connect to NFS Client

Connect to your second EC2 instance.

Check its private IP:

```bash
hostname -I
```

## Step 2: Install NFS packages

For Amazon Linux 2023:

```bash
sudo dnf install -y nfs-utils
```

For Amazon Linux 2:

```bash
sudo yum install -y nfs-utils
```

## Step 3: Create a mount directory

```bash
sudo mkdir -p /mnt/nfs
```

## Step 4: Check connectivity to NFS server

Test TCP port 2049:

```bash
nc -zv 10.0.1.10 2049
```

Expected successful output:

```text
Connection to 10.0.1.10 2049 port [tcp/nfs] succeeded!
```

If the connection fails, check Security Groups, NACLs, routing, server service status, and host firewall rules.

## Step 5: Mount the NFS shared directory

Run:

```bash
sudo mount -t nfs4 10.0.1.10:/data/shared /mnt/nfs
```

Here:

- 10.0.1.10 – NFS server private IP.
- /data/shared – Exported server directory.
- /mnt/nfs – Client mount directory.

## Step 6: Verify NFS mount

```bash
df -hT
```

Or:

```bash
mount | grep nfs
```

Expected output should show:

```text
10.0.1.10:/data/shared  nfs4  ...  /mnt/nfs
```

## Step 7: Test file sharing

On the NFS client:

```bash
sudo touch /mnt/nfs/client-test.txt
```

On the NFS server:

```bash
ls -l /data/shared/
```

Expected files:

```text
server-file.txt
client-test.txt
```

This confirms that the client can write to the NFS shared directory.

---

# PART 3: PERMANENT NFS MOUNT

To automatically mount the NFS share after a client reboot, configure /etc/fstab on the client.

Open:

```bash
sudo vi /etc/fstab
```

Add:

```text
10.0.1.10:/data/shared /mnt/nfs nfs4 defaults,_netdev 0 0
```

Test the configuration:

```bash
sudo mount -a
```

Verify:

```bash
df -hT
```

---

# PART 4: NFS LOGS AND TROUBLESHOOTING

## 1. Check NFS server logs

```bash
sudo journalctl -u nfs-server
```

Last 50 logs:

```bash
sudo journalctl -u nfs-server -n 50
```

Live logs:

```bash
sudo journalctl -u nfs-server -f
```

## 2. Check system logs

```bash
sudo tail -f /var/log/messages
```

Search NFS-related messages:

```bash
sudo grep -i nfs /var/log/messages
```

## 3. Check NFS client logs

```bash
sudo journalctl -f | grep -i nfs
```

Check kernel messages:

```bash
sudo dmesg | grep -i nfs
```

## 4. Important troubleshooting commands

| Purpose | Command |
|---|---|
| Check NFS service | systemctl status nfs-server |
| Check exports | exportfs -v |
| Reload exports | exportfs -rav |
| Check NFS port | ss -tlnp \| grep 2049 |
| Check connectivity | nc -zv SERVER_IP 2049 |
| List exports | showmount -e SERVER_IP |
| Check mounted filesystem | df -hT |
| Unmount NFS | umount /mnt/nfs |
| Check NFS logs | journalctl -u nfs-server |

Note: showmount uses RPC services and may not list exports on an NFSv4-only server. A successful TCP 2049 test and actual NFS mount are better checks for NFSv4.

## 5. Common NFS errors

| Error | Possible reason |
|---|---|
| Connection timed out | Security Group, NACL, or routing issue |
| Connection refused | NFS service is not listening |
| Permission denied | Incorrect export or filesystem permissions |
| No such file or directory | Incorrect export path |
| Stale file handle | Filesystem or export changed |
| Mount command hangs | Network connectivity or server issue |

---

# PART 5: IMPORTANT NFS CONCEPTS

### What is NFS?

NFS is a network file-sharing protocol that allows remote systems to access shared directories.

### What is /etc/exports?

It is the configuration file on the NFS server that specifies which directories are shared and which clients can access them.

### What is the NFS port?

NFSv4 normally uses TCP port 2049.

### What is the difference between NFS server and client?

- NFS Server: Shares directories over the network.
- NFS Client: Mounts and accesses directories shared by the NFS server.

### Do we need an EBS volume for NFS?

No. A directory on the EC2 root filesystem can be shared.

A separate EBS volume is optional and useful for dedicated storage.

### What happens if the NFS server goes down?

Clients may lose access to the shared filesystem. Applications using that filesystem may experience I/O delays or errors.

---

# PART 6: COMPLETE INSTALLATION FLOW

### Server-side

1. Launch EC2 instance.
2. Install nfs-utils.
3. Create /data/shared.
4. Configure /etc/exports.
5. Start nfs-server.
6. Apply exports.
7. Allow TCP 2049 in AWS Security Group.

### Client-side

1. Launch another EC2 instance.
2. Install nfs-utils.
3. Create /mnt/nfs.
4. Test server connectivity.
5. Mount the NFS share.
6. Verify using df -hT.
7. Test file sharing.
8. Configure /etc/fstab for permanent mounting.

**Final result:** Both EC2 instances can access the same shared directory through NFS.

Security recommendation: For production, use dedicated storage, restrictive permissions, appropriate NFS export options, private networking, and monitoring. Avoid chmod 777 and no_root_squash outside isolated labs.
