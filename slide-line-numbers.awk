#!/usr/bin/awk -f
#
# Leonardo Sandoval
# Project: Dislexia/Instituto de Neurociencias/UdG
#
# Input:
# AOI:NFIX:SUMFIXLAT:MEANFIXLAT
#
@include "globals"

BEGIN {
	FS=":";
	PROCINFO["sorted_in"] = "@ind_num_asc"
}
{
	if (index($0, "\"") == 1) {
		split($0, aois, ",")
		 for (i in aois) {
			 sub("\"", "", aois[i])
			 sub("[:space:]", "", aois[i])
		 }
		 # For the moment, we are considering just the AOI
		 # Trick to get the AOI's number
		 aoi = aois[1] + 0
}
	else {
		# Trick to get the AOI's number
		aoi=$1+0
	}

	slide = 0; line = 0

	if ( aoi > 0 ) {
		for (maxaoi in AOI_SLIDE_LINE) {
			nmaxaoi = strtonum(maxaoi)
			#print aoi, nmaxaoi, (aoi <= nmaxaoi)
			if (aoi <= nmaxaoi) {
				split(AOI_SLIDE_LINE[maxaoi], a)
				slide = a[1]
				line  = a[2]
				break
			}
		}
	}
	print USERDATA, CRITERIA, $1, $2, $3, $4, slide, line
}
