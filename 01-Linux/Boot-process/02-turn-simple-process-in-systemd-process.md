# Install and Run Nexus Repository OSS with systemd

This guide installs Nexus Repository OSS (`3.82.0-08`), sets it up under `/app`, runs it as a `nexus` user, and manages it with `systemd`.

---

## 1. Install Dependencies

```bash
sudo yum install -y java-17-openjdk wget tar
````

---

## 2. Create Application Directory

```bash
sudo mkdir -p /app
cd /app
```

---

## 3. Download and Extract Nexus

```bash
wget -O nexus.tar.gz "https://download.sonatype.com/nexus/3/nexus-3.82.0-08-linux-x86_64.tar.gz"
tar -xvf nexus.tar.gz
mv nexus-3.82.0-08 nexus
rm -f nexus.tar.gz
```

---

## 4. Create `nexus` User and Set Permissions

```bash
sudo useradd -r -M -d /app/nexus nexus || true
sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work
```

---

## 5. Configure Nexus to Run as `nexus` User

```bash
echo "run_as_user=\"nexus\"" | sudo tee /app/nexus/bin/nexus.rc
```

## 7. Create `systemd` Service for Nexus

```bash
cat <<EOF | sudo tee /etc/systemd/system/nexus.service
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF
```

---

## 8. Enable and Start the Service

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable nexus
sudo systemctl start nexus
```

---

## Summary

After these steps:

* Nexus is installed in `/app/nexus`.
* Data is stored in `/app/sonatype-work`.
* Runs as a dedicated `nexus` user.
* Managed via `systemd` (`systemctl start|stop|status nexus`).
* Accessible at: [http://localhost:8081](http://localhost:8081)

```

---

If you want, I can also **append a section in this README explaining what happens when Nexus runs as a systemd service**, like I did earlier for `nexus`, so it covers the effects and benefits. That way it’s both procedural and educational.
```


---

## 5. Effects of running `nexus` under systemd

When `nexus` runs as a systemd-managed service:

1. **Dependency handling**

   * `After=network.target` ensures the network is up before `nexus` starts.
   * Other services can require or wait for `nexus` explicitly.

2. **Process isolation**

   * Runs inside a dedicated **cgroup** created by systemd.
   * All child processes of `nexus` are tracked and controlled.

3. **Automatic restart and failure recovery**

   * Can be configured with `Restart=` to relaunch after crashes or failures.

4. **Clean shutdown**

   * On `stop` or system shutdown, systemd sends `SIGTERM` (and `SIGKILL` if needed) to all processes in the service's cgroup.

5. **Centralized logging**

   * All stdout/stderr goes into the system journal:

     ```bash
     journalctl -u nexus
     ```

6. **Resource limits**

   * CPU, memory, and I/O limits can be enforced in the service unit with directives like:

     ```ini
     CPUQuota=50%
     MemoryMax=512M
     ```

7. **Boot-time integration**

   * `systemctl enable` ensures the service starts automatically at boot.
   * Startup/shutdown order is automatically managed.

---

## 6. Useful commands

```bash
# Start service
sudo systemctl start nexus

# Stop service
sudo systemctl stop nexus

# Restart service
sudo systemctl restart nexus

# Reload configuration without stopping
sudo systemctl reload nexus

# View logs
journalctl -u nexus

# Check enabled/disabled status
systemctl is-enabled nexus
```

---

## Summary

Turning `nexus` into a `systemd` service means:

* It’s automatically started, stopped, and restarted by the init system.
* It’s tracked as part of a cgroup for clean process management.
* Logging is centralized.
* Startup/shutdown order is controlled.
* Resource usage can be limited without touching the application itself.

This makes `nexus` more reliable, easier to monitor, and fully integrated into the system’s service management infrastructure.

```

---

If you want, I can make a **second section** in this README with a **flow diagram** showing the chain from `systemctl start nexus` → `systemd` → `cgroup` → logging → monitoring, so it’s visual as well. That would make the “effects” part more intuitive.

