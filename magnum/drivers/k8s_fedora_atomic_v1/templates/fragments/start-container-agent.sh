#!/bin/bash
set -ux

# heat-docker-agent service
cat <<EOF > /etc/systemd/system/heat-container-agent.service

[Unit]
Description=Heat Container Agent
After=docker.service
Requires=docker.service

[Service]
User=root
Restart=on-failure
ExecStartPre=-/bin/bash -c '/usr/bin/docker history -q docker.io/dragorosson/heat-container-agent4 >/dev/null 2>&1 || /usr/bin/docker load --input /usr/lib/opt/magnum/docker-io-dragorosso-heat-container-agent4.tar'
ExecStartPre=-/usr/bin/docker kill heat-container-agent
ExecStartPre=-/usr/bin/docker rm heat-container-agent
ExecStart=/usr/bin/docker run --name heat-container-agent --privileged --net=host -v /run/systemd:/run/systemd -v /var/lib/heat-cfntools:/var/lib/heat-cfntools -v /var/lib/cloud:/var/lib/cloud docker.io/dragorosson/heat-container-agent4
ExecStop=/usr/bin/docker stop heat-container-agent

[Install]
WantedBy=multi-user.target

EOF

echo "DEBUGGING INFO"
tar -xf /usr/lib/opt/magnum/docker-io-dragorosso-heat-container-agent4.tar -C /tmp/
ls -la /tmp/

df -h
md5sum /usr/lib/opt/magnum/docker-io-dragorosso-heat-container-agent4.tar
tar -tvf /usr/lib/opt/magnum/docker-io-dragorosso-heat-container-agent4.tar
ls -la /usr/lib/opt/magnum/docker-io-dragorosso-heat-container-agent4.tar
ls -la /usr/lib/opt/magnum/
ls -la /usr/lib/opt/
ls -la /usr/lib/
ls -la /usr/

# enable and start docker
/usr/bin/systemctl enable docker.service
/usr/bin/systemctl start --no-block docker.service

# enable and start heat-container-agent
chmod 0640 /etc/systemd/system/heat-container-agent.service
/usr/bin/systemctl enable heat-container-agent.service
/usr/bin/systemctl start --no-block heat-container-agent.service
