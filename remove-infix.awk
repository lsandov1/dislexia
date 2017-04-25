#!/usr/bin/awk -f
#
# Leonardo Sandoval
# Project: Dislexia/Instituto de Neurociencias/UdG
#
# Example:
# $ echo 001Ap9s5d3L8c7t0princesa | awk -f $0.awk
# 001princesa

@include "globals"
{
	#   DC1         DC9
	#    |           |
	#    v           v
        # 001Ap9s5d3L8c7t0princesa
        #    ^           ^
	#    |           |
	#    x           y
	rev = ""
	len = length
	for(i=len; i!=0 ; i--)
		rev=rev substr($0, i, 1)
	x = match($0, DC1)
	y = len - match(rev, DC9) + 1
	num = substr($0, 1, x-1)
	aoi = substr($0, y+1)
	print (num aoi)
}
