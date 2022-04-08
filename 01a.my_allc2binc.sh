#!/bin/bash

binsize=$1
fn=$2
fnout=${fn//allc_/binc\/binc_${binsize}bp_}

if [[ ! -e $fnout ]]; then
 touch $fnout
 echo "** allc2binc $binsize $fn $fnout"
 01b.allc2binc.sh $1 $2 | gzip -c > $fnout
else
 echo "** Skipping $fnout"
fi
