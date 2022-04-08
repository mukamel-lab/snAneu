#!/bin/bash

# Read an allc file and output the total mc,h in each bin for CG and CH
# The position column is the coordinate of the start of the bin

binsize=$1
fn=$2

ext=`basename $fn`
ext=${ext##*.}

if [[ $ext = "gz" ]] || [[ $ext = "bgz" ]]; then
	zcat $fn | \
	awk -v binsize=$binsize 'BEGIN {bin=0;chr="X"; h_cg=0;mc_cg=0; h_ch=0;mc_ch=0;}
	$2!="pos" {
		OFS="\t";
		if (bin==0)
		{ bin=int($2/binsize); chr=$1; }
		newbin=int($2/binsize);
		if ((newbin>bin) || ($1!=chr)) {print $1,binsize*bin-binsize,mc_cg,h_cg,mc_ch,h_ch;
		bin=newbin; chr=$1;
		h_cg=0;mc_cg=0;
		h_ch=0;mc_ch=0;}
		if ($4~/CG[ACGT]/) {h_cg+=$6;mc_cg+=$5;}
	else if ($4~/C[ACT][ACGT]/) {h_ch+=$6;mc_ch+=$5;}
	}'
else
	awk -v binsize=$binsize 'BEGIN {bin=0; h_cg=0;mc_cg=0; h_ch=0;mc_ch=0;}
	$2!="pos" {
		OFS="\t";
		if (bin==0)
		{ bin=int($2/binsize); }
		newbin=int($2/binsize);
		if (newbin>bin) {print $1,binsize*bin-binsize,mc_cg,h_cg,mc_ch,h_ch;
		bin=newbin;
		h_cg=0;mc_cg=0;
		h_ch=0;mc_ch=0;}
		if ($4~/CG[ACGT]/) {h_cg+=$6;mc_cg+=$5;}
	else if ($4~/C[ACT][ACGT]/) {h_ch+=$6;mc_ch+=$5;}
	}' $fn
fi;
