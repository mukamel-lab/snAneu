#!/bin/bash

mapdir=$1

home=/cndd2/local/bin/ginkgo
tmpfile=/scratch/ginkgo/${mapdir}_SegCopy
if [[ ! -e ${mapdir}/CNV1.gz ]]; then
 # Exclude "segments" which correspond to whole chromosomes
 gunzip -c ${mapdir}/SegCopy.global_goodbins.goodcells.tsv.gz | awk 'NR==1 || ($3-$2==999999)' > $tmpfile

 ${home}/scripts/CNVcaller $tmpfile ${mapdir}/CNV1 ${mapdir}/CNV2 && gzip ${mapdir}/CNV* 
 rm $tmpfile
 echo "Finished CNVcaller for $mapdir"
else
 echo "Skipping $mapdir"
fi
