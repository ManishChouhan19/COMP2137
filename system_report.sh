#!/bin/bash

#For Getting The Current User
USERNAME=$(whoami)

#For Getting The Current Date And Time
DATETIME=$(date)

#For Gathering The System Information
#For Getting The Name Of The Host
Hostname=$(hostname)

#For Getting the Name And Version Of The Operating System 
OS=$(source /etc/os-release && echo "$NAME $VERSION")

#For Getting the Time we have been Up On The System
UPTIME=$(uptime -p)

#For Gathering The Hardware Information
#For Getting The CPU Model And Name
CPU_INFO=$(sudo lshw -class processor | grep 'product' | awk -F': ' '{print $2}' | head -n 1)
#For Getting The Maximum Speed Of CPU
MAX_CPU_SPEED=$(sudo lshw -class processor | grep 'capacity' | awk -F': ' '{print $2}'| head -n 1)
#For Getting the Current Speed Of The CPU
CURRENT_SPEED=$(sudo lshw -class processor | grep 'size' | awk -F': ' '{print $2}' |head -n 1)
#For Getting The RAM Information
RAM_INFO=$(sudo lshw -C memory | grep "size:" | awk -F': ' '{print $2}' | head -n 1)
#For Getting The Name Of The Video Card Model
VIDEO_INFO=$(sudo lshw -class display | grep "product:" | awk '{print $2}')


#For Gathering The Network Information
#For Getting The Fully Qualified Domain Name
FQDN=$(hostname -f)
#For Getting The Primary IP Address
IP_ADDRESS=$(hostname -I | awk '{print $1}')
#For Getting The Default Gateway
GATEWAY=$(ip r | grep default | awk '{print $3}')
#For Getting The DNS Server IP Address
DNS_SERVER=$(grep nameserver /etc/resolv.conf | awk  '{print $2}')
#For Getting The Interface Name 
INTERFACE_INFO=$(ip r | grep default | awk '{print $5}')
#For Getting The IP Addresses of Interface Names In CIDR Format
IP_ADDRESS_CIDR=$(ip a  | grep "inet " | awk '{print $2}')

#For Gathering System Status
#For Getting The Info About The Users Logged In The System
USERS=$(who | awk '{print $1}')
#For Getting The Number Of Processe Running On The System
PROCESS_COUNT=$(ps -ef | wc -l)
#For Getting Information About Memory Allocation
MEMORY_INFO=$(free -h )
#For Getting The List Of The Listening Network Ports
LISTENING_NETWORK_PORTS=$(ss -tlpn | wc -l)

#For Creating The Report
cat <<EOF

System Report Generated by $USERNAME, $DATETIME

System Information
----------------
Hostname:$HOSTNAME
OS:$OS
UPTIME:$UPTIME

Hardware Information
------------------
cpu: $CPU_INFO
Speed:$CURRENT_SPEED(current), $MAX_CPU_SPEED (max)
Ram: $RAM_INFO
Disk(s): $DISK_INFO
Video: $VIDEO_INFO

Network Information
-----------------
FQDN: $FQDN
Host Address: $IP_ADDRESS
Gateway IP: $GATEWAY
DNS Server: $DNS_SERVER
Interface Name: $INTERFACE_INFO
Interface ADDRESS: $IP_ADDRESS_CIDR

System Status
-----------
Users Logged In: $USERS
Disk Space: $DISK_SPACE
Process Count: $PROCESS_COUNT
Load Averages: $LOAD_AVERAGES
Memory Allocation: $MEMORY_INFO
Listening Network Ports: $LISTENING_NETWORK_PORTS
UFW Rules: $UFW_RULES

EOF
