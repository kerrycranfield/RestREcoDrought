#!/bin/bash
# Generating source files containing paths to sequenced data
# Kerry Hathway June2025
# Script to be used with s01_02_wrapper.sh

# PBS directives
#---------------

#PBS -N test
#PBS -l nodes=1:ncpus=4
#PBS -l walltime=00:30:00
#PBS -q half_hour
#PBS -m abe
#PBS -M kerry.hathway@cranfield.ac.uk

#===============
#PBS -j oe
#PBS -v "CUDA_VISIBLE_DEVICES="
#PBS -W sandbox=PRIVATE
#PBS -k n
ln -s $PWD $PBS_O_WORKDIR/$PBS_JOBID
## Change to working directory
cd $PBS_O_WORKDIR
## Calculate number of CPUs and GPUs
export cpus=`cat $PBS_NODEFILE | wc -l`
## Load production modules
module use /apps2/modules/all
## =============

# Stop at runtime errors
set -e

data_folder=$1
output_file=$2


printf "sample-id\tforward-absolute-filepath\treverse-absolute-filepath\n" > "$output_file"

for sample_folder in "${data_folder}"/*/
do
    sample_name=$(basename "${sample_folder}")

    fwd_read=$(find "${sample_folder}" -type f -name "*_1.fastq.gz" ! -name "*raw*")
    rev_read=$(find "${sample_folder}" -type f -name "*_2.fastq.gz" ! -name "*raw*")

    if [[ -f "$fwd_read" && -f "$rev_read" ]]
    then
        printf "%s\t%s\t%s\n" "$sample_name" "$fwd_read" "$rev_read" >> "$output_file"
    else
        echo "Warning: Missing paired-end files for $sample_name"
    fi
done
echo "Done"
date

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
