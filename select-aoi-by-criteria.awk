#!/usr/bin/awk -f
#
# Leonardo Sandoval
# Project: Dislexia/Instituto de Neurociencias/UdG
#
# Example:
# $ awk -f $0.awk  \
#       C1=A C2=p C3= ......\
#       aoi.txt

@include "globals"
BEGIN{
	# Overwrite matches by user
	for (i = 0; i < ARGC; i++) {
		if (match(ARGV[i], /=/) != 0) {
			split(ARGV[i], arr, "=")
			criteria = arr[1]
			value = arr[2]
			switch (tolower(criteria)) {
			case "c1":
				DC1=value
				break
			case "c2":
				DC2=value
				break
			case "c3":
				DC3=value
				break
			case "c4":
				DC4=value
				break
			case "c5":
				DC5=value
				break
			case "c6":
				DC6=value
				break
			case "c7":
				DC7=value
				break
			case "c8":
				DC8=value
				break
			case "c9":
				DC9=value
				break
			default:
				break
			}
		}
	}
	# Set the regex
	PRE="[[:digit:]]{3}" # This is the tree digit number
	POST="[[:alpha:]]+"  # This is the AOI
	RE = sprintf("%s%s%s%s%s%s%s%s%s%s%s",
		    PRE,
		    DC1, DC2, DC3, DC4, DC5, DC6, DC7, DC8, DC9,
		    POST)
} $0 ~ RE
