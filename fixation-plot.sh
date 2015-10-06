#!/bin/bash

INFOLDER='data'
OUTFOLDER='fix'
SIZE="640,480"

plot_iterator=0

# Loop through all users
for full_userdata in ${INFOLDER}/*.tsv; do
    userdata=$(basename $full_userdata)
    array=(${userdata//./ })
    user="${array[0]}"
    # Loop through all diaps
    for diap in `seq 9 2 23`; do
    	aois=`awk -f criterio.awk aoi.txt C3=${diap} | awk -f remueve_criterio.awk`
    	OUTFILE="${OUTFOLDER}/${user}.${diap}"
    	awk -f filtro.awk -v AOIS="${aois}" ${full_userdata} | uniq > $OUTFILE
    	outs[$plot_iterator]="${OUTFILE}"
    	(( plot_iterator++ ))
    done
done

(( plot_iterator-- ))

TITLE="MappedFixed"
XLABEL="X pos"
YLABEL="Y pos"

echo -e "set title \"$TITLE\""
echo -e "set xlabel \"$XLABEL\""
echo -e "set ylabel \"$YLABEL\""

echo -e "set datafile separator \":\""
echo -e "set terminal postscript eps 6"

for i in $(seq 0 $plot_iterator); do
    echo -e "unset label"
    echo -e "set output \"${outs[i]}.eps\""
    while IFS=: read label x y index duration; do
	label=${label//'"'/ }
	echo -e "set label \"$label\" at $x,$y"
    done < "${outs[i]}"
    echo -e "plot [0:900][900:0] \"${outs[i]}\" using 2:3 with lp"
done
