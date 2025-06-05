#!/bin/bash
# QIIME2 - Import - ITS
# KerryHathway June2025
# Requires environment with QIIME2: Use module spider qiime2 to find QIIME2 module in apps2
# Requires file "source_file_ITS.txt" containing paths to relevant files
# Stage to be done after checking read quality using FastQC/MultiQC

# PBS directives
#---------------

#PBS -N import_ITS
#PBS -l nodes=1:ncpus=12
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

module load CONDA/qiime2-amplicon-2024.5

# Start message
echo "QIIME2: Import and Display"
date
echo ""

# Folders
base_folder="/mnt/beegfs/home/kerry.hathway/thesis"
data_folder="${base_folder}/data"
results_folder="${base_folder}/results/process_ITS"

mkdir -p "${results_folder}"

# Importing data to QIIME2. For more details: qiime tools import --help
# source_file_ITS.txt updated using s01_sourcefilesgenerate.sh
qiime tools import \
  --type "SampleData[PairedEndSequencesWithQuality]" \
  --input-path "${data_folder}/source_file_ITS.txt" \
  --input-format "PairedEndFastqManifestPhred33V2" \
  --output-path "${results_folder}/f03_pe_dmx_ITS.qza"

# Make visualisation file (to view at https://view.qiime2.org/)
qiime demux summarize \
--i-data "${results_folder}/f03_pe_dmx_ITS.qza" \
--o-visualization "${results_folder}/f03_pe_dmx_ITS.qzv"

# Completion message
echo ""
echo "Done"
date

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
