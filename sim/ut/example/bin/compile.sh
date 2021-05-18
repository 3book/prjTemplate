#!/bin/bash -f
scriptpath=$(cd $(dirname $0); pwd)
scriptname=$(basename $0)
workpath=${scriptpath}"/../work/"
tbpath=${scriptpath}"/../tb/"
img_file=${tbpath}"/*.ascii"

vlog_prj_file=${scriptpath}"/vlog.prj"
vhdl_prj_file=${scriptpath}"/vhdl.prj"

cd ${workpath}
cp ${img_file} ${workpath}
#set -Eeuo pipefail
echo "xvlog --incr --relax -prj ${vlog_prj_file}"
xvlog --incr --relax -prj ${vlog_prj_file} 2>&1 | tee compile.log

# echo "xvhdl --incr --relax -prj ${vhdl_prj_file}"
 xvhdl --incr --relax -prj ${vhdl_prj_file} 2>&1 | tee -a compile.log

