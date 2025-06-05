#!/bin/bash
# QIIME2 - Import and trim - 16S
# KerryHathway June2025
# Requires environment with QIIME2: Use module spider qiime2 to find QIIME2 module in apps2
# Requires file "source_file_16S.txt" containing paths to relevant files
# Stage to be done after checking read quality using FastQC/MultiQC

# PBS directives
#---------------

#PBS -N trimming_16S
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
echo "QIIME2: Import and Trim"
date
echo ""

# Folders
base_folder="/mnt/beegfs/home/kerry.hathway/thesis"
data_folder="${base_folder}/data"
results_folder="${base_folder}/results/process_16S"

mkdir -p "${results_folder}"

# Importing data to QIIME2. For more details: qiime tools import --help
# source_file_16S.txt updated using s01_sourcefilesgenerate.sh
qiime tools import \
  --type "SampleData[PairedEndSequencesWithQuality]" \
  --input-path "${data_folder}/source_file_16S.txt" \
  --input-format "PairedEndFastqManifestPhred33V2" \
  --output-path "${results_folder}/b03_pe_dmx_16S.qza"

# Trim primers (https://docs.qiime2.org/2024.5/plugins/available/cutadapt)
qiime cutadapt trim-paired \
  --p-front-f GTGCCAGCMGCCGCGGTAA \
  --p-front-r CCGTCAATTCCTTTGAGTTT \
  --p-match-read-wildcards \
  --i-demultiplexed-sequences "${results_folder}/b03_pe_dmx_16S.qza" \
  --o-trimmed-sequences "${results_folder}/b03_pe_dmx_16S_trim.qza"

# Make visualisation file (to view at https://view.qiime2.org/)
qiime demux summarize \
--i-data "${results_folder}/b03_pe_dmx_16S_trim.qza" \
--o-visualization "${results_folder}/b03_pe_dmx_16S_trim.qzv"

# Completion message
echo ""
echo "Done"
date

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
