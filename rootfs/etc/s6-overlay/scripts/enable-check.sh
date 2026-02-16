#!/bin/bash

# Standalone mode: always assume stable mode
echo "[$(date)] INFO: Stable mode, enabling mDNSResponder (Standalone)."

mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d/
mkdir -p /etc/s6-overlay/s6-rc.d/otbr-agent/dependencies.d/

touch /etc/s6-overlay/s6-rc.d/user/contents.d/mdns
touch /etc/s6-overlay/s6-rc.d/otbr-agent/dependencies.d/mdns

ln -sf "/opt/otbr-stable/sbin/otbr-agent" /usr/sbin/otbr-agent
ln -sf "/opt/otbr-stable/sbin/otbr-web" /usr/sbin/otbr-web
ln -sf "/opt/otbr-stable/sbin/ot-ctl" /usr/sbin/ot-ctl
ln -sf "/opt/otbr-stable/sbin/mdnsd" /usr/sbin/mdnsd

if [[ "${DISABLE_WEB}" == "1" ]]; then
    rm -f /etc/s6-overlay/s6-rc.d/user/contents.d/otbr-web
    echo "[$(date)] INFO: The otbr-web is disabled by configuration."
else
    echo "[$(date)] INFO: Web UI enabled."
fi

if [[ -n "${NETWORK_DEVICE}" ]]; then
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/socat-otbr-tcp
    touch /etc/s6-overlay/s6-rc.d/otbr-agent/dependencies.d/socat-otbr-tcp
    echo "[$(date)] INFO: Enabled socat-otbr-tcp."
fi
