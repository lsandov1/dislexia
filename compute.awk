#!/usr/bin/awk -f
#
# Computes the total fixation duration and total number of fixations
# Leonardo Sandoval
# Project: Dislexia/Instituto de Neurociencias/UdG
#
# Example:
# $ awk -f compute.awk <fixations inside AOI>
#

BEGIN {
	FS = ":"
	duration = 0
}
{
	duration += $5
}
END {
	print duration, NR
}
