#!/bin/bash

# SSH configuration
echo "Configure ssh"
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd.service

# Set root user password
echo "root user password is: \"password\""
echo password | passwd --stdin root


#Configure ansible user
if [ $USER_ANSIBLE -eq 1 ]; then
    echo "Configure ansible user"
    if ! id ansible &>/dev/null; then
        useradd ansible
    fi
    echo "ansible user password is: \"password\""
    echo password | passwd --stdin ansible
    echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible
fi

#Configure python
if [ $INSTALL_PYTHON -eq 1 ]; then
    echo "Installing epel-release and python3"
    yum install -y epel-release
    yum install -y python3
fi