#!/usr/bin/env bash
#
# Leonardo Sandoval
# Project: Dislexia/Instituto de Neurociencias/UdG
#
# Description: Using $INPUT_DIR folder as input data files
# create an output $OUTPUT_DIR with the following structure:
#
#   USER1 <AOI1> <X> <Y> <INDEX> <DURATION>
#   USER1 <AOI2> <X> <Y> <INDEX> <DURATION>
#   USER1 <AOI3> <X> <Y> <INDEX> <DURATION>
#   USER1 <AOI4> <X> <Y> <INDEX> <DURATION>
#
#

# include local folder inside PATH
PATH=".:$PATH"

# global variables
CRITERIA=3
VALUE=9
AOI_FILE='aoi.txt'
INPUT_DIR='data'
FIRST_SLIDE=9
LAST_SLIDE=9
COORDINATE_FILE='coordinates.txt'

# loop all user data
for USER_DATA_FILE in $INPUT_DIR/ABA.tsv; do
    BN=`basename $USER_DATA_FILE`
    
    # loop all slides
    for slide in `seq $FIRST_SLIDE 2 $LAST_SLIDE`; do

	# get all AOIs from a specific slide
        AOIS=`criterio.awk C$CRITERIA=$slide $AOI_FILE | remueve_criterio.awk`

        if [ -n "$AOIS" ]; then

	    # get those fixations belonging to the AOIs
    	    F=`filtro.awk -v AOIS="$AOIS" $USER_DATA_FILE | uniq`
	    R=`echo "$F" | datamash -t':' -g1 count 1 sum 5`
            IFS=$'\n'
            for r in $R; do
	    	rr=`echo $r | awk 'BEGIN { FS=":" } { print $1,$2,$3 }'`
	    	echo "$BN C$CRITERIA=$slide $AOI $rr"
	    done


        fi

    done

done


