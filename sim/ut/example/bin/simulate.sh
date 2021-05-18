#!/bin/bash -f
scriptpath=$(cd $(dirname $0); pwd)
scriptname=$(basename $0)
workpath=${scriptpath}"/../work/"
tb_top_tcl_file=${scriptpath}"/tb_top.tcl"
cd ${workpath}
set -Eeuo pipefail
xsim tb_top \
    -key {Behavioral:sim_1:Functional:tb_top} \
    -tclbatch ${tb_top_tcl_file} \
    -log simulate.log

