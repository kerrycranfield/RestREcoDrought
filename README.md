# RestREcoDrought

Repository for Cranfield University's MSc Applied Bioinformatics final thesis.

This project investigated the effects of short-term drought on microbial communities in UK grasslands by analysing 16S and ITS amplicon sequences. DNA was obtained from soil samples collected by the <a href="https://restreco.com/">RestREco</a> project.

The main aim of this study was to investigate how diversity, species composition and functional capacity in bacterial and fungal communities in grassland soils respond to changes in soil moisture

Objectives:
- Use bioinformatics tools to analyse amplicon sequencing data to investigate how drought affects diversity, taxonomical composition and functional composition in bacteria and fungi in restored grasslands
- To inform ecological restoration practices for building resilience to environmental change in grasslands
- To place the results in the context of current scientific literature and knowledge around the effects of soil moisture deficits on grassland ecosystem dynamics

This repository contains:
- Scripts from the 16S and ITS pipeline to process amplicon sequencing data as well as carry out functional predictions using PICRUSt2
- R markdown code used to continue the preprocessing started in the pipeline
- R markdown code for diversity, taxonomic composition and functional composition analysis

Diagrams of full workflows:
<img width="758" height="1121" alt="16Sworkflowdrawio" src="https://github.com/user-attachments/assets/011aa5ba-1a2b-4f40-b283-7c35d3c3d556" />
<img width="755" height="1121" alt="ITSworkflow" src="https://github.com/user-attachments/assets/ccfbaca0-7d05-416c-a920-6c6807ee2cac" />

Full results are available here: <a href="https://kerrycranfield.github.io/RestREcoDrought/restrecodrought.html">Processing to diversity</a>, <a href="https://kerrycranfield.github.io/RestREcoDrought/restreco_diff_abund.html">differential abundance</a> and <a href="https://kerrycranfield.github.io/RestREcoDrought/restreco_func.html">functional analysis</a>

## Scripts: 16S and ITS
1. s01_sourcefilesgenerate.sh - generate file containing paths to sequenced data
2. s02_qc.sh - Quality control. Performs quality assessment of reads using FastQC and MultiQC tools
3. b03_q2_import_and_trim.sh (16S) - Trimming adapters using CutAdapt (QIIME2) and further quality checks using demux summarize from QIIME2 
   f03_q2_import_and_display.sh (ITS) - Perform quality checks using demux summarize from QIIME2 (no trimming required)
4. b04_q2_denoise.sh (16S) - Denoising. Merges paired reads, removes sequencing errors and chimeras and generates feature tables
   f04_q2_denoise.sh (ITS) - As for 16S
5. s05_classify_aglom.sh - Taxonomic assignment of sequences using GreenGenes2 for 16S and UNITE 99/dynamic for ITS. Also collapses feature table to desired taxonomic level, but outputs from collapse were not used for this project
6. b06_phylo_tree.sh (16S only) - Generates phylogenetic tree and aligns sequences using QIIME2's phylogeny align-to-tree-mafft-fasttree
7. f06b_filter_table.sh (ITS only) - Filter out samples from feature table that are not in the metadata eg. Harley Farms
8. s10_picrust2.sh (16S) - Functional predictions for bacteria feature table after converting feature table to biom format

## Wrapper scripts
These were to run multiple pipeline scripts at once (for example run 16S and ITS steps together) or for running custom Python scripts
s01_02_wrapper.sh - for use with s01_sourcefilesgenerate.sh and s02_qc.sh
s05_taxa_wrapper.sh - for use with s05_classify_aglom.sh
s06_split_meta_wrapper.sh - for use with Python scripts metadata_tool.py and metadata_collapse.py.

## Python scripts
metadata_tool.py - edits metadata for use in QIIME2. Removed brackets, classified shelter and control samples and created new variable for grouping samples
metadata_collapse.py - aggregated metadata to site-treatment level
funguild_process.py - process melted phyloseq object so all levels of taxonomy classification are in one field for use with FUNGuildR 

For further preprocessing (aggregation, agglomeration, rarefaction), diversity, taxonomy and analysis of PICRUSt2 outputs/FUNGuildR see R markdown documents restrecodrought.Rmd, restreco_dif_abund.Rmd and restreco_func.Rmd.
