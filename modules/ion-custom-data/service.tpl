[Unit]
Description=${service_description}

[Service]
Type=simple
WorkingDirectory=/home/${vm_user}/ion
ExecStart=/usr/bin/npm run ${service_name}
Environment=ION_BITCOIN_CONFIG_FILE_PATH=/home/${vm_user}/ion/config.json
Environment=ION_BITCOIN_VERSIONING_CONFIG_FILE_PATH=/home/${vm_user}/ion/versioning.json

User=${vm_user}
Group=${vm_user}

[Install]
WantedBy=default.target