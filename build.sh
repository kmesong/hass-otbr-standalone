set -e

echo "Building Standalone OTBR Docker Image..."
echo "Base: homeassistant/amd64-addon-otbr:latest"

docker build -t hass-otbr-standalone .

echo "Build complete. Tag: hass-otbr-standalone"
