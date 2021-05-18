#!/bin/bash
scriptpath=$(cd $(dirname $0); pwd)
scriptname=$(basename $0)
log="log."$scriptname
echo "" >$log

read_len=6
#read_len=16384

getErrReg(){
    echo $(devmem read  0x43000004 1) >>$log
    echo $(devmem read  0x43000034 1) >>$log
    echo $(devmem read  0x40000584 1) >>$log
    echo $(devmem write 0x43000004 1 0xffffffff) >>/dev/null
    echo $(devmem write 0x43000034 1 0xffffffff) >>/dev/null
    echo $(devmem write 0x40000584 1 0xffffffff) >>/dev/null
}
for((i=0;i<3;i++))
#for((i=0;i<1000;i++))
do
    printf "|----------%10d %50s----------\n" $i "test start." >>$log
    time=$(date +"%F %T.%N")
    getErrReg
    printf "%s|%10d %s\n" "${time}" $i "test start time." >>$log

    echo $(devmem read  0x20000000 $read_len) >> /dev/null
#    devmem read 0x20000000 $read_len

    time=$(date +"%F %T.%N")
    printf "%s|%10d %s\n" "${time}" $i "test finish time ." >>$log
    getErrReg
    printf "|----------%10d %50s----------\n" $i "test finish." >>$log
done



# root@stretch-armhf:/home/osrc#
# root@stretch-armhf:/home/osrc# devmem read 0x40000100 1
# read data
# address = 0x40000100, data = 0x74626376
# root@stretch-armhf:/home/osrc# devmem read 0x40000100 1
# read data
# address = 0x40000100, data = 0x74626376
# root@stretch-armhf:/home/osrc#
# root@stretch-armhf:/home/osrc#
# root@stretch-armhf:/home/osrc#
# root@stretch-armhf:/home/osrc# devmem write 0x40000008 1 0x0
# write data
# root@stretch-armhf:/home/osrc#

