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

# Generating file containing paths to forward and reverse reads for each sample
# Parameter 1: location/path of folder where the sequencing data in the form of fastq files is stored
# Parameter 2: path/name of source file to be created to contain location of forward and reverse reads
./s01_sourcefilesgenerate.sh /mnt/beegfs/home/kerry.hathway/thesis/data/16S/01.RawData /mnt/beegfs/home/kerry.hathway/thesis/data/source_file_16S.txt
./s01_sourcefilesgenerate.sh /mnt/beegfs/home/kerry.hathway/thesis/data/ITS/01.RawData /mnt/beegfs/home/kerry.hathway/thesis/data/source_file_ITS.txt

# Script to run FastQC and MultiQC
# Parameter 1: location/path of folder where the sequencing data in the form of fastq files is stored
# Parameter 2: path/to/folder for outputs from FastQC and MultiQC analysis - folder will be created by script
./s02_qc.sh /mnt/beegfs/home/kerry.hathway/thesis/data/16S/01.RawData /mnt/beegfs/home/kerry.hathway/thesis/results/fastqc_results_16S
./s02_qc.sh /mnt/beegfs/home/kerry.hathway/thesis/data/ITS/01.RawData /mnt/beegfs/home/kerry.hathway/thesis/results/fastqc_results_ITS

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID