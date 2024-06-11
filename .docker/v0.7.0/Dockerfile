FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="c640e836d0014ff13323253b1efe636acdc33f7708db803896fb083e161c5f5f"

# Step 1: Retrieve conda environments

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.12.0/bio/fastqc/environment.yaml
#   prefix: /conda-envs/90ea9a0a5f4de478eb6aa43932774175
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - fastqc =0.12.1
#     - snakemake-wrapper-utils =0.6.2
RUN mkdir -p /conda-envs/90ea9a0a5f4de478eb6aa43932774175
ADD https://github.com/snakemake/snakemake-wrappers/raw/v3.12.0/bio/fastqc/environment.yaml /conda-envs/90ea9a0a5f4de478eb6aa43932774175/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.12.0/bio/salmon/decoys/environment.yaml
#   prefix: /conda-envs/8456381e797f1c0d40a30d5587f38aeb
#   channels:
#     - conda-forge
#     - nodefaults
#   dependencies:
#     - bzip2 =1.0.8
#     - gzip =1.13
RUN mkdir -p /conda-envs/8456381e797f1c0d40a30d5587f38aeb
ADD https://github.com/snakemake/snakemake-wrappers/raw/v3.12.0/bio/salmon/decoys/environment.yaml /conda-envs/8456381e797f1c0d40a30d5587f38aeb/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.12.0/bio/salmon/index/environment.yaml
#   prefix: /conda-envs/e4a3325e8ed88fd69ecfc27669ef70eb
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - salmon =1.10.3
RUN mkdir -p /conda-envs/e4a3325e8ed88fd69ecfc27669ef70eb
ADD https://github.com/snakemake/snakemake-wrappers/raw/v3.12.0/bio/salmon/index/environment.yaml /conda-envs/e4a3325e8ed88fd69ecfc27669ef70eb/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.12.0/bio/salmon/quant/environment.yaml
#   prefix: /conda-envs/1193c2e35bb44028f63ef3ca20567daa
#   channels:
#     - bioconda
#     - conda-forge
#     - nodefaults
#   dependencies:
#     - salmon =1.10.3
#     - gzip =1.13
#     - bzip2 =1.0.8
RUN mkdir -p /conda-envs/1193c2e35bb44028f63ef3ca20567daa
ADD https://github.com/snakemake/snakemake-wrappers/raw/v3.12.0/bio/salmon/quant/environment.yaml /conda-envs/1193c2e35bb44028f63ef3ca20567daa/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.12.0/bio/trim_galore/pe/environment.yaml
#   prefix: /conda-envs/7c8f9db6001702ef40e5b666df2ea0f5
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - trim-galore =0.6.10
RUN mkdir -p /conda-envs/7c8f9db6001702ef40e5b666df2ea0f5
ADD https://github.com/snakemake/snakemake-wrappers/raw/v3.12.0/bio/trim_galore/pe/environment.yaml /conda-envs/7c8f9db6001702ef40e5b666df2ea0f5/environment.yaml

# Conda environment:
#   source: workflow/envs/deseq2.yml
#   prefix: /conda-envs/d979651088006f3fb08a629a8ebd8bdf
#   name: deseq2
#   channels: 
#     - conda-forge
#     - bioconda
#     - defaults
#   dependencies:
#     - r-base=4.2
#     - r-rcolorbrewer=1.1_3
#     - r-dplyr=1.1.2
#     - r-pheatmap=1.0.12
#     - r-stringr=1.5.0
#     - r-ggplot2=3.4.2
#     - r-cowplot=1.1.1
#     - r-readr=2.1.4
#     - r-readxl=1.4.2
#     - r-openxlsx=4.2.5
#     - r-foreach=1.5.2
#     - r-ggrepel=0.9.3
#     - bioconductor-deseq2=1.38.0
#     - bioconductor-genomicfeatures=1.50.2
#     - bioconductor-tximport=1.26.0
#     - r-ggfortify=0.4.16
#     - bioconductor-limma=3.54.0
#     - bioconductor-rtracklayer=1.58.0
RUN mkdir -p /conda-envs/d979651088006f3fb08a629a8ebd8bdf
COPY workflow/envs/deseq2.yml /conda-envs/d979651088006f3fb08a629a8ebd8bdf/environment.yaml

# Conda environment:
#   source: workflow/envs/resources.yml
#   prefix: /conda-envs/e5d9fbb7bf25e32fd9c4c7d06bdf9507
#   name: deseq2
#   channels: 
#     - conda-forge
#     - bioconda
#     - defaults
#   dependencies:
#     - python=3.11
#     - multiqc=1.20
#     - pigz=2.8
#     - salmon=1.10.2
RUN mkdir -p /conda-envs/e5d9fbb7bf25e32fd9c4c7d06bdf9507
COPY workflow/envs/resources.yml /conda-envs/e5d9fbb7bf25e32fd9c4c7d06bdf9507/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/90ea9a0a5f4de478eb6aa43932774175 --file /conda-envs/90ea9a0a5f4de478eb6aa43932774175/environment.yaml && \
    mamba env create --prefix /conda-envs/8456381e797f1c0d40a30d5587f38aeb --file /conda-envs/8456381e797f1c0d40a30d5587f38aeb/environment.yaml && \
    mamba env create --prefix /conda-envs/e4a3325e8ed88fd69ecfc27669ef70eb --file /conda-envs/e4a3325e8ed88fd69ecfc27669ef70eb/environment.yaml && \
    mamba env create --prefix /conda-envs/1193c2e35bb44028f63ef3ca20567daa --file /conda-envs/1193c2e35bb44028f63ef3ca20567daa/environment.yaml && \
    mamba env create --prefix /conda-envs/7c8f9db6001702ef40e5b666df2ea0f5 --file /conda-envs/7c8f9db6001702ef40e5b666df2ea0f5/environment.yaml && \
    mamba env create --prefix /conda-envs/d979651088006f3fb08a629a8ebd8bdf --file /conda-envs/d979651088006f3fb08a629a8ebd8bdf/environment.yaml && \
    mamba env create --prefix /conda-envs/e5d9fbb7bf25e32fd9c4c7d06bdf9507 --file /conda-envs/e5d9fbb7bf25e32fd9c4c7d06bdf9507/environment.yaml && \
    mamba clean --all -y
