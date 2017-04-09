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
    regex = gensub(/\s+/, "|", "g", AOIS)
    OFS = ":"
}

$FIX_AOI ~ regex {
	if (index($FIX_AOI, ",") != 0 ) {
		split($FIX_AOI, aois, ",")
		for (i in aois) {
			sub(/\"/, "", aois[i])
			sub(/ +/, "", aois[i])
			if (aois[i] ~ regex) {
				print aois[i], $FIX_INDEX, $FIX_DURATION
				break
			}
		}
	} else {
		print $FIX_AOI, $FIX_INDEX, $FIX_DURATION
	}
}
