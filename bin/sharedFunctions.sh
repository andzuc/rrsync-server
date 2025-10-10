createLocalVolume()
{
    local VOLUME="$1"
    local VOLUME_PATH="$2"

    # Checks for VOLUME_PATH
    if [ -z "${VOLUME_PATH}" ]; then
	echo "Error: ${VOLUME}: Path is not defined."
	exit 1
    fi

    if [ ! -d "${VOLUME_PATH}" ]; then
	echo "Error: ${VOLUME}: The path ${VOLUME_PATH} does not exist or is not a directory."
	exit 1
    fi

    if [ ! -r "${VOLUME_PATH}" ] || [ ! -w "${VOLUME_PATH}" ]; then
	echo "Error: ${VOLUME}: The path ${VOLUME_PATH} does not have read/write permissions."
	exit 1
    fi
    
    if ! command -v docker >/dev/null 2>&1; then
	echo "Error: Docker is not installed or not accessible."
	return 1
    fi

    # Check if the volume already exists (optional)
    if docker volume ls -q | grep -Fx "${VOLUME}" > /dev/null; then
	echo "Warning: ${VOLUME}: The volume already exists."
	return 1
    fi

    # Create the volume
    docker volume create \
	   --driver local \
	   --opt type=none \
	   --opt device="${VOLUME_PATH}" \
	   --opt o=bind \
	   "${VOLUME}"

    echo "${VOLUME}: Volume created successfully, associated with ${VOLUME_PATH}."
    docker volume inspect "${VOLUME}"
}
