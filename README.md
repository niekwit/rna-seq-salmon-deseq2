# Snakemake workflow: `rna-seq-salmon-deseq2`

[![Snakemake](https://img.shields.io/badge/snakemake-≥8.25.5-brightgreen.svg)](https://snakemake.github.io)
[![Tests](https://github.com/niekwit/rna-seq-salmon-deseq2/actions/workflows/main.yml/badge.svg)](https://github.com/niekwit/rna-seq-salmon-deseq2/actions/workflows/main.yml)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10139567.svg)](https://doi.org/10.5281/zenodo.10139567)

A Snakemake workflow for wicked-fast paired-end RNA-seq analysis with Salmon and DESeq2.

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) repository and its DOI (see above).

## Software dependencies

- [Mamba](https://mamba.readthedocs.io/en/stable/installation/mamba-installation.html)
- [Snakemake > 8.25.5](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html)
- [Apptainer](https://apptainer.org/docs/admin/main/installation.html)

## Usage

### Preparing data and code

Create a main analysis directory with the subdirectories config/, reads/, and workflow/.

Place all your paired-end fastq files files in the reads folder. These should have the extensions \_R1_001.fastq.gz/\_R2_001.fastq.gz for read 1 and read2, respectively.

The config/ directory should contain two files: config.yml and samples.csv.

Meta information of the samples are described in samples.csv:

| sample            | genotype | treatment | reference | batch |
| ----------------- | -------- | --------- | --------- | ----- |
| Control_1         | WT       | Normoxia  | yes       | 1     |
| Control_2         | WT       | Normoxia  | yes       | 1     |
| Control_Hypoxia_1 | WT       | Hypoxia   | no        | 1     |
| Control_Hypoxia_2 | WT       | Hypoxia   | no        | 1     |

> [!IMPORTANT]
> The sample names should correspond to the files name, eg. Control_1_R1_001.fastq.gz and Control_1_R2_001.fastq.gz for sample Control_1.

The `batch` column is optional; if omitted, all samples are treated as a single batch. At least one sample per genotype/treatment group being compared must have `reference` set to `yes` — this defines the control/reference level(s) used to build the pairwise comparisons for DESeq2 and the volcano plots.

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
  # level(s) at which to perform differential expression analysis
  # each entry produces its own set of outputs (results/deseq2/<level>/...), so
  # both can be run side by side without overwriting one another
  levels: ["gene", "transcript"]
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

`genome`/`gencode_genome_build` select which Ensembl/Gencode reference is downloaded automatically; `deseq2.design` can be left empty to use the default `~comb` (or `~batch + comb`, if a `batch` column is present) design, or set to a custom R formula referencing the `samples.csv` columns. `deseq2.levels` controls whether differential expression is run at the gene level, the transcript level, or both — set it to `["gene"]`, `["transcript"]`, or `["gene", "transcript"]`.

### Running the workflow

From the main analysis directory (the one containing `config/`, `reads/`, and `workflow/`), first do a dry run to check that the config and sample sheet are valid and to see which jobs would run:

```shell
snakemake -n
```

Then run the workflow for real. Reference genome/transcriptome/GTF files are downloaded automatically based on `genome`/`gencode_genome_build`, so no extra setup is needed there.

- **Recommended**: use the prebuilt container (see [Software dependencies](#software-dependencies)), which already has every rule's Conda environment baked in, so no environments need to be solved/built locally:

  ```shell
  snakemake --cores <N> --software-deployment-method apptainer conda
  ```

- **Alternative**: build the Conda environments locally (no Apptainer required), as done in this workflow's CI:

  ```shell
  snakemake --cores <N> --software-deployment-method conda
  ```

Replace `<N>` with the number of CPU cores to make available; individual rules will be scaled down to `<N>` if they request more threads than that.

Once finished, an HTML summary report (including QC metrics, PCA/sample-distance plots, and volcano plots) can be generated with:

```shell
snakemake --report report.zip
```

#### Output

Results are written to `results/`, notably:

- `results/qc/multiqc/multiqc.html` – aggregated QC report
- `results/salmon/{sample}/quant.sf` – per-sample Salmon quantifications
- `results/deseq2/{level}/{comparison}.csv` – DESeq2 results per pairwise comparison, for each configured `level` (`gene` and/or `transcript`)
- `results/plots/{level}/pca.pdf`, `results/plots/{level}/sample_distance.pdf`, `results/plots/mapping_rates.pdf`, `results/plots/mapping_rates.csv`
- `results/plots/volcano/{level}/{comparison}.pdf` – volcano plot per comparison

### NGS Tracker integration (optional)

This workflow can automatically register each run with [NGS Tracker](https://github.com/niekwit/ngs-tracker) and attach key output files to it, via the `ngs_tracker` block in `config.yml`:

```yaml
ngs_tracker:
  enabled: false # set to false to skip registration

  # Connection
  base_url: "http://127.0.0.1:5000/api" # change host/port if needed

  # Run identity  (find project_id on the project detail page)
  project_id: 3
  #run_id: 1 # optional, if not provided a new run will be created
  workflow_name: "rna-seq-salmon-deseq2"
  workflow_tag: "v0.7.5"
  workflow_system: "snakemake" # snakemake | nextflow | cwl | other
  description: "ENTER YOUR TEXT HERE"
  tags:
    - Test

  # Files to attach — paths relative to the working directory or absolute
  # type: config | sample_info | qc | results | mapping_rates | snakemake_log | other
  files:
    - path: "config/config.yml"
      type: config
      description: "Workflow config"
    - path: "results/qc/multiqc/multiqc.html"
      type: qc
      description: "MultiQC report"
    - path: "results/plots/mapping_rates.csv"
      type: mapping_rates
      description: "Salmon mapping rates"
    - path: "results/plots/*/*.pdf"
      type: qc
    - path: logs/snakemake/*.log
      type: snakemake_log
```

| Field | Description |
| --- | --- |
| `enabled` | Set to `false` to skip NGS Tracker entirely — nothing is registered and no network call is made. |
| `base_url` | URL of your NGS Tracker API instance. |
| `project_id` | ID of the NGS Tracker project to register the run under (shown on the project's detail page). |
| `run_id` | Optional; if omitted, a new run is created for each workflow execution. |
| `workflow_name` / `workflow_tag` / `workflow_system` | Metadata identifying this workflow and version in NGS Tracker. |
| `description` / `tags` | Free-text description and tags attached to the run. |
| `files` | Output files to attach to the run once it finishes. Glob patterns (e.g. `results/plots/*/*.pdf`) are supported. Each entry needs a `path` and `type` (`config`, `sample_info`, `qc`, `results`, `mapping_rates`, `snakemake_log`, or `other`), plus an optional `description`. |

Registration happens automatically from the workflow's `onsuccess`/`onerror` hooks: on success the run is marked complete with the listed files attached; on failure it's marked failed and the Snakemake log is attached instead. If the `ngs_tracker` Python package isn't installed, registration is silently skipped (a warning is logged rather than failing the workflow), so this feature is inert until you install and configure it.
