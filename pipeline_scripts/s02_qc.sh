#!/bin/bash
# FastQC & MultiQC
# Kerry Hathway June2025
# Requires FastQC and MultiQC in environment


## Load production modules
module use /apps2/modules/all
## =============


# Load required modules
module load FastQC/0.11.9-Java-11
module load MultiQC/1.12-foss-2021b


# Start message
echo "FastQC & MultiQC"
date
echo ""

# Input/output directories
data_folder=$1
results_folder=$2

mkdir -p "${results_folder}"

# Loop through sample folders
for sample_folder in "${data_folder}"/*/
do
    if [ ! -d "${sample_folder}" ]
    then
        continue
    fi
    
    sample_name=$(basename "${sample_folder}")
    echo "Processing ${sample_name}..."
    echo "In folder: ${sample_folder}"

    cd "${sample_folder}"

    # Find relevant FASTQ files (.fastq or .fastq.gz), excluding raw/extended
    fastq_files=$(find . -maxdepth 1 -type f \( \
        -name "*_1.fastq" -o -name "*_2.fastq" -o \
        -name "*_1.fastq.gz" -o -name "*_2.fastq.gz" \
        \) ! -name "*raw*" ! -name "*extended*")

    echo "Found files: $fastq_files"

    if [[ -n "$fastq_files" ]]
    then
        sample_out="${results_folder}/${sample_name}"
        mkdir -p "${sample_out}"
        fastqc --noextract --nogroup --quiet $fastq_files -o "${sample_out}" && echo "FastQC done for ${sample_name}"
    else
        echo "No matching FASTQ files in ${sample_name}, skipping..."
    fi
done

# Run MultiQC to summarize all FastQC outputs
echo "Running MultiQC..."
multiqc "${results_folder}" -o "${results_folder}" --export

# Done!
echo "All done!"
date

