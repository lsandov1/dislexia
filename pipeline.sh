#!/bin/bash
#
# Leonardo Sandoval
# Project: Dislexia/Instituto de Neurociencias/UdG
#

set -o nounset
set -o errexit

PATH=".:$PATH"

# Constants
AOI_FILE="aoi.txt"
DEBUG=echo
DATADIR="data"
OUTDIR="out"
F_ALL_USERS_OUTPUT="$OUTDIR/output.txt"

output_header() {
    cat << EOF
# USER C4 C2 C1 AOI NFIX SUMFIXLAT MEANSUMFIXLAT SLIDE LINE
#
#     USER: userdata
#     C4: criteria sylabic structure
#     C2: criteria stimulus type
#     C1: criteria AOI area
#     AOI: Area of Interested
#     NFIX: Number of fixations
#     SUMFIXLAT: Sum of fixations latencies
#     MEANSUMFIXLAT: Mean of SUMFIXLAT
#     SLIDE: Slide number where AOI appears
#     LINE: Line number where AOI appears
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

# Default files in OUTDIR
cp $AOI_FILE $OUTDIR
output_header > $OUTDIR/header.txt
> $F_ALL_USERS_OUTPUT

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

    # Setup user output files
    input_header  > $F_INPUT
    > $F_OUTPUT

    # Main Loop
    for C3 in $(seq 9 2 27); do
    	for C4 in $(seq 1 6); do
    	    for C2 in 'p' 'n'; do
    		for C1 in 'A' 'B' 'C'; do
            	    # From the AOI list, filter those depending a certain criteria
            	    AOIS_FULLNAME=$(awk -f select-aoi-by-criteria.awk C3=$C3 C1=$C1 C4=s$C4 $AOI_FILE)
    		    echo "awk -f select-aoi-by-criteria.awk C3=$C3 C4=s$C4 C2=$C2 C1=$C1 $AOI_FILE" >> $F_INPUT
    		    echo "$AOIS_FULLNAME" >> $F_INPUT

    		    # make sure there are AOIS before continuing
    		    [ -z "$AOIS_FULLNAME" ] && { continue; }

            	    # The AOIs have full name, so remove the infix
            	    AOIS=$(echo "$AOIS_FULLNAME" | awk -f remove-infix.awk)

            	    # Remove certain AOI's
            	    AOIS=$(echo "$AOIS" | egrep -v '394texto|395busqueda')

		    # loop each AOI, easier to detect if no user has no AOI data
		    for AOI in $AOIS; do

            	    	# Filter rows matching the AOI
    		    	ROWS=$(awk -f select-user-aoi-rows.awk -v AOIS="$AOI" $USERDATA | uniq | sort -n)
    		    	echo "awk -f select-user-aoi-rows.awk -v AOIS="$AOI" $USERDATA | uniq | sort -n" >> $F_INPUT
    		    	echo "$ROWS" >> $F_INPUT

    		    	# In case there is no related AOI user data, just print zeros and continue loop
    		    	if [ -z "$ROWS" ]; then
			    echo "$USERDATA_BASENAME s$C4 $C2 $C1 $AOI 0 0 0 0 0" >> $F_OUTPUT
			    continue
			fi

            	    	# get and append the slide and line number for each AOI
            	    	STAT=$(echo "$ROWS" | datamash -t : -g 1 count 2 sum 3 mean 3)
    		    	OUT=$(echo "$STAT" | awk -f slide-line-numbers.awk -v USERDATA="$USERDATA_BASENAME" -v CRITERIA="s$C4 $C2 $C1")
    		    	echo "datamash -t : -g 1 count 2 sum 3 mean 3" >> $F_INPUT
            	    	echo "$STAT" >> $F_INPUT
            	    	echo "$OUT" >> $F_OUTPUT
		    done
		done
    	    done
    	done
    done
    # place users results in a single line
    echo "$(tr '\n' ' ' < $F_OUTPUT)" >> $F_ALL_USERS_OUTPUT
done
