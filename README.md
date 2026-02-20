# Linux User Management Scripts

A collection of bash scripts for Linux system administration, focusing on user account management, monitoring, and remote command execution.

## 📋 Scripts Overview

### User Account Management Scripts

#### `add-local-user.sh`
Creates a new user account with an automatically generated password.

**Features:**
- Requires superuser privileges
- Generates secure random passwords
- Forces password change on first login
- Displays username, password, and hostname

**Usage:**
```bash
sudo ./add-local-user.sh USERNAME [COMMENT]
```

**Example:**
```bash
sudo ./add-local-user.sh jsmith "John Smith - Developer"
```

#### `disable-local-user.sh`
Disables, deletes, and/or archives user accounts on the local system.

**Features:**
- Multiple operation modes (disable, delete, archive)
- Protection against system account deletion (UID < 1000)
- Optional home directory archiving
- Bulk user processing

**Options:**
- `-d` - Delete accounts instead of disabling
- `-r` - Remove home directory when deleting
- `-a` - Create archive of home directory

**Usage:**
```bash
sudo ./disable-local-user.sh [-dra] USERNAME [USERNAME2...]
```

**Example:**
```bash
# Disable a user
sudo ./disable-local-user.sh jsmith

# Delete user and remove home directory
sudo ./disable-local-user.sh -d -r jsmith

# Archive home directory then delete
sudo ./disable-local-user.sh -a -d jsmith
```

### Remote Execution Script

#### `run-anywhere.sh`
Executes commands on multiple remote servers via SSH.

**Features:**
- Dry run mode for testing
- Verbose output option
- Custom server list file
- Sudo support for remote commands
- Error handling and reporting

**Options:**
- `-f FILE` - Specify custom server list file (default: /vagrant/servers)
- `-n` - Dry run (display commands without executing)
- `-s` - Execute with sudo on remote servers
- `-v` - Verbose mode (show server names)

**Usage:**
```bash
./run-anywhere.sh [-f FILE] [-nsv] COMMAND
```

**Example:**
```bash
# Check uptime on all servers
./run-anywhere.sh uptime

# Update package lists with sudo
./run-anywhere.sh -s "apt update"

# Dry run with verbose output
./run-anywhere.sh -n -v "hostname"
```

### Security Monitoring Script

#### `show-attackers.sh`
Analyzes login attempts and identifies potential attackers based on failed login counts.

**Features:**
- Parses system log files for failed login attempts
- Groups failures by IP address
- Provides geolocation information
- Configurable threshold for alerts

**Requirements:**
- `geoiplookup` command (install with: `apt install geoip-bin`)
- System log file with authentication entries

**Usage:**
```bash
./show-attackers.sh LOG_FILE
```

**Example:**
```bash
./show-attackers.sh /var/log/auth.log
```

**Output:**
```text
Count, IP, Location
15, 192.168.1.100, United States
12, 10.0.0.50, Unknown
```

## 📦 Prerequisites

- Linux system (CentOS/RHEL 7+ recommended)
- Root/sudo access for user management operations
- SSH access configured for remote execution scripts
- `geoiplookup` command (for show-attackers.sh)

## 🔧 Installation

1. Clone the repository:
```bash
git clone https://github.com/uv012/linux-user-management-scripts.git
cd linux-user-management-scripts

2. Make scripts executable:
```bash
chmod +x *.sh
```

3. For `run-anywhere.sh`, create a servers file:
```bash
echo "server1.example.com" > /vagrant/servers
echo "server2.example.com" >> /vagrant/servers
```

## 🔒 Security Considerations
- All user management scripts require root privileges
- Passwords are displayed only once during account creation
- System accounts (UID < 1000) are protected from deletion
- SSH connections use timeout to prevent hanging
- Scripts include error handling and validation

## ⚠️ Error Handling
- Each script includes comprehensive error checking:
- Input validation
- Privilege verification
- Command execution status checking
- Meaningful error messages
- Appropriate exit codes

## 🤝 Contributing
Feel free to submit issues and enhancement requests!

## 📜 License
This project is open source and available under the MIT License.
