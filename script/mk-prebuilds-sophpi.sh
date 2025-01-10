
#!/bin/bash

PROJECTS=(
    "host-tools"
    "build"        
    "fsbl"
    "opensbi"
    "u-boot-2021.10"
    "linux_5.10"
    "osdrv"
    "ramdisk"    
)
ALLBOARD_SOPH=(sg2002_wevb_riscv64_sd sg2000_wevb_riscv64_sd cv1800b_wevb_0008a_spinor)
AllBOARD_MILKV=(milkv-duo256m milkv-duos milkv-duo)
SOPHPI_PATH=

subtree_patch()
{  
  
    # 创建一个关联数组用于快速查找
  declare -A project_map
  for proj in "${PROJECTS[@]}"; do
      project_map["$proj"]=1
  done

  pushd $SOPHPI_PATH/scripts
  # 输入和输出的 XML 文件
  input_xml="subtree.xml"
  output_xml="subtree2.xml"

  # 检查输入文件是否存在
  if [[ ! -f "$input_xml" ]]; then
      echo "输入文件 $input_xml 不存在！"
      exit 1
  fi

  # 清空或创建输出文件
  > "$output_xml"

  # 定义正则表达式
  regex='<project[[:space:]]+[^>]*name="([^"]+)"[^>]*/>'

  # 逐行读取输入文件
  while IFS= read -r line; do  
      # 检查该行是否包含 <project> 元素及其 name 属性
      if [[ "$line" =~ $regex ]]; then
          # BASH_REMATCH[1] 包含第一个捕获组匹配的项目名称
          proj_name="${BASH_REMATCH[1]}"
          # 检查提取的项目名称是否在 project_need 数组中
          if [[ ${project_map["$proj_name"]+_} ]]; then
              echo "$line" >> "$output_xml"
          fi
      else
          # 不是 <project> 元素的行，直接保留
          echo "$line" >> "$output_xml"
      fi
  done < "$input_xml"
  mv $output_xml $input_xml  
  popd   
}


fipv2_patch()
{
  FILE=build/scripts/fip_v2.mk
  sed -i '/^ifeq\s*(\${CONFIG_ENABLE_FREERTOS},y)/,/^endif/ s/^/#/' "$FILE"
}
uboot_init_patch()
{
  BOARD_PATH=build/boards
  CONTENT="int cvi_board_init(void){return 0;}"

  echo $CONTENT > $BOARD_PATH/cv181x/sg2002_wevb_riscv64_sd/u-boot/cvi_board_init.c
  echo $CONTENT > $BOARD_PATH/cv181x/sg2000_wevb_riscv64_sd/u-boot/cvi_board_init.c
  echo $CONTENT > $BOARD_PATH/default/u-boot/cv180x_qfn_cvi_board_init.c
}
#传入开发版类型(sophpi)
function do-build() 
{(
    source build/cvisetup.sh
    defconfig $1    
    clean_all
    
    build_fsbl
    build_kernel
)}
#传入开发板类型（sophpi,milkv）
function do-copy()
{       
    OUTPUT_PATH="output/$2"
    mkdir -p output/$2

    #copy uboot
    mkdir -p $OUTPUT_PATH/uboot
    cp -r u-boot-2021.10/build/$1/u-boot-raw.bin $OUTPUT_PATH/uboot/
    #copy opensbi
    mkdir -p $OUTPUT_PATH/opensbi
    cp -r opensbi/build/platform/generic/firmware/fw_dynamic.bin  $OUTPUT_PATH/opensbi/
    #coy fsbl    
    mkdir -p $OUTPUT_PATH/fsbl
    cp -r fsbl/build/$1/* $OUTPUT_PATH/fsbl/
    cp -r fsbl/test/cv181x/ddr_param.bin $OUTPUT_PATH/fsbl/
    cp -r fsbl/test/empty.bin $OUTPUT_PATH/fsbl/
    #copy dtb    
    mkdir -p $OUTPUT_PATH/dtb
    cp -vr ramdisk/build/$1/workspace/multi.its $OUTPUT_PATH/dtb/
    cp -vr ramdisk/build/$1/workspace/$1.dtb $OUTPUT_PATH/dtb/
}
save_commit()
{
  output_file="git_versions.txt"
  > "$output_file"
  
  for project in "${PROJECTS[@]}"; do
      # 检查当前目录下是否存在该文件夹
      if [ -d "$project" ]; then
          # 检查该文件夹是否是一个 Git 仓库
          if [ -d "$project/.git" ]; then
              # 获取当前的提交哈希
              commit_hash=$(git -C "$project" rev-parse HEAD 2>/dev/null)
              
              # 检查 git 命令是否成功执行
              if [ $? -eq 0 ]; then
                  echo "$project: $commit_hash" >> "$output_file"
              else
                  echo "$project: 无法获取提交版本" >> "$output_file"
              fi
          else
              echo "$project: 不是一个 Git 仓库" >> "$output_file"
          fi
      else
          echo "$project: 文件夹不存在" >> "$output_file"
      fi
  done    
}

if [  -z "$SOPHPI_PATH" ]; then
  #rm -rf sophpi
  git clone -b sg200x-evb git@github.com:sophgo/sophpi.git    
  SOPHPI_PATH=sophpi
fi

# 裁剪
subtree_patch
pushd $SOPHPI_PATH
./scripts/repo_clone.sh --gitclone scripts/subtree.xml 
# # 打补丁
fipv2_patch
uboot_init_patch
编译
for i in "${!ALLBOARD_SOPH[@]}"; do
    BOARD_SOPH=${ALLBOARD_SOPH[i]}
    BOARD_MILKV=${AllBOARD_MILKV[i]}    
    do-build $BOARD_SOPH
    do-copy $BOARD_SOPH $BOARD_MILKV      
done

#记录commit
save_commit
popd
# 输出
cp -rf $SOPHPI_PATH/output/* ../prebuilt

mv $SOPHPI_PATH/git_versions.txt ../

#rm -rf $SOPHPI_PATH
