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

# input data
CRITERIA="C3=9"
USERDATA="data/ABA.tsv"

if [ ! -e $USERDATA ]; then
    echo "userdata file does not exist"
    exit 1
fi

# From the AOI list, filter those depending a certain criteria
AOIS_FULLNAME=$(awk -f select-aoi-by-criteria.awk "$CRITERIA" $AOI_FILE)

# The AOIs have full name, so remove the infix
AOIS=$(echo "$AOIS_FULLNAME" | awk -f remove-infix.awk)

# Filter rows matching the AOIS
ROWS=$(awk -f select-user-aoi-rows.awk -v AOIS="$AOIS" $USERDATA)

# TODO: append the slide and line number for each AOI
#NROWS=$(echo "$ROWS" awk -f append-slide-line-numer.awk -v POS="$POS_FILE")

UNIQUEROWS=$(echo "$ROWS" | uniq)

