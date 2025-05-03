# 🌙 Moonshot Agent Installer

**Moonshot Agent Installer** is a fun, user-friendly, and secure Bash script for downloading and installing the Checkmk agent from a protected internal repository.  
It features clear step-by-step feedback, logging, a dry-run mode, and a cosmic theme!

---

## 🚀 Features

- **ASCII art and cosmic theme** for a delightful UX
- **Step-by-step guidance** with color-coded messages
- **Secure password prompt** (never echoed or stored)
- **Spinner animations** for long-running steps
- **Comprehensive logging** to `/var/log/moonshot-agent.log`
- **Dry run mode**: tests authentication and download without installing
- **Command-line flags**: `--dry-run`, `--help`, `--version`
- **Root/sudo check** for safe installation
- **Automatic cleanup** of downloaded files

---

## 🛠️ Requirements

- Bash (v4+ recommended)
- `wget`
- `rpm`
- Root or sudo privileges to install the agent

---

## 📦 Usage

### **Standard Installation**

```bash
sudo ./moonshot-agent.sh
```

### **Dry Run (test authentication and download only)**

```bash
sudo ./moonshot-agent.sh --dry-run
```

### **Show Help**

```bash
./moonshot-agent.sh --help
```

### **Show Version**

```bash
./moonshot-agent.sh --version
```

---

## 🔐 Security Notes

- The script **never stores your password**; it is only used for the current session.
- All actions and errors are logged to `/var/log/moonshot-agent.log`.
- Only users with the correct HTTP credentials can download the agent.

---

## 📝 Example Output

```
    dMMMMMMMMb .aMMMb  .aMMMb  dMMMMb  .dMMMb  dMP dMP .aMMMb dMMMMMMP
   dMP"dMP"dMPdMP"dMP dMP"dMP dMP dMP dMP" VP dMP dMP dMP"dMP   dMP
  dMP dMP dMPdMP dMP dMP dMP dMP dMP  VMMMb  dMMMMMP dMP dMP   dMP
 dMP dMP dMPdMP.aMP dMP.aMP dMP dMP dP .dMP dMP dMP dMP.aMP   dMP
dMP dMP dMP VMMMP"  VMMMP" dMP dMP  VMMMP" dMP dMP  VMMMP"   dMP

    .aMMMb  .aMMMMP dMMMMMP dMMMMb dMMMMMMP
   dMP"dMP dMP"    dMP     dMP dMP   dMP
  dMMMMMP dMP MMP"dMMMP   dMP dMP   dMP
 dMP dMP dMP.dMP dMP     dMP dMP   dMP
dMP dMP  VMMMP" dMMMMMP dMP dMP   dMP

------------------------------------------------------------
Welcome to the Moonshot Agent Installer!
------------------------------------------------------------
Step 1: Authentication
To download the agent, we need your HTTP password for user 'agentuser'.
Please enter the password: 
------------------------------------------------------------
Step 2: Downloading the Agent
Connecting to the server and downloading the agent package...
 [\]  
Download successful!
The agent package has been saved as check-mk-agent-2.3.0p28-57d94250985d034c.noarch.rpm.
------------------------------------------------------------
Step 3: Installing the Agent
Installing the agent package on your system. This may take a moment...
 [|]  
------------------------------------------------------------
Step 4: Cleaning Up
Removing the downloaded package to keep your system tidy.
------------------------------------------------------------
Installation complete!
The Checkmk agent is now installed and ready for launch.
Mission accomplished. Welcome to the monitoring universe!
------------------------------------------------------------
```

---

## ⚙️ Configuration

Edit the following variables at the top of the script as needed:

```bash
USER="agentuser"
URL="http://your-internal-server/agents/check-mk-agent-2.3.0p28-57d94250985d034c.noarch.rpm"
RPM_FILE="check-mk-agent-2.3.0p28-57d94250985d034c.noarch.rpm"
LOG_FILE="/var/log/moonshot-agent.log"
```

---

## 🧑‍🚀 Contributing

Pull requests and suggestions are welcome!  
Feel free to open an issue for bugs or feature requests.

---

## 📄 License

MIT License

---
