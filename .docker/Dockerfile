FROM condaforge/miniforge3:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="4bcecb791f6d5a20d907b68406dcd84eb3e2ff63739d49e738e23960ebce62c8"

# Step 2: Retrieve conda environments

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v5.9.0/bio/fastqc/environment.yaml
#   prefix: /conda-envs/24b8923f8e4abe077ffe95b01bfc1652
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - fastqc =0.12.1
#     - snakemake-wrapper-utils =0.6.2
RUN mkdir -p /conda-envs/24b8923f8e4abe077ffe95b01bfc1652
ADD https://github.com/snakemake/snakemake-wrappers/raw/v5.9.0/bio/fastqc/environment.yaml /conda-envs/24b8923f8e4abe077ffe95b01bfc1652/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v6.0.0/bio/salmon/decoys/environment.yaml
#   prefix: /conda-envs/847d07fb3c14fbb073983231e38653b8
#   channels:
#     - conda-forge
#     - nodefaults
#   dependencies:
#     - bzip2 =1.0.8
#     - gzip =1.14
RUN mkdir -p /conda-envs/847d07fb3c14fbb073983231e38653b8
ADD https://github.com/snakemake/snakemake-wrappers/raw/v6.0.0/bio/salmon/decoys/environment.yaml /conda-envs/847d07fb3c14fbb073983231e38653b8/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v9.12.0/bio/salmon/index/environment.yaml
#   prefix: /conda-envs/04c2e78821241656fde467b5d62a26bd
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - salmon =2.1.2
RUN mkdir -p /conda-envs/04c2e78821241656fde467b5d62a26bd
ADD https://github.com/snakemake/snakemake-wrappers/raw/v9.12.0/bio/salmon/index/environment.yaml /conda-envs/04c2e78821241656fde467b5d62a26bd/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v9.13.0/bio/salmon/quant/environment.yaml
#   prefix: /conda-envs/0215b3c4a253ad28850dd0a9729a5bbf
#   channels:
#     - bioconda
#     - conda-forge
#     - nodefaults
#   dependencies:
#     - salmon =2.1.2
#     - gzip =1.14
#     - bzip2 =1.0.8
RUN mkdir -p /conda-envs/0215b3c4a253ad28850dd0a9729a5bbf
ADD https://github.com/snakemake/snakemake-wrappers/raw/v9.13.0/bio/salmon/quant/environment.yaml /conda-envs/0215b3c4a253ad28850dd0a9729a5bbf/environment.yaml

# Conda environment:
#   source: workflow/envs/deseq2.yml
#   prefix: /conda-envs/d9413308a4a8608d70128afdc7ad9857
#   name: deseq2
#   channels:
#     - conda-forge
#     - bioconda
#   dependencies:
#     - jq
#     - r-base=4.4
#     - r-tidyverse=2.0.0
#     - r-rcolorbrewer=1.1_3
#     - r-pheatmap=1.0.12
#     - r-cowplot=1.1.3
#     - r-foreach=1.5.2
#     - r-ggrepel=0.9.6
#     - bioconductor-deseq2=1.46.0
#     - bioconductor-genomicfeatures=1.58.0
#     - bioconductor-tximport=1.34.0
#     - r-ggfortify=0.4.17
#     - bioconductor-limma=3.62.1
#     - bioconductor-rtracklayer=1.66.0
#     - bioconductor-txdbmaker=1.2.0
RUN mkdir -p /conda-envs/d9413308a4a8608d70128afdc7ad9857
COPY workflow/envs/deseq2.yml /conda-envs/d9413308a4a8608d70128afdc7ad9857/environment.yaml

# Conda environment:
#   source: workflow/envs/resources.yml
#   prefix: /conda-envs/6710eb064b2497f0643f566f521a2825
#   name: deseq2
#   channels:
#     - conda-forge
#     - bioconda
#   dependencies:
#     - python=3.11
#     - multiqc=1.26
#     - pigz=2.8
RUN mkdir -p /conda-envs/6710eb064b2497f0643f566f521a2825
COPY workflow/envs/resources.yml /conda-envs/6710eb064b2497f0643f566f521a2825/environment.yaml

# Conda environment:
#   source: workflow/envs/trim_galore.yml
#   prefix: /conda-envs/f25143b31d35300a2e0f8a6febf76392
#   name: trim_galore
#   channels:
#     - conda-forge
#     - bioconda
#     - defaults
#   dependencies:
#     # Pinned to this exact build: build h9ee0642_0 was linked against a newer
#     # glibc than older hosts (e.g. Ubuntu 20.04, glibc 2.31) provide, causing
#     # `GLIBC_2.32/2.33/2.34 not found` errors. hf1b6044_1 fixes this (glibc <=2.16).
#     - trim-galore=2.2.0=hf1b6044_1
RUN mkdir -p /conda-envs/f25143b31d35300a2e0f8a6febf76392
COPY workflow/envs/trim_galore.yml /conda-envs/f25143b31d35300a2e0f8a6febf76392/environment.yaml

# Step 3: Generate conda environments

RUN conda env create --prefix /conda-envs/24b8923f8e4abe077ffe95b01bfc1652 --file /conda-envs/24b8923f8e4abe077ffe95b01bfc1652/environment.yaml && \
    conda env create --prefix /conda-envs/847d07fb3c14fbb073983231e38653b8 --file /conda-envs/847d07fb3c14fbb073983231e38653b8/environment.yaml && \
    conda env create --prefix /conda-envs/04c2e78821241656fde467b5d62a26bd --file /conda-envs/04c2e78821241656fde467b5d62a26bd/environment.yaml && \
    conda env create --prefix /conda-envs/0215b3c4a253ad28850dd0a9729a5bbf --file /conda-envs/0215b3c4a253ad28850dd0a9729a5bbf/environment.yaml && \
    conda env create --prefix /conda-envs/d9413308a4a8608d70128afdc7ad9857 --file /conda-envs/d9413308a4a8608d70128afdc7ad9857/environment.yaml && \
    conda env create --prefix /conda-envs/6710eb064b2497f0643f566f521a2825 --file /conda-envs/6710eb064b2497f0643f566f521a2825/environment.yaml && \
    conda env create --prefix /conda-envs/f25143b31d35300a2e0f8a6febf76392 --file /conda-envs/f25143b31d35300a2e0f8a6febf76392/environment.yaml && \
    conda clean --all -y