#!/bin/bash
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt update
sudo apt install -y git
sudo apt install -y nodejs
sudo apt install -y npm
sudo apt install -y build-essential
cd /home/${vm_user}
git clone https://github.com/decentralized-identity/ion
cd ion
npm i
npm run build
echo '${ion_config}' > /home/${vm_user}/ion/config.json
echo '${ion_versioning}' > /home/${vm_user}/ion/versioning.json
echo '${ion_service}' > /etc/systemd/system/ion.service
systemctl daemon-reload
systemctl enable ion.service
systemctl start ion.service