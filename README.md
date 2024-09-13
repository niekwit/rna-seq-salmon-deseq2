# Snakemake workflow: `rna-seq-salmon-deseq2`

[![Snakemake](https://img.shields.io/badge/snakemake-≥8.13.0-brightgreen.svg)](https://snakemake.github.io)
[![Tests](https://github.com/niekwit/rna-seq-salmon-deseq2/actions/workflows/main.yml/badge.svg)](https://github.com/niekwit/rna-seq-salmon-deseq2/actions/workflows/main.yml)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10139567.svg)](https://doi.org/10.5281/zenodo.10139567)


A Snakemake workflow for wicked-fast paired-end RNA-seq analysis with Salmon and DESeq2.

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) repository and its DOI (see above).

## Software dependencies

* [Mamba](https://mamba.readthedocs.io/en/stable/installation/mamba-installation.html)
* [Snakemake > 8.13](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html)
* [Apptainer](https://apptainer.org/docs/admin/main/installation.html)


## Usage

### Preparing data and code

Create a main analysis directory with the subdirectories config/, reads/, and workflow/. 

Place all your paired-end fastq files files in the reads folder. These should have the extensions _R1_001.fastq.gz/_R2_001.fastq.gz for read 1 and read2, respectively.

The config/ directory should contain two files: config.yml and samples.csv.

Meta information of the samples are described in samples.csv:

|sample|genotype   |treatment  |reference |batch  |
|------|-----------|-----------|----------|-------|
|Control_1|WT|Normoxia|yes|1|
|Control_2|WT|Normoxia|yes|1|
|Control_Hypoxia_1|WT|Hypoxia|no|1|
|Control_Hypoxia_2|WT|Hypoxia|no|1|

> [!IMPORTANT]
> The sample names should correspond to the files name, eg. Control_1_R1_001.fastq.gz and Control_1_R2_001.fastqz for sample Control_1.

Analysis settings and resource

```yaml
genome: human # human or mouse
gencode_genome_build: 44
fdr_cutoff: 0.05 # adj p value cut off for volcano plots
fc_cutoff: 0.5 # log2 fold change cut off for volcano plots
salmon-quant: 
  extra_params: "" # additional arguments to pass to Salmon
salmon-index:
  extra_params: "--gencode"
deseq2:
  # custom model for DESeq2
  design: "" 
resources: # computing resources
  trim:
    cpu: 8
    time: 60
  fastqc:
    cpu: 4
    time: 60
  mapping:
    cpu: 8
    time: 120
  deseq2:
    cpu: 6
    time: 60 
  plotting:
    cpu: 2
    time: 20
```