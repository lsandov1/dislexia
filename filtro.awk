#!/usr/bin/env awk
#
# Leonardo Sandoval
d# Project: Dislexia/Instituto de Neurociencias/UdG
#
# Example:
# $ awk -f filtro.awk -v AOIS="001princesa ..." REG=0 SAC=0 userdata.tsv
#
BEGIN {
    FS = "\t"
    regex = gensub(/\s+/, "|", "g", AOIS)
    OFS = ":"
}
$0 ~ regex {
	# Fixation values
	timestamp = $1
	fix_index = $19
	fix_mapped_point_x = $33
	fix_mapped_point_y = $34
	fix_duration = $35
	aoi = $37
	print aoi, fix_mapped_point_x, fix_mapped_point_y, fix_index, fix_duration
}
