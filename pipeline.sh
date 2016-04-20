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
USERDATA="data/ABA.tsv"
C1="C1=A"

if [ ! -e $USERDATA ]; then
    echo "userdata file does not exist"
    exit 1
fi


echo "# USER:CRITERIA:AOI:SLIDE:LINE:NFIX:SUMFIXLAT"
echo "#"
echo "# where (fields are separated by colons)"
echo "#"
echo "#     USER: userdata"
echo "#     CRITERIA: Criteria parameters"
echo "#     AOI: Area of Interested"
echo "#     SLIDE: Slide number where AOI appears"
echo "#     LINE: Line number where AOI appears"
echo "#     NFIX: Number of fixations"
echo "#     SUMFIXLAT: Sum of fixations latencies"
echo "#     MEANSUMFIXLAT: Mean of SUMFIXLAT"
echo "#"
for c3 in `seq 9 2 25`; do

    C3="C3=$c3"

    # From the AOI list, filter those depending a certain criteria
    AOIS_FULLNAME=$(awk -f select-aoi-by-criteria.awk $C1 $C3 $AOI_FILE)

    # The AOIs have full name, so remove the infix
    AOIS=$(echo "$AOIS_FULLNAME" | awk -f remove-infix.awk)

    # Remove certain AOI's
    AOIS=$(echo "$AOIS" | egrep -v '394texto|395busqueda')

    # Filter rows matching the AOIS
    ROWS=$(awk -f select-user-aoi-rows.awk -v AOIS="$AOIS" $USERDATA)

    # extract relevant data and use colon as field separator
    FIELDS=$(echo "$ROWS" | \
        awk -F '\t' -i globals.awk 'BEGIN { OFS=":" } { print $FIX_AOI, $FIX_INDEX, $FIX_DURATION }' )

    # remove duplicates and sort
    UNIQUE_FIELDS=$(echo "$FIELDS" | uniq | sort -n)

    # get and append the slide and line number for each AOI
    STAT=$(echo "$UNIQUE_FIELDS" | \
datamash -t : -g 1 count 2 sum 3 mean 3 | awk -f slide-line-numbers.awk -v USERDATA=$USERDATA -v CRITERIA="$C1 $C3")

    echo "$STAT"
done
