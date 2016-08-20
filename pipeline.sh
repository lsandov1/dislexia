#!/bin/bash
#
# Leonardo Sandoval
# Project: Dislexia/Instituto de Neurociencias/UdG
#

set -o nounset
set -o errexit

PATH=".:$PATH"

# Constants
AOI_FILE="AOI.txt"
DEBUG=echo
DATADIR="data"
OUTDIR="out"

output_header() {
    cat << EOF
# USER C3 C1 C4 AOI SLIDE LINE NFIX SUMFIXLAT
#
#     USER: userdata
#     C3: criteria slide number
#     C1: criteria AOI area
#     C4: criteria sylabic structure
#     AOI: Area of Interested
#     SLIDE: Slide number where AOI appears
#     LINE: Line number where AOI appears
#     NFIX: Number of fixations
#     SUMFIXLAT: Sum of fixations latencies
#     MEANSUMFIXLAT: Mean of SUMFIXLAT
#
EOF
}

input_header() {
    cat << EOF
# Input file, used to compute output.txt
#
# Scripts used:
#
#     select-aoi-by-criteria.awk: Base on criteria, take AOI
#     from AOI list
#
#     select-user-aoi-rows.awk: Based on AOIs, select those
#     rows from user data
#
#     datamash: use first row to count second column, sum the third and mean the third
EOF
}

[ ! -d $OUTDIR ] && { mkdir $OUTDIR; }

cp $AOI_FILE $OUTDIR

USERDATA_REGEX="*.tsv"

for USERDATA in $DATADIR/$USERDATA_REGEX; do

    echo "Computing $USERDATA" >&2

    USERDATA_BASENAME=$(basename "$USERDATA" | cut -f1 -d.)

    # define output user directory
    OUTUSERDIR="$OUTDIR/$USERDATA_BASENAME"
    [ ! -d $OUTUSERDIR ] && { mkdir $OUTUSERDIR; }

    # define the user output files
    F_INPUT="$OUTUSERDIR/input.txt"
    F_OUTPUT="$OUTUSERDIR/output.txt"

    # Include headers
    input_header  > $F_INPUT
    output_header > $F_OUTPUT

    # Loop: slides, criteria 1 then criteria 4
    for C3 in $(seq 9 2 27); do
    	for C1 in 'A' 'B' 'C'; do
    	    for C4 in $(seq 1 6); do

            	# From the AOI list, filter those depending a certain criteria
            	AOIS_FULLNAME=$(awk -f select-aoi-by-criteria.awk C3=$C3 C1=$C1 C4=s$C4 $AOI_FILE)
    		echo "awk -f select-aoi-by-criteria.awk C3=$C3 C1=$C1 C4=s$C4 $AOI_FILE" >> $F_INPUT
    		echo "$AOIS_FULLNAME" >> $F_INPUT

    		# make sure there are AOIS before continuing
    		[ -z "$AOIS_FULLNAME" ] && { continue; }

            	# The AOIs have full name, so remove the infix
            	AOIS=$(echo "$AOIS_FULLNAME" | awk -f remove-infix.awk)

            	# Remove certain AOI's
            	AOIS=$(echo "$AOIS" | egrep -v '394texto|395busqueda')

            	# Filter rows matching the AOIS
		ROWS=$(awk -f select-user-aoi-rows.awk -v AOIS="$AOIS" $USERDATA | uniq | sort -n)
		echo "awk -f select-user-aoi-rows.awk -v AOIS="$AOIS" $USERDATA | uniq | sort -n" >> $F_INPUT
		echo "$ROWS" >> $F_INPUT

    		# Make sure there is user data based on the selected AOIS
    		[ -z "$ROWS" ] && { continue; }

            	# get and append the slide and line number for each AOI
            	STAT=$(echo "$ROWS" | datamash -t : -g 1 count 2 sum 3 mean 3)
		OUT=$(echo "$STAT" | awk -f slide-line-numbers.awk -v USERDATA="$USERDATA_BASENAME" -v CRITERIA="$C3 $C1 s$C4")
		echo "datamash -t : -g 1 count 2 sum 3 mean 3" >> $F_INPUT
            	echo "$STAT" >> $F_INPUT
            	echo "$OUT" >> $F_OUTPUT
    	    done
    	done
    done
done
