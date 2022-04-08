#!/bin/sh

# Create a unified table of binc counts with 100kb resolution

sample=$1
normalization=10 # Scaling factor for correcting counts based on cytosine coverage
plotting=CN # Save copy-number plots for each cell
#plotting=FALSE # Do not save plots

home=./ginkgo
chosen_genome=hg38
genome=${home}/genomes/${chosen_genome}
dir=`pwd`/$sample 
statFile=status.xml
data=binc_${sample}_1000kb.tsv.gz

# =======================================================================================
# Segmentation
# =======================================================================================
# Use one of these methods to segment:
# 0 -> Independent (normalized read counts)
# 1 -> Global (sample with lowest IOD)
# 2 -> Custom (using uploaded reference sample)
segMeth=1

# =======================================================================================
# Genome bins
# =======================================================================================
# This is a complex value made of the concatenation of
# - type: variable or fixed (bins. Variable refers to amount of mappable genome, recommended)
# - size: available values are 10000000, 5000000, 2500000, 1000000, 500000, 250000, 175000, 100000,
#       50000, 25000, 10000
# - read-length: available values are: 150, 101, 76, 48
# - aligner: bowtie or bwa
# The read-length and aligner refer to the simulations of re-mapping reads of that length with that
# aligner on the whole genome. This is used to calculate bins of "mappable" (i.e. variable) genome.
# The resulting value is the name of a file under ginkgo/genomes/$choosen_genome/original/ with the
# bin coordinates
binMeth=fixed_100000

# =======================================================================================
# Clustering
# =======================================================================================
# Distance measure. Options can be:
# - euclidean
# - maximum
# - manhattan
# - canberra
# - binary
# - minkowsky
# This is the distance measure used to calculate the distance matrix with the dist function from the
# R package stats
distMeth=euclidean

# Clustering method. Options can be:
# - ward (best to either use ward.D or ward.D2 if using a modern version of R)
# - single
# - complete
# - average
# - NJ
# This is the method used to calculate the dendrogram with the hclust function from the R package
# stats, except for NJ for which the ape library is used.
clustMeth=ward.D2

# Color scheme:
# - 3: dark blue / red
# - 1: light blue / orange
# - 2: magenta / gold
color=3

# For user-defined segmentation (seems to be disabled now)
ref=

# =======================================================================================
# FACS file
# =======================================================================================
f=0
touch ${dir}/ploidyDummy.txt
facs=ploidyDummy.txt
    
# Include sex chromosome (1: yes; 0: no). Probably safe to leave it as 1 unless you have a mixture
# of male and female cells in which case it might be a good idea to leave sex chromosomes out.
sex=1
# =======================================================================================

# Mask bad bins (experimental)
# Removes bins with consistent read pileups from the analysis (e.g. at chromosome boundaries)
rmbadbins=0

if [ ! -f $dir/status.xml ]; then
    echo "Processing $sample"

    touch $dir/status.xml
    mkdir -p $dir/plots
    ./process_from_gzipped_data.R $genome $dir $statFile $data \
      $segMeth $binMeth $clustMeth $distMeth $color ${ref}_mapped $f $facs $sex $rmbadbins $normalization $plotting
    cd $dir
    gzip -f SegCopy SegFixed SegNorm SegStats SegBreaks
    sleep 1
else
    echo "Skipping $sample"
    sleep 1
fi
