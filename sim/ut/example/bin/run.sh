#!/bin/bash -f
scriptpath=$(cd $(dirname $0); pwd)
scriptname=$(basename $0)
arg=${1:-"run"}
echo $arg
if [[ $arg == "clear" ]];then
    rm -rf ${scriptpath}/../work/.*
    rm -rf ${scriptpath}/../work/*
    echo "clear last time result"
    exit 0
fi
sh ${scriptpath}/compile.sh
sh ${scriptpath}/elaborate.sh
sh ${scriptpath}/simulate.sh
