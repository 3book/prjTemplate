#!/bin/bash
scriptpath=$(cd $(dirname $0); pwd)
scriptname=$(basename $0)
log=${scriptpath}"/log."${scriptname%.*}
tmp=$(mktemp)

reg_descript_file="${scriptpath}/*reg*.md" 
reg_config_file="${scriptpath}/reg_conf" 
source $reg_config_file
source "${scriptpath}/regRw.sh"

usage(){
    echo "$scriptname keywords [-i[-r[-w[-c[-d]]]]][secondsNumber]"
    echo "-i:inquire; -r: read; -w: write; -c: clear; -d secondsNumber: difference; -h: help;"
    exit 0
}
if [ -z $1 ] || [ $1 == "-h" ];then
    usage
fi

var1=$1
var2=$2
var3=$3

keyWords=${var1:-"0x"}
operate=${var2:-"-i"}
delay=${var3:-1}

if [ ! -e $reg_descript_file ];then
        echo "Don't found a *reg*.md file in $scriptpath!"
        exit 1
fi
regNameMap=$( \
cat $reg_descript_file \
|grep -i -E $keyWords \
|awk -F "|" 'NF==8 {print $2,$4,$6}' \
|awk '/0x[0-9a-fA-F]+/ {printf "[%s]=%s-%s ",$1,$2,$3}' \
|grep -i -E $keyWords \
)

declare -A regDict
declare -A opResult
eval regDict=($regNameMap)

if [ $operate == "-i" ];then
    # echo ${!regDict[@]}
    echo $regNameMap
    exit 0
fi

printf "%ss|register file parse finish!\n" "$(date +"%c %s")" |tee -a $log

for key in ${!regDict[@]}
do
    regAddr=$(printf "0x%x" $(($key+$baseAddress)))
    regName=${regDict[$key]%-*}
    regType=${regDict[$key]#*-}
    case "$regType" in
        "RW")
            if [ $operate == "-w" ];then
                if [ ! -z ${regConf[$key]} ];then
                    writeData=${regConf[$key]}
                    writeResult=$(write $regAddr $writeData)
                    opResult[w@$regAddr]=$writeData
                else
                    readData=$(read $regAddr 1)
                    opResult[r@$regAddr]=$readData
                fi
                # printf "write %s=0x%x" $regName $writeData
            else
                readData=$(read $regAddr 1)
                opResult[r@$regAddr]=$readData
                # printf "read %s=0x%x" $regName $readData
            fi
            ;;
        "RO")
            readData=$(read $regAddr 1)
            opResult[r@$regAddr]=$readData
            # printf "%s=0x%x" $regName $readData
            ;;
        "WC")
            if [ $operate == "-c" ];then
                readData=$(writeClear $regAddr)
                opResult[c@$regAddr]=$readData
                # printf "clear %s=0x%x" $regName $readData
            else
                readData=$(read $regAddr 1)
                opResult[r@$regAddr]=$readData
                # printf "read %s=0x%x" $regName $readData
            fi
            ;;
        "?")
            readData=$(read $regAddr 1)
            opResult[r@$regAddr]=$readData
            ;;
    esac
    # echo $key=${regDict[$key]}
done

if [ $operate == "-d" ];then
    printf "%ss|register operate sleep!\n" "$(date +"%c %s")" |tee -a $log
    sleep $delay
    for key in ${!regDict[@]}
    do
        regAddr=$(printf "0x%x" $(($key+$baseAddress)))
        regName=${regDict[$key]%-*}
        regType=${regDict[$key]#*-}
        readData=$(read $regAddr 1)
        opResult[r@$regAddr-2]=$readData
    done
    printf "%ss|register operate finish!\n" "$(date +"%c %s")" |tee -a $log
else
    printf "%ss|register operate finesh!\n" "$(date +"%c %s")" |tee -a $log
fi

# for key in ${!opResult[@]}
for key in ${!regDict[@]}
do
    regAddr=$(printf "0x%x" $(($key+$baseAddress)))
    regName=${regDict[$key]%-*}
    regType=${regDict[$key]#*-}
    if [ $operate == "-d" ];then
        opResult[d@$regAddr]=$((${opResult[r@$regAddr-2]}-${opResult[r@$regAddr]}))
    fi
    if [ -z ${opResult[${operate#-}@$regAddr]} ];then
        echo "register type[$regType] do not match the operate[$operate]!"
        regResult=${opResult[r@$regAddr]}
        printf "r@0x%04x=0x%08x |%s\n" $key $regResult $regName  >> $tmp
    else
        regResult=${opResult[${operate#-}@$regAddr]}
        printf "%s@0x%04x=0x%08x |%s\n" ${operate#-} $key $regResult $regName  >> $tmp
    fi
done
cat $tmp|sort|tee -a $log
printf "%ss|register result print finish!\n" "$(date +"%c %s")" |tee -a $log
