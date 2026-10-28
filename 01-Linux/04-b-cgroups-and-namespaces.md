# Understanding cgroups and namespaces in Linux

Linux provides two key kernel features for process isolation and resource control: **namespaces** and **cgroups**.

---

## 🔒 Namespaces: Process Isolation

Namespaces isolate what a process **can see**. This allows different processes to think they are running on their own independent system.

### Types of Namespaces

| Namespace | Isolates |
|-----------|----------|
| `pid`     | Process IDs |
| `net`     | Network interfaces, routing tables |
| `mnt`     | Mount points (filesystems) |
| `uts`     | Hostname and domain name |
| `ipc`     | Interprocess communication |
| `user`    | User and group IDs |
| `cgroup`  | Cgroup hierarchies |
| `time`    | System and monotonic clocks |

### Example Use

```bash
sudo unshare --pid --fork --mount-proc bash
ps -ef  # Shows only isolated processes
```

---

## 🚦 cgroups: Resource Control

**Control Groups (cgroups)** let you limit and measure what a process **can use**.

### What You Can Control

- CPU usage
- Memory usage
- I/O limits
- Number of processes
- Network bandwidth

### Example Use

Create a cgroup that limits memory to 50 MB:

```bash
sudo cgcreate -g memory:/limitedgroup
echo $((50*1024*1024)) | sudo tee /sys/fs/cgroup/memory/limitedgroup/memory.limit_in_bytes
sudo cgexec -g memory:limitedgroup python3 -c "a = ['A'*1024*1024]*100"
```

The above will cause a `MemoryError` or kill the process if it exceeds the 50MB limit.

---

## 🧠 Why They're Useful

Namespaces and cgroups are the foundation for **containers** (e.g., Docker, Kubernetes) and enable:

- Multi-tenant systems
- Secure sandboxes
- Lightweight virtualization
- Resource governance

| Feature      | Purpose |
|--------------|---------|
| Namespaces   | Isolate the process view of the system |
| cgroups      | Limit and account process resource usage |
| Together     | Enable secure, lightweight, VM-like containers |

---

## 🗣️ Non-IT Explanation (Analogy)

> Think of your computer like an apartment building.  
> - **Namespaces** give each tenant their own private apartment.
> - **cgroups** give each tenant limits on electricity and water use.  
> Combined, they ensure no one can see each other or hog all the resources.





