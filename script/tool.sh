#!/bin/bash

White="\033[0m" # White

Red="\033[91m" # Red

Green="\033[92m" # Green

Yellow="\033[93m" # Yellow

Blue="\033[94m" # Blue

Purple="\033[95m" # Purple

Cyan="\033[96m" # Cyan

function print_usage()
{
	printf " -------------------------------------------------------------------------------------------------------\n"
	printf "  $Red Hello, this is Duo-pkgtool.$Blue We can help you Pack RT-Threads.$Yellow Here's how to use$White \n"
	printf "   # Usage:\n"
	printf "    $Cyan Packing $White- pack the compilation results separately into images. \n"
	printf "    $Blue # The format$White:'mkpkg kernel_path [board_type] [output_path] [-option]'$White\n\n"
	printf "       ex: $ mkpkg DPT_PATH_KERNEL={kernel} [DPT_BOARD_TYPE={type}] [DPT_PATH_OUTPUT={output}] [-l/-a]\n"
	printf "      $Green Tip: 1.Items with parentheses$White []$Green can be omitted.$White\n"
	printf "      $Green      2.Omitted items use default values.$White\n"
	printf "      $Green      3.There is no order in the parameters.$White\n\n"
	printf "   ## You can type$Purple print_usage$White to get tips and information :D \n\n"
	printf "   ## ex: $ print_usage \n"
	printf " -------------------------------------------------------------------------------------------------------\n\n"
}

is_valid_model() {
	local PARAM1=$1
	local check_param=false
	for element in "${BOARD_NAME[@]}"; do
		if [[ "$PARAM1" == "$element" ]]; then
			check_param=true
			break
		fi
	done
	if [[ "$check_param" == true ]]; then
		return 0
	else 
		return 1
	fi
}

is_valid_path() {
	local path="$1"
	if [[ ! "$path" =~ ^/[-_.a-zA-Z0-9/]*$ ]]; then
		return 1
	fi
	
	if [ -d "$path" ]; then
		return 0  
	elif [ -f "$path" ]; then
		return 1
	else
		return 1 
	fi
}

