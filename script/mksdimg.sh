#/bin/sh
set -e

PROJECT_PATH=$1
IMAGE_NAME=$2
BOARD_TMP=$3
OUT_PATH=$4

if [[ -z "$PROJECT_PATH" ]] || [[ -z "$IMAGE_NAME" ]] || [[ -z "$BOARD_TMP" ]] || [[ -z "$OUT_PATH" ]]; then
	echo "Usage: $0 <PROJECT_PATH> <IMAGE_NAME> <<BOARD_TYPE>> <OUT_PATH>"
	exit 1
fi

if ! command -v mkimage &> /dev/null
then
	printf "\n## Some tools are missing. Please install them first. \n\n" 
	printf "## To solve this problem, you can use '$ sudo apt install u-boot-tools' to install. \n\n" 
	exit 1
fi

CURRENT_PATH=$(pwd)
echo ${OUT_PATH}

PREBUILT_PATH="${CURRENT_PATH}/../prebuilt"
PREBUILT_PATH=$(realpath "${PREBUILT_PATH}")
echo "prebuilt_dir: ${PREBUILT_PATH}"

. function.sh

get_board_type ${BOARD_TMP}

echo "start compress the Big one of kernels..."

lzma -c -9 -f -k ${PROJECT_PATH}/${IMAGE_NAME} > ${PREBUILT_PATH}/${BOARD_TYPE}/dtb/Image.lzma

if [ ! -d "${OUT_PATH}/${BOARD_TYPE}" ]; then
	mkdir -p ${OUT_PATH}/${BOARD_TYPE}
fi

mkimage -f ${PREBUILT_PATH}/${BOARD_TYPE}/dtb/multi.its -r ${OUT_PATH}/${BOARD_TYPE}/boot.${STORAGE_TYPE}

if [ -f "${PREBUILT_PATH}/${BOARD_TYPE}/dtb/Image.lzma" ]; then
	rm -rf "${PREBUILT_PATH}/${BOARD_TYPE}/dtb/Image.lzma"
fi
