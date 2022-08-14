# Installs the fake-service as a service for systemd on linux
TYPE=$1
NAME=fake-service

sudo cat << EOF > /etc/systemd/system/${NAME}-${TYPE}.service
[Unit]
Description=${NAME} ${TYPE}

[Service]
ExecStart=/opt/fake-service/bin/${NAME} server -config /opt/fake-service/config/${NAME}-${TYPE}.hcl
User=fake-service
Group=fake-service
LimitMEMLOCK=infinity
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK

[Install]
WantedBy=multi-user.target
EOF

# Change owner of fake-service config
sudo chown fake-service:fake-service /opt/fake-service/config/${NAME}-${TYPE}.hcl

sudo chmod 664 /etc/systemd/system/${NAME}-${TYPE}.service
sudo systemctl daemon-reload
sudo systemctl enable ${NAME}-${TYPE}
sudo systemctl start ${NAME}-${TYPE}