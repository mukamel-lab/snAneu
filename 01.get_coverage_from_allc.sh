#!/bin/bash
#
# Convert allc tables to binc

sample=$1 # Path to directory containing allc files
binsize=$2 # binsize
nprocs=12 

mkdir -p $sample/binc

find $sample -type f -name "allc_*.gz" -print | xargs -I{} -P $nprocs ./01a.my_allc2binc.sh $binsize {}
