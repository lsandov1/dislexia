#!/usr/bin/awk -f
#
# Leonardo Sandoval
# Project: Dislexia/Instituto de Neurociencias/UdG
#
# Example:
# $ awk -f insideAOI.awk -v FIX="011cena:154:302:494:99" coordenates.txt
#
BEGIN {
	FS = "\t"
	split(FIX, fields, ":")
	aoi = fields[1]
	x = fields[2]
	y = fields[3]
	ind = fields[4]
	dur = fields[5]
}
$0 ~ aoi {
	split($2, A, ",")
	split($3, B, ",")
	split($4, C, ",")
	split($5, D, ",")

	# print $0
	# print FIX
	# print A[1], x, C[1]
	# print A[2], y, C[2]
	if ( (A[1] <= x) && (x <= C[1]) )
		if ( (A[2] <= y) && (y <= C[2]) ) {
			print aoi, x, y, ind, dur
		}
}
