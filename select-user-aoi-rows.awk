#!/usr/bin/awk -f
#
# Leonardo Sandoval
# Project: Dislexia/Instituto de Neurociencias/UdG
#
# Example:
# $ awk -f $0.awk -v AOIS="001princesa ..." REG=0 SAC=0 userdata.tsv
#
@include "globals"
BEGIN {
    FS = "\t"
    regex = sprintf("^%s", gensub(/\s+/, "|^", "g", AOIS))
    OFS = ":"
} $FIX_AOI ~ regex
