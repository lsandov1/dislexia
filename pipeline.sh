#!/bin/bash
#
# Leonardo Sandoval
# Project: Dislexia/Instituto de Neurociencias/UdG
#
# Input:
#
# ./$0.sh $CRITERIA $USERDATA 

# avoid the './' prefix for local scripts

#set -x
set -o nounset
set -o errexit

PATH=".:$PATH"

# Constants
AOI_FILE="AOI.txt"
DEBUG=echo
C1="C1=A"
DATADIR="data"
#USERDATAFILES=$(find "$DATADIR" -name "$USERDATA_REGEX")

header() {
    cat << EOF
# USER AOI SLIDE LINE NFIX SUMFIXLAT
#
#     USER: userdata
#     AOI: Area of Interested
#     SLIDE: Slide number where AOI appears
#     LINE: Line number where AOI appears
#     NFIX: Number of fixations
#     SUMFIXLAT: Sum of fixations latencies
#     MEANSUMFIXLAT: Mean of SUMFIXLAT
#
EOF
}

OUTDIR="out2"
[ ! -d $OUTDIR ] && { mkdir $OUTDIR; }

USERDATA_REGEX="*.tsv"

for USERDATA in $DATADIR/$USERDATA_REGEX; do

    # define output file and remove it if present
    OUTFILE="$OUTDIR/$(basename "$USERDATA").out"
    [ -e "$OUTFILE" ] && { rm "$OUTFILE"; }

    header > "$OUTFILE"

    for SLIDE in $(seq 9 2 27); do

        C3="C3=$SLIDE"

        # From the AOI list, filter those depending a certain criteria
        AOIS_FULLNAME=$(awk -f select-aoi-by-criteria.awk $C1 $C3 $AOI_FILE)

        # The AOIs have full name, so remove the infix
        AOIS=$(echo "$AOIS_FULLNAME" | awk -f remove-infix.awk)

        # Remove certain AOI's
        #AOIS=$(echo "$AOIS" | egrep -v '394texto|395busqueda')

        # Filter rows matching the AOIS
        ROWS=$(awk -f select-user-aoi-rows.awk -v AOIS="$AOIS" $USERDATA)

        # remove duplicates and sort
        UNIQUE_FIELDS=$(echo "$ROWS" | uniq | sort -n)

        # pathnames just waste chars, so remote the dirname of userdata filename
        USERDATA_BASENAME=$(basename "$USERDATA")

        # get and append the slide and line number for each AOI
        STAT=$(echo "$UNIQUE_FIELDS" | \
    datamash -t : -g 1 count 2 sum 3 mean 3 | \
    awk -f slide-line-numbers.awk -v USERDATA="$USERDATA_BASENAME")
	
        echo "$STAT" >> "$OUTFILE"
    done
done