function mkpkg() {
	
	local CONFIG_ARRAY=()
	
	if [ $# -lt 1 ]; then
		printf "## You must specify 'DPT_PATH_KERNEL' at least, which represents the kernel directory of the RT-Thread repository!!\n"
		return 1
	fi

	local pack_config="b"
	CONFIG_ARRAY[0]="duo256m"
	CONFIG_ARRAY[2]="${DPT_PATH}/output"
	
	local onetime_pack=false
	local onetime_board=false
	local onetime_kerenl=false
	local onetime_output=false
	
	while [ $# -gt 0 ]; do
		param="$1"
		case "$param" in
			DPT_BOARD_TYPE=*)
				board_type_value="${param#*=}"
				
				if [[ "$onetime_board" = true ]]; then
					printf "## Each parameter needs to be specified only once and does not need to be specified repeatedly!!\n"
					return 1
				fi
				
				if is_valid_model "${board_type_value}"; then
					CONFIG_ARRAY[0]="${board_type_value}"
					onetime_board=true 
				else
					printf "## The board type you inputted is invalid. Please try again! \n\n"
					return 1
				fi
				
				shift
				;;
			DPT_PATH_KERNEL=*)
				kernel_path_value="${param#*=}"
				
				if [[ "$onetime_kerenl" = true ]]; then
					printf "## Each parameter needs to be specified only once and does not need to be specified repeatedly!!\n"
					return 1
				fi
				
				if is_valid_path "${kernel_path_value}"; then
					CONFIG_ARRAY[1]="${kernel_path_value}"
					onetime_kerenl=true 
				else
					printf "## The kernel directory you inputted is invalid. Please try again! \n\n"
					return 1
				fi

				shift
				;;
			DPT_PATH_OUTPUT=*)
				output_path_value="${param#*=}"
				
				if [[ "$onetime_output" = true ]]; then
					printf "## Each parameter needs to be specified only once and does not need to be specified repeatedly!!\n"
					return 1
				fi
				
				if is_valid_path "${output_path_value}"; then
					CONFIG_ARRAY[2]="${output_path_value}"
					onetime_output=true 
				else
					printf "## The output directory you inputted is invalid. Please try again! \n\n"
					return 1
				fi

				shift
				;;
			*)
				if [[ "$1" == "-l" ]]; then
					if [[ "$onetime_pack" = true ]]; then
						printf "## Each parameter needs to be specified only once and does not need to be specified repeatedly!!\n"
						return 1
					fi
					pack_config="l"
					onetime_pack=true
					shift
					
				elif [[ "$1" == "-a" ]]; then
					if [[ "$onetime_pack" = true ]]; then
						printf "## Each parameter needs to be specified only once and does not need to be specified repeatedly!!\n"
						return 1
					fi
					pack_config="a"
					onetime_pack=true
					shift
					
				else 
					printf "## Parameter error, please try again !!\n\n"
					return 1
				fi
				;;
		esac
	done

	if [ "$onetime_kerenl" = false ]; then
		printf "## In addition, you must specify DPT_PATH_KERNEL, which represents the duo directory in the RT-Thread repository!!\n\n"
		return 1
	fi
	
	DPT_BOARD_TYPE="${CONFIG_ARRAY[0]}"
	DPT_PATH_KERNEL=$(realpath "${CONFIG_ARRAY[1]}")
	DPT_PATH_OUTPUT=$(realpath "${CONFIG_ARRAY[2]}")
	
	printf "\n"
	printf "DPT_BOARD_TYPE: '{$Red${DPT_BOARD_TYPE}$White}'\n"
	printf "DPT_PATH_KERNEL: '{$Blue${CONFIG_ARRAY[1]}$White}'\n"
	printf "DPT_PATH_OUTPUT: '{$Yellow${CONFIG_ARRAY[2]}/${VENDOR_TMP}-${DPT_BOARD_TYPE}$White}'\n"
	printf "pack_option: '-${pack_config}'\n\n"
	
	CVITEK_PATH="${DPT_PATH_KERNEL}/bsp/cvitek"
	
	case ${pack_config} in
		b)
			RT_DUO_BKERNEL="${CVITEK_PATH}/cv18xx_risc-v"
			BIMAGE=Image
			if [[ ! -f "${RT_DUO_BKERNEL}/${BIMAGE}" ]]; then
				printf "\n## Please compile successfully or check the duo kernel directory 'DPT_PATH_KERNEL' you specified is correct, then try again.\n"
				return 1
			fi
			
			pushd "${DPT_PATH}/script"
				bash mksdimg.sh ${RT_DUO_BKERNEL} ${BIMAGE} ${DPT_BOARD_TYPE} ${DPT_PATH_OUTPUT}
			popd
			
			;;
		l)
			RT_DUO_SKERNEL="${CVITEK_PATH}/c906_little"
			SIMAGE=rtthread.bin
			if [[ ! -f "${RT_DUO_SKERNEL}/${SIMAGE}" ]]; then
				printf "\n## Please compile successfully or check the duo kernel directory 'DPT_PATH_KERNEL' you specified is correct, then try again.\n"
				return 1
			fi
			
			pushd "${DPT_PATH}/script"
				bash combine-fip.sh ${RT_DUO_SKERNEL} ${SIMAGE} ${DPT_BOARD_TYPE} ${DPT_PATH_OUTPUT}
			popd
			
			;;
		a)
			RT_DUO_BKERNEL="${CVITEK_PATH}/cv18xx_risc-v"
			BIMAGE=Image
			RT_DUO_SKERNEL="${CVITEK_PATH}/c906_little"
			SIMAGE=rtthread.bin
			if [[ ! -f "${RT_DUO_SKERNEL}/${SIMAGE}" ]] || [[ ! -f "${RT_DUO_BKERNEL}/${BIMAGE}" ]]; then
				printf "\n## Please compile successfully or check the duo kernel directory 'DPT_PATH_KERNEL' you specified is correct, then try again.\n"
				return 1
			fi
			
			pushd "${DPT_PATH}/script"
				bash mksdimg.sh ${RT_DUO_BKERNEL} ${BIMAGE} ${DPT_BOARD_TYPE} ${DPT_PATH_OUTPUT}
				if [ $? -ne 0 ]; then
					popd
					return 1
				fi
				bash combine-fip.sh ${RT_DUO_SKERNEL} ${SIMAGE} ${DPT_BOARD_TYPE} ${DPT_PATH_OUTPUT}
			popd
			;;
	esac
}

DPT_SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DPT_PATH=$(realpath "${DPT_SCRIPT_PATH}/..")
BOARD_NAME=("duo" "duo256m" "duos")
VENDOR_TMP="milkv"

if [ -d "${DPT_PATH}" ]; then
	if [ ! -d "${DPT_PATH}/prebuilt" ] || [ ! -d "${DPT_PATH}/script" ]; then
		printf "## The duo-pkgtool directory is not complete and cannot be used properly. Please use a valid duo-pkgtool or download duo-pkgtool again.\n\n"
		return 1
	else
		printf "# duo-pkgtool check is complete, you can try using duo-pkgtool.\n\n"
	fi
else 
	printf "## The path to duo-pkgtool does not exist. Please try using a valid duo-pkgtool.\n\n"
	return 1
fi

print_usage
