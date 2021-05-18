#!/bin/bash
scriptpath=$(cd $(dirname $0); pwd)
scriptname=$(basename $0)

log=${scriptpath}"/log."${scriptname%.*}
# tmp=$(mktemp)

source "${scriptpath}/regRw.sh"
if [ -z $1 ];then
echo "soft repair"
#stop vdma
write 0x43000000 0x1008a
#write 0x43000030 0x1008b
write 0x43010000 0x2
#clear buffer
write 0x40000404 0x10021
sleep 1
#stop 3gsdi
write 0x40000404 0x00021
#start vdma
write 0x43000000 0x1008b
#write 0x43000030 0x1008b
write 0x43010000 0x3
#start 3gsdi
write 0x40000404 0x10021
#error clear
#write 0x43000004 0xffffffff
#write 0x43000034 0xffffffff
bash ${scriptpath}/regOp.sh vdmasr -c
bash ${scriptpath}/regOp.sh err -c

else
echo "hard repair"
################################################################################
#soft reset fpga
write 0x40000000  0x1727374
write 0x40000000  0x0727374
#soft reset vdma
write 0x43000000 0x4
write 0x43000030 0x4
write 0x43010030 0x4
################################################################################
# vdma buffer cleanup
## sdi reset=0
write 0x40000404 0x10021
##delay 1s
sleep 1
## sdi reset=1
write 0x40000404 0x100a1
################################################################################
#initialize
bash ${scriptpath}/initialize.sh

fi
