# Goofy System Performance Monitor w/ GUI

## Summary

A PowerShell script to display a GUI for monitoring system performance, including disk space, CPU usage, memory usage, and network utilization.

## Description

This script creates a graphical user interface (GUI) to monitor various system performance metrics. The metrics include:
- Disk space usage
- CPU usage
- Memory usage
- Network utilization

## Author

Chris Spradlin

## Features

- **Disk Space Monitoring**: Displays total, used, and free space in GB with percentages for each drive.
- **CPU Usage Monitoring**: Shows the current CPU usage percentage.
- **Memory Usage Monitoring**: Displays total, used, and free memory in GB with percentages.
- **Network Utilization Monitoring**: Shows the bytes sent and received by the primary network adapter.

## Prerequisites

- Windows PowerShell
- .NET Framework (for Windows Presentation Framework)

## Usage

To run the script, follow these steps:

1. Clone the repository or download the script file.
2. Open PowerShell with administrative privileges.
3. Navigate to the directory containing the script.
4. Execute the script using the following command:
   ```powershell
   .\SystemPerformanceMonitorGUI.ps1
