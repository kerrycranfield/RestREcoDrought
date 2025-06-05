#!/bin/bash
# Wrapper for generating source files and running FastQC and MultiQC
# Kerry Hathway June2025

# PBS directives
#---------------

#PBS -N source_files_QC
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

#./s01_sourcefilesgenerate.sh /mnt/beegfs/home/kerry.hathway/thesis/data/16S/01.RawData /mnt/beegfs/home/kerry.hathway/thesis/data/source_file_16S.txt
#./s01_sourcefilesgenerate.sh /mnt/beegfs/home/kerry.hathway/thesis/data/ITS/01.RawData /mnt/beegfs/home/kerry.hathway/thesis/data/source_file_ITS.txt

./s02_qc.sh /mnt/beegfs/home/kerry.hathway/thesis/data/16S/01.RawData /mnt/beegfs/home/kerry.hathway/thesis/results/fastqc_results_16S
./s02_qc.sh /mnt/beegfs/home/kerry.hathway/thesis/data/ITS/01.RawData /mnt/beegfs/home/kerry.hathway/thesis/results/fastqc_results_ITS

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID