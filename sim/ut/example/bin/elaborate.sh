#!/bin/bash -f
scriptpath=$(cd $(dirname $0); pwd)
scriptname=$(basename $0)
workpath=${scriptpath}"/../work/"
cd ${workpath}
set -Eeuo pipefail
# echo "xelab -wto 1d1efad6fbde403189e27f1bc99c4126 --incr --debug typical --relax --mt 8 -L v_smpte_uhdsdi_v1_0_7 -L xil_defaultlib -L v_smpte_sdi_v3_0_8 -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot tb_smpte_3gsdi_behav xil_defaultlib.tb_smpte_3gsdi xil_defaultlib.glbl -log elaborate.log"
# xelab -wto 1d1efad6fbde403189e27f1bc99c4126 \
xelab \
    --incr --debug typical \
    --relax --mt 8 \
    -L xil_defaultlib \
    -L unisims_ver \
    -L unimacro_ver \
    -L secureip \
    -L xpm \
    --snapshot tb_top \
        xil_defaultlib.tb_top \
        xil_defaultlib.glbl \
    -log elaborate.log

