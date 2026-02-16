ARG BUILD_FROM=homeassistant/amd64-addon-otbr:latest
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python3 \
       python3-pip \
       socat \
       git \
       build-essential \
       python3-dev \
    && pip3 install --break-system-packages \
       universal-silabs-flasher \
       pyserial-asyncio \
    && apt-get purge -y --auto-remove \
       git \
       build-essential \
       python3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/s6-overlay/scripts/enable-check.sh \
    /etc/s6-overlay/scripts/banner.sh \
    /etc/s6-overlay/scripts/otbr-agent-configure.sh \
    /etc/s6-overlay/scripts/otbr-agent-rest-discovery.sh

COPY rootfs /

RUN chmod +x /etc/s6-overlay/s6-rc.d/otbr-agent/run && \
    chmod +x /etc/s6-overlay/scripts/* && \
    chmod +x /etc/s6-overlay/s6-rc.d/*/run 2>/dev/null || true && \
    chmod +x /etc/s6-overlay/s6-rc.d/*/up 2>/dev/null || true

LABEL \
    io.hass.name="OpenThread Border Router" \
    io.hass.description="Standalone OpenThread Border Router for Home Assistant" \
    io.hass.type="addon" \
    io.hass.version="local"
