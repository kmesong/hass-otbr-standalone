# Standalone OpenThread Border Router (Docker)

This project provides a **standalone Docker image** for the OpenThread Border Router (OTBR), built directly from the [official Home Assistant Add-on](https://github.com/home-assistant/addons/tree/master/openthread_border_router).

It allows you to run OTBR in a standard Docker environment (without Home Assistant Supervisor) while applying critical stability and compatibility fixes for certain radio hardware.

## Modifications from Official Base Image

This image is based on `homeassistant/amd64-addon-otbr` but applies the following critical changes to ensure stability in a standalone Docker environment:

### 1. Compatibility Fixes (ZBT-1 / SkyConnect)
*   **Removed `uart-init-deassert`**: The official add-on appends this flag to the radio URL when flow control is disabled. This causes connection failures with Silicon Labs ZBT-1 (formerly SkyConnect) and generic RCP firmware. We strip this flag to ensure generic RCP compatibility.

### 2. Crash Prevention (Syslog Emulation)
*   **Dummy Syslog Listener**: The `otbr-agent` binary attempts to connect to `/dev/log` (system syslog) on startup. In a minimal container without a syslog daemon, this causes the agent to **exit immediately with code 1** (silent failure). We inject a lightweight listener to keep the agent alive and capture logs.

### 3. Stability Fixes (Networking)
*   **Removed Backbone Interface (`-B`)**: Configuring a backbone interface (e.g., `eno1`) in Docker `host` networking mode can cause crashes or routing loops on some host network configurations. We removed this flag to allow OTBR to manage its own Thread interface (`wpan0`) safely.

### 4. Standalone Support
*   **Dependencies**: Added `socat` (for network radios) and `universal-silabs-flasher` (for firmware updates), which are present in the Supervisor environment but missing from the raw base image.
*   **Entrypoint**: Configured to run without the Home Assistant Supervisor context.

## Usage

### Docker Compose

```yaml
version: '3.8'
services:
  otbr:
    image: ghcr.io/kmesong/hass-otbr-standalone:latest
    container_name: otbr
    restart: unless-stopped
    privileged: true
    network_mode: host
    volumes:
      - ./otbr_data:/var/lib/thread
    devices:
      - /dev/ttyUSB1:/dev/ttyUSB1
    environment:
      - DEVICE=/dev/ttyUSB1
      - BAUDRATE=460800
      - OTBR_REST_PORT=8082
      - OTBR_WEB_PORT=8081
```

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DEVICE` | `/dev/ttyUSB0` | Path to your Thread Radio (RCP) |
| `BAUDRATE` | `460800` | UART Baudrate (115200, 460800, etc.) |
| `OTBR_WEB_PORT` | `8081` | Port for the Web GUI |
| `OTBR_REST_PORT` | `8082` | Port for the REST API (used by HA integration) |
| `FLOW_CONTROL` | `1` | `1` for Hardware Flow Control (RTS/CTS), `0` for None |

## Troubleshooting

### "otbr-agent exited with code 1"
This usually happens if the syslog listener fails to start or if the radio cannot be accessed.
1.  Check logs: `docker logs otbr`
2.  Verify device: Ensure `/dev/ttyUSBx` exists and is passed to the container.

### Radio Connection Failed
If the log shows "Radio initialization failed":
1.  Verify the firmware on your dongle is **OpenThread RCP** (not Zigbee/NCP).
2.  Try changing `BAUDRATE`. Common values are `460800` (ZBT-1) or `115200` (Nordic).
