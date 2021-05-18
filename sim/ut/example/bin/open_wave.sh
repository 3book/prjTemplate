#!/bin/bash -f
scriptpath=$(cd $(dirname $0); pwd)
scriptname=$(basename $0)
workpath=${scriptpath}"/../work/"
tcl_file=${scriptpath}"/open_wave.tcl"
cd ${workpath}

vivado -source ${tcl_file}
