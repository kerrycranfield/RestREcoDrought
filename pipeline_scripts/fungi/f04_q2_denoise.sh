#!/bin/bash
# QIIME2 - Denoise ITS_2
# Kerry Hathway June2025
# Requires environment with QIIME2 

# PBS directives
#---------------

#PBS -N denoise_ITS_2
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
fun_seqs="${results_folder}/process_ITS"

# Denoise (default --p-n-reads-learn 1000000)
# Setting the number of threads to 12 for use on HPC
# --p-trunc-len values set after checking base quality in reads - drop in quality at bases 224 and 225
# Rerun with trunc-len set to 0 due to removal of all reads in first round of denoising
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs "${fun_seqs}/f03_pe_dmx_ITS.qza" \
  --p-trunc-len-f 0 \
  --p-trunc-len-r 0 \
  --p-n-threads 12 \
  --o-table "${fun_seqs}/f04_table_ITS_2.qza" \
  --o-denoising-stats "${fun_seqs}/f04_denoising_stats_ITS_2.qza" \
  --o-representative-sequences "${fun_seqs}/f04_rep_seqs_ITS_2.qza" \
  --verbose

# Summarise feature table
qiime feature-table summarize \
--i-table "${fun_seqs}/f04_table_ITS_2.qza" \
--o-visualization "${fun_seqs}/f04_table_ITS_2.qzv"

# Visualise statistics
qiime metadata tabulate \
--m-input-file "${fun_seqs}/f04_denoising_stats_ITS_2.qza" \
--o-visualization "${fun_seqs}/f04_denoising_stats_ITS_2.qzv"

# Tabulate representative sequences
qiime feature-table tabulate-seqs \
--i-data "${fun_seqs}/f04_rep_seqs_ITS_2.qza" \
--o-visualization "${fun_seqs}/f04_rep_seqs_ITS_2.qzv"

# Completion message
echo ""
echo "Done"
date
## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
