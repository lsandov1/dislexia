#!/usr/bin/awk -f
#
# Leonardo Sandoval
# Project: Dislexia/Instituto de Neurociencias/UdG
#
# Example:
# $ awk -f $0.awk -v AOIS="001princesa ..." REG=0 SAC=0 userdata.tsv
#
@include "globales"
BEGIN {
    FS = "\t"
    regex = gensub(/\s+/, "|", "g", AOIS)
    OFS = ":"
}
$0 ~ regex {
	print $AOI,			  \
		$FIXATION_MAPPED_POINT_X, \
		$FIXATION_MAPPED_POINT_Y, \
		$FIXATION_INDEX, \
		$FIXATION_DURATION
}
