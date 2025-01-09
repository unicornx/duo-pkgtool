PWD=`pwd`
#echo $PWD

BOARD_TYPE=$1
#echo $BOARD_TYPE

sudo mount /dev/sdb1 ~/ws/u-disk/
sudo rm ~/ws/u-disk/*
sudo cp $PWD/output/milkv-$BOARD_TYPE/* ~/ws/u-disk/
sudo umount ~/ws/u-disk 

