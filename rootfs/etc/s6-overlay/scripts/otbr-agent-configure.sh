#!/command/with-contenv bash

# Wait for OTBR agent to be ready
sleep 5

ot-ctl trel enable || true

if [[ "${NAT64}" == "1" ]]; then
    echo "[$(date)] INFO: Enabling NAT64."
    ot-ctl nat64 enable || true
    ot-ctl dns server upstream enable || true
fi

ot-ctl txpower 6 || true
