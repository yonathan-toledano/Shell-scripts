# Shell-scripts

This repository contains a collection of Linux shell scripts created to assist with the Network Research module at the JBT Institute.

Most of these scripts were written using nano on Ubuntu 18.04.6 and are designed to help classmates practice and automate network and system tasks.

📝 Purpose

Provide practical tools for learning Linux and networking

Automate simple tasks like text manipulation, service checks, or OSI model demonstrations

Demonstrate solutions to class assignments in a safe, educational environment

Serve as examples for learning scripting, Linux commands, and basic automation

📂 Script Categories
Script	Description
Basic_tools.sh	Basic Linux utilities and commands for learning purposes.
Intro_Linux.sh	Introduces fundamental Linux commands and file system navigation.
Net_tools.sh	Networking tools such as ping, traceroute, and basic network checks.
OSI_model.sh	Demonstrates the OSI model layers using simple echo outputs.
Services.sh	Checks, starts, or stops common Linux services (may require sudo).
Text_Manipulation.sh	Tools for string and file manipulation (grep, sed, awk).
yoni-final.sh	Final combined script integrating multiple functions for assignments.

Some scripts are purely demonstration scripts using echo to print answers.
Other scripts require superuser permissions to execute certain operations.

⚙️ Requirements

Linux environment (Ubuntu recommended)

Bash shell (default on most Linux distributions)

Superuser (sudo) permissions for some scripts

Network connectivity for scripts that download files or install packages

⚠️ Safety & Best Practices

Read the script before running it, especially scripts that modify files in /etc or install packages.

Most scripts are educational and read-only, but some can make system changes.

Only run scripts on virtual machines, test environments, or systems you control.

Backup configuration files before executing scripts that modify system settings.

🚀 How to Run

Open a terminal in the directory containing the scripts:

cd Shell-scripts


Give execution permission if needed:

chmod +x script_name.sh


Run the script:

./script_name.sh


For scripts that require superuser permissions:

sudo ./script_name.sh

🎯 Learning Goals

Understand basic Linux commands and file system structure

Practice network commands and tools (ping, traceroute, netstat)

Learn shell scripting techniques like loops, conditionals, and functions

Automate common tasks for assignments or practical labs

📈 Future Improvements

Add menu-driven scripts combining multiple tools

Include interactive prompts for user input

Add report generation (logs or CSV)

Upgrade scripts to handle errors more gracefully

👤 Author

Yonathan Toledano
GitHub: https://github.com/yonathan-toledano

