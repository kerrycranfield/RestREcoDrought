#!/bin/bash
# Python - Processing metadata
# Kerry Hathway June2025
# Requires environment with Python
# Splitting metadata into fungi and bacteria and removing missing samples from metadata
# Collapses metadata into new file for use with aggregated feature table
# Run with metadata_tool.py and metadata_collapse.py

# PBS directives
#---------------

#PBS -N process_metadata
#PBS -l nodes=1:ncpus=4
#PBS -l walltime=01:00:00
#PBS -q one_hour
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

module load Python/3.11.3-GCCcore-12.3.0

# Start message
echo "Processing metadata to divide into bacteria and fungi specific files"
date
echo ""

# Folders
base_folder="/mnt/beegfs/home/kerry.hathway/thesis"
scripts_folder="${base_folder}/scripts"
data_folder="${base_folder}/data"

# Splits metadata into fungi and bacteria specific metadata files
# Rearranges metadata so Tube Label is now Sampleid as first column - needed for qiime2 group-by tool to work
# Removes samples from metadata that are not included in the provided data

#python3 "${scripts_folder}/metadata_tool.py"

# Collapses metadata to site/treatment level for use with aggregated feature table

python3 "${scripts_folder}/metadata_collapse.py" "${data_folder}/16S/metadata.txt" "${data_folder}/16S/collapsed_metadata.txt"

python3 "${scripts_folder}/metadata_collapse.py" "${data_folder}/ITS/metadata.txt" "${data_folder}/ITS/collapsed_metadata.txt"


# Completion message
echo ""
echo "Done"
date

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
