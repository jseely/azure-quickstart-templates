#!/bin/bash

# Add user, add to groups and set permissions
#username="${1}"
#useradd -m -d "/home/${username}" -s /bin/bash "${username}"
#usermod -a -G bosh_sshers "${username}"
#usermod -a -G bosh_sudoers "${username}"
#mkdir -p "/home/${username}/.ssh"
#chown -R "${username}:${username}" "/home/${username}/.ssh"
#chmod 700 "/home/${username}/.ssh"
#chmod 600 "/home/${username}/.ssh/authorized_keys"
chmod +x pioneer

# Handle repacked opsman vms with cloud-init enabled
# Should be removed once we have released an untouched opsman vm
if [ -f /var/lib/cloud/instance/user-data.txt ]; then
    pushd /var/lib/waagent/ >/dev/null
    ln -fs /var/lib/cloud/instance/user-data.txt CustomData
    popd >/dev/null
fi

# Add opsman fdqn to /etc/hosts for faster tile uploads
echo "127.0.0.1 ${2}" >> /etc/hosts

set -e

./pioneer check-quota
ionice -c3 ./pioneer build >>/tmp/bootstrap.log 2>&1 &
disown # So pioneer stays running while script finishes
