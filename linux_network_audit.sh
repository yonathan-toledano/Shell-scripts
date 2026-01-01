#!/bin/bash
# ============================================================
# Script Name : linux_network_audit.sh
# Author      : Yonathan Toledano
#
# Description :
# Comprehensive READ-ONLY Linux Network & System Audit Toolkit.
# Designed for IT, Network, and System Administrators.
#
# The script collects diagnostic information without making
# any changes to the system configuration.
#
# ------------------------------------------------------------
# Supported Operating Systems:
# - Ubuntu 18.04 / 20.04 / 22.04 LTS
# - Debian 10 / 11
#
# Verified against current Microsoft & Linux best practices:
# - Uses modern, supported Linux utilities only
# - No deprecated commands
#
# Commands used:
# ip, ss, getent, df, free, uname, lsb_release, ping
#
# ------------------------------------------------------------
# Target Scope:
# - Local machine only
# - Physical servers
# - Virtual machines
# - Cloud Linux instances (AWS / Azure / GCP)
#
# ❌ Does NOT scan remote hosts
# ❌ Does NOT modify system configuration
# ❌ Does NOT require sudo (read-only)
#
# ------------------------------------------------------------
# ⚖️ LEGAL NOTICE / DISCLAIMER
# THESE SCRIPTS ARE PROVIDED FOR EDUCATIONAL AND
# ADMINISTRATIVE PURPOSES ONLY.
#
# DO NOT run this script on systems you do not own
# or do not have explicit permission to access.
#
# Unauthorized use may violate local laws and
# organizational IT policies.
#
# ------------------------------------------------------------
# How to Run:
# chmod +x linux_network_audit.sh
# ./linux_network_audit.sh
# ./linux_network_audit.sh --help
# ============================================================


# ================================
# CONFIGURATION SECTION
# ================================
# ✅ SAFE TO EDIT

# Output report file
REPORT_FILE="audit_report_$(hostname)_$(date +%F).txt"

# DNS domains to test name resolution
DNS_TEST_HOSTS=("google.com" "github.com")

# IP addresses to test network connectivity (ICMP)
CONNECTIVITY_TARGETS=("8.8.8.8" "1.1.1.1")


# ================================
# FUNCTION: HELP MENU
# ================================
show_help() {
cat << EOF
Usage: ./linux_network_audit.sh [OPTIONS]

Linux Network & System Audit Toolkit (READ-ONLY)

Options:
  -h, --help    Show this help message and exit

What this script does:
  - Collects system and OS information
  - Displays network interfaces and routing table
  - Tests DNS resolution
  - Tests basic network connectivity
  - Lists listening TCP/UDP ports
  - Displays disk and memory usage

Editable configuration variables:
  REPORT_FILE
  DNS_TEST_HOSTS
  CONNECTIVITY_TARGETS

Legal:
  Do NOT run on systems you do not own or do not
  have explicit permission to access.
EOF
}


# ================================
# ARGUMENT HANDLING
# ================================
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
    exit 0
fi


# ================================
# FUNCTION: REPORT HEADER
# ================================
print_header() {
    echo "====================================================" | tee -a "$REPORT_FILE"
    echo " Linux Network & System Audit Report" | tee -a "$REPORT_FILE"
    echo " Hostname : $(hostname)" | tee -a "$REPORT_FILE"
    echo " Date     : $(date)" | tee -a "$REPORT_FILE"
    echo "====================================================" | tee -a "$REPORT_FILE"
    echo "" | tee -a "$REPORT_FILE"
}


# ================================
# FUNCTION: SYSTEM INFORMATION
# ================================
system_info() {
    echo "[+] SYSTEM INFORMATION" | tee -a "$REPORT_FILE"

    # uname -a
    # Displays kernel version, architecture, and OS details
    uname -a | tee -a "$REPORT_FILE"

    # lsb_release -a
    # Displays Linux distribution information
    lsb_release -a 2>/dev/null | tee -a "$REPORT_FILE"

    echo "" | tee -a "$REPORT_FILE"
}


# ================================
# FUNCTION: NETWORK CONFIGURATION
# ================================
network_info() {
    echo "[+] NETWORK CONFIGURATION" | tee -a "$REPORT_FILE"

    # ip addr show
    # Modern replacement for ifconfig (deprecated)
    # Displays network interfaces and IP addresses
    ip addr show | tee -a "$REPORT_FILE"

    # ip route show
    # Modern replacement for route (deprecated)
    # Displays routing table
    ip route show | tee -a "$REPORT_FILE"

    echo "" | tee -a "$REPORT_FILE"
}


# ================================
# FUNCTION: DNS RESOLUTION CHECK
# ================================
dns_check() {
    echo "[+] DNS RESOLUTION CHECK" | tee -a "$REPORT_FILE"

    for host in "${DNS_TEST_HOSTS[@]}"; do
        # getent hosts
        # Queries system name services (DNS, /etc/hosts)
        if getent hosts "$host" >/dev/null; then
            echo "[OK]     $host resolved successfully" | tee -a "$REPORT_FILE"
        else
            echo "[FAILED] $host resolution failed" | tee -a "$REPORT_FILE"
        fi
    done

    echo "" | tee -a "$REPORT_FILE"
}


# ================================
# FUNCTION: CONNECTIVITY TEST
# ================================
connectivity_test() {
    echo "[+] NETWORK CONNECTIVITY TEST" | tee -a "$REPORT_FILE"

    for target in "${CONNECTIVITY_TARGETS[@]}"; do
        # ping -c 2
        # Sends 2 ICMP packets to test reachability
        if ping -c 2 "$target" &>/dev/null; then
            echo "[OK]     $target reachable" | tee -a "$REPORT_FILE"
        else
            echo "[FAILED] $target unreachable" | tee -a "$REPORT_FILE"
        fi
    done

    echo "" | tee -a "$REPORT_FILE"
}


# ================================
# FUNCTION: OPEN PORTS & SERVICES
# ================================
open_ports() {
    echo "[+] LISTENING PORTS & SERVICES" | tee -a "$REPORT_FILE"

    # ss -tuln
    # Modern replacement for netstat (deprecated)
    # Displays listening TCP and UDP ports
    ss -tuln | tee -a "$REPORT_FILE"

    echo "" | tee -a "$REPORT_FILE"
}


# ================================
# FUNCTION: DISK & MEMORY USAGE
# ================================
resource_usage() {
    echo "[+] DISK USAGE" | tee -a "$REPORT_FILE"

    # df -h
    # Displays disk usage in human-readable format
    df -h | tee -a "$REPORT_FILE"

    echo "" | tee -a "$REPORT_FILE"

    echo "[+] MEMORY USAGE" | tee -a "$REPORT_FILE"

    # free -h
    # Displays RAM and swap usage
    free -h | tee -a "$REPORT_FILE"

    echo "" | tee -a "$REPORT_FILE"
}


# ================================
# MAIN EXECUTION FLOW
# ================================
clear
print_header
system_info
network_info
dns_check
connectivity_test
open_ports
resource_usage

echo "===================================================="
echo "Audit completed successfully."
echo "Report saved to: $REPORT_FILE"
echo "===================================================="


