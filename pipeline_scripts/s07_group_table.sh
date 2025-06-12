#!/bin/bash
# QIIME2: Group by site/treatment 
# Kerry Hathway June2025
# Groups feature table to site/treatment level and generates visualisations
# Assumes metadata has been collapsed to site/treatment level for visualisation step

module load CONDA/qiime2-amplicon-2024.5

# Start message
echo "QIIME2 Grouping by site/treatment"
date
echo ""

# Folders
ungrouped_table=$1
metadata_file=$2
group_col=$3
out_dir=$4
agg_metadata=$5

# Group by desired metadata column
qiime feature-table group \
  --i-table "${ungrouped_table}" \
  --m-metadata-file "${metadata_file}" \
  --m-metadata-column "${group_col}" \
  --p-mode median-ceiling \
  --p-axis sample \
  --o-grouped-table "${out_dir}/s07_grouped_table.qza"

# Assumes collapsed metadata file is available

# Summarize grouped table
qiime feature-table summarize \
  --i-table "${out_dir}/s07_grouped_table.qza" \
  --o-visualization "${out_dir}/s07_grouped_table.qzv" \
  --m-sample-metadata-file "${agg_metadata}"
