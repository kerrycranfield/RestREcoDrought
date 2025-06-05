#!/bin/bash
# QIIME2 - Denoise 16S
# Kerry Hathway June2025
# Requires environment with QIIME2 

# PBS directives
#---------------

#PBS -N denoise_16S
#PBS -l nodes=1:ncpus=12
#PBS -l walltime=24:00:00
#PBS -q one_day
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
echo "QIIME2: Denoise"
date
echo ""

# Folders
base_folder="/mnt/beegfs/home/kerry.hathway/thesis"
results_folder="${base_folder}/results"
bac_seqs="${results_folder}/process_16S"

# Denoise (default --p-n-reads-learn 1000000)
# Setting the number of threads to 12 for use on HPC
# --p-trunc-len values set after checking base quality in reads, 0 due to good quality
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs "${bac_seqs}/b03_pe_dmx_16S_trim.qza" \
  --p-trunc-len-f 0 \
  --p-trunc-len-r 0 \
  --p-n-threads 12 \
  --o-table "${bac_seqs}/b04_table_16S.qza" \
  --o-denoising-stats "${bac_seqs}/b04_denoising_stats_16S.qza" \
  --o-representative-sequences "${bac_seqs}/b04_rep_seqs_16S.qza" \
  --verbose

# Summarise feature table
qiime feature-table summarize \
--i-table "${bac_seqs}/b04_table_16S.qza" \
--o-visualization "${bac_seqs}/b04_table_16S.qzv"

# Visualise statistics
qiime metadata tabulate \
--m-input-file "${bac_seqs}/b04_denoising_stats_16S.qza" \
--o-visualization "${bac_seqs}/b04_denoising_stats_16S.qzv"

# Tabulate representative sequences
qiime feature-table tabulate-seqs \
--i-data "${bac_seqs}/b04_rep_seqs_16S.qza" \
--o-visualization "${bac_seqs}/b04_rep_seqs_16S.qzv"

# Completion message
echo ""
echo "Done"
date
## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
