#!/bin/bash

# Script to display server statistics: CPU, Memory, Disk usage, and Top 5 processes by CPU and Memory

echo "==========================================="
echo "            SERVER PERFORMANCE STATS      "
echo "==========================================="

# Display Date and Time
echo "Date and Time: $(date)"
echo

# CPU Usage
echo "CPU Usage:"
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "Total CPU Usage: $cpu_usage%"
echo

# Memory Usage (Free vs Used)
echo "Memory Usage:"
total_memory=$(free -h | awk '/^Mem/ {print $2}')
used_memory=$(free -h | awk '/^Mem/ {print $3}')
free_memory=$(free -h | awk '/^Mem/ {print $4}')
memory_percentage=$(free | awk '/^Mem/ {print $3/$2 * 100.0}')
echo "Total Memory: $total_memory"
echo "Used Memory: $used_memory"
echo "Free Memory: $free_memory"
echo "Memory Usage Percentage: $memory_percentage%"
echo

# Disk Usage (Free vs Used)
echo "Disk Usage:"
disk_usage=$(df -h | grep '^/dev' | awk '{ print $1 " - " $3 " used of " $2 " (" $5 " used)"}')
echo "$disk_usage"
echo

# Top 5 Processes by CPU Usage
echo "Top 5 Processes by CPU Usage:"
top -bn1 | sed -n '8,12p' | awk '{print $1, $9, $12}' | sort -k2 -nr | head -n 5
echo

# Top 5 Processes by Memory Usage
echo "Top 5 Processes by Memory Usage:"
ps aux --sort=-%mem | awk 'NR<=6 {print $1, $3, $11, $5}'  # Skips header row and shows top 5
echo

echo "==========================================="
