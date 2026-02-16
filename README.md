# Standalone Build (Recommended)

This folder contains a Dockerfile to build the OpenThread Border Router image directly from the official Home Assistant base image (`homeassistant/amd64-addon-otbr`), completely bypassing the `ownbee/hass-otbr-docker` dependency.

## Why use this?
*   **Official Base**: Uses the source maintained by Nabu Casa/Home Assistant team.
*   **No Middleware**: Removes the dependency on `ownbee` for updates.
*   **Security**: Fewer layers, less potential for stale vulnerabilities.

## How to Build

1.  Navigate to this folder:
    ```bash
    cd standalone
    ```

2.  Run the build script:
    ```bash
    ./build.sh
    ```
    OR manually:
    ```bash
    docker build -t hass-otbr-standalone .
    ```

## How to Run

Update your `docker-compose.yml` to use the new image name:

```yaml
services:
  otbr:
    image: hass-otbr-standalone
    build:
      context: ./standalone
    # ... rest of configuration same as before
```

## Maintenance

This image copies the `rootfs/` from the parent directory. If you make changes to the startup script in the parent `rootfs/`, simply rebuild this standalone image to apply them.
