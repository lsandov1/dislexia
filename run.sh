#!/usr/bin/env bash


CRITERIA=3
VALUE=9
AOI_FILE='aoi.txt'



INPUT_DIR='data'
OUTPUT_DIR='out'
FIRST_SLIDE=9
LAST_SLIDE=35
COORDINATE_FILE='coordinates.txt'

if [ -e $OUTPUT_DIR ]; then
    rm -rf $OUTPUT_DIR
fi

mkdir $OUTPUT_DIR


for USER_DATA_FILE in $INPUT_DIR/*.tsv; do
    BN=`basename $USER_DATA_FILE`
    for slide in `seq $FIRST_SLIDE 2 $LAST_SLIDE`; do
	USER_OUTPUT_FILE=$OUTPUT_DIR/$BN.$slide.fix
	> $USER_OUTPUT_FILE
        AOIS=`awk -f criterio.awk C$CRITERIA=$slide $AOI_FILE | awk -f remueve_criterio.awk`
        if [ -n "$AOIS" ]; then
    	    # echo "SLIDE $slide"
    	    # echo $AOIS
    	    FIXATIONS=`awk -f filtro.awk -v AOIS="$AOIS" $USER_DATA_FILE | uniq`
    	    IFS=$'\n'; for fix in $FIXATIONS; do
    		#echo $fix
    		awk -f insideAOI.awk -v FIX="$fix" $COORDINATE_FILE >> ${USER_OUTPUT_FILE}
    	    done
	    r=`awk -f compute.awk ${USER_OUTPUT_FILE}`
	    # print per slice
	    echo "$USER_DATA_FILE $USER_OUTPUT_FILE $r"
        fi
    done
    # total count per user
    USER_OUTPUT_FILE=$OUTPUT_DIR/$BN.fix
    cat $OUTPUT_DIR/$BN.*.fix > $USER_OUTPUT_FILE
    r=`awk -f compute.awk $USER_OUTPUT_FILE`
    echo "$USER_DATA_FILE $USER_OUTPUT_FILE $r"
done


