#!/bin/bash
scriptpath=$(cd $(dirname $0); pwd)
scriptname=$(basename $0)
# log="log."$scriptname
# echo "" >> $log

# read register
read(){
	readAddress=$1
	readiLength=$2
	readCommand="/home/osrc/app/devmemEx/devmemex read "
	#readResult=$($readCommand $readAddress $2|grep $readAddress|cut -d= -f3)
	readResult=$($readCommand $readAddress $2|grep =|cut -d= -f3)
	echo $readResult
}
# write register
write(){
	writeAddress=$1
	writeiLength=1
	writeiData=$2
	writeCommand="/home/osrc/app/devmemEx/devmemex write "
	writeResult=$($writeCommand $writeAddress $writeiLength	$writeiData)
	# echo $readResult
    # readdata=$(read writeAddress 1)
    # if [ $writeiData == $readdata ];then
    #     writeDone=0
    # else
    #     writeDone=1
    # fi
    # echo $wdone
}
# write clear
writeClear(){
    regAddr=$1
    readResult=$(read $regAddr 1)
    writeResult=$(write $regAddr $readResult)
    echo $readResult
}
