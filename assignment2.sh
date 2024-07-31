#!/bin/bash

# Function for updating netplan configuration
updating_netplan() {
    cat <<EOF | sudo tee /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    ens3:
      dhcp4: no
      addresses:
        - 192.168.16.21/24
EOF
    sudo netplan apply
    echo "Netplan configuration updated."
}

# Function for installing and configuring apache2 and squid
installing_configuring_services() {
    sudo apt update
    sudo apt install -y apache2 squid
    sudo systemctl enable apache2
    sudo systemctl start apache2
    sudo systemctl enable squid
    sudo systemctl start squid
    echo "Apache2 and Squid installed and configured."
}

# Function to configure UFW firewall
configuring_ufw() {
    sudo apt update
    sudo apt install -y ufw
    # Allow SSH on management network
    sudo ufw allow in on ens3 to any port 22
    # Allow HTTP
    sudo ufw allow in proto tcp to any port 80
    # Allow HTTPS
    sudo ufw allow in proto tcp to any port 443 
    # Allow Squid
    sudo ufw allow in proto tcp to any port 3128
    sudo ufw enable
    echo "UFW firewall configured."
}

# Function to create user accounts and set up SSH keys
creating_users() {
    users=(dennis aubrey captain snibbles brownie scooter sandy perrier cindy tiger yoda)
    for user in "${users[@]}"; do
        sudo useradd -m -s /bin/bash "$user"
        sudo mkdir -p /home/"$user"/.ssh
        sudo chmod 700 /home/"$user"/.ssh
        sudo touch /home/"$user"/.ssh/authorized_keys
        sudo chmod 600 /home/"$user"/.ssh/authorized_keys
        
        # Add SSH keys for the 'dennis' user
        if [ "$user" = "dennis" ]; then
            sudo usermod -aG sudo "$user"
            echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4rT3vTt99Ox5kndS4HmgTrKBT8SKzhK4rhGkEVGlCI student@generic-vm" | sudo tee -a /home/"$user"/.ssh/authorized_keys
        fi

        # Generate SSH keys
        sudo ssh-keygen -t rsa -f /home/"$user"/.ssh/id_rsa -N "" <<< y >/dev/null 2>&1
        sudo ssh-keygen -t ed25519 -f /home/"$user"/.ssh/id_ed25519 -N "" <<< y >/dev/null 2>&1
        sudo cat /home/"$user"/.ssh/id_rsa.pub | sudo tee -a /home/"$user"/.ssh/authorized_keys
        sudo cat /home/"$user"/.ssh/id_ed25519.pub | sudo tee -a /home/"$user"/.ssh/authorized_keys

        echo "User $user created with SSH keys."
    done
}

# Beginning of the script

echo "### Starting server configuration ###"

echo "=== Updating netplan configuration ==="
updating_netplan

echo "*** Installing and configuring apache2 and squid ***"
installing_configuring_services

echo "&&& Configuring UFW firewall &&&"
configuring_ufw

echo "@@@ Creating user accounts and setting up SSH keys @@@"
creating_users

echo "!!! Server configuration completed successfully !!!"

