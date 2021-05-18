#!/bin/bash
scriptpath=$(cd $(dirname $0); pwd)
scriptname=$(basename $0)
log=${scriptpath}"/log."${scriptname%.*}
tmp=$(mktemp)

config_file="${scriptpath}/conf" 
source $config_file

usage(){
    # echo "$scriptname keywords [-i[-r[-w[-c[-d]]]]][secondsNumber]"
    # echo "-i:inquire; -r: read; -w: write; -c: clear; -d secondsNumber: difference; -h: help;"
}

run(){
}

clr(){
}

# if [ -z $1 ] || [ $1 == "-h" ];then
#     usage
# fi

var1=$1

operate=${var1:-"-r"}

if [ $operate == "-r" ];then
  # run project
    message="run project finish!"
    
elif [ $operate == "-c" ];then
    # clear project
    message="clear project finish!"
else
    usage
    message=""
fi
printf "%ss|$message\n" "$(date +"%c %s")" |tee -a $log
exit 0

