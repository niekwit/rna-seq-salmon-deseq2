FROM condaforge/miniforge3:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="8f54589010414e54588a294b41754f904eba0f1ff3387a5da00ac6c84fb81194"

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
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v5.9.0/bio/salmon/decoys/environment.yaml
#   prefix: /conda-envs/83e42843fbc76bf43674b2022b993bb2
#   channels:
#     - conda-forge
#     - nodefaults
#   dependencies:
#     - bzip2 =1.0.8
#     - gzip =1.13
RUN mkdir -p /conda-envs/83e42843fbc76bf43674b2022b993bb2
ADD https://github.com/snakemake/snakemake-wrappers/raw/v5.9.0/bio/salmon/decoys/environment.yaml /conda-envs/83e42843fbc76bf43674b2022b993bb2/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v5.9.0/bio/salmon/index/environment.yaml
#   prefix: /conda-envs/2011d71a9562d9a905bb95c6b546141c
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - salmon =1.10.3
RUN mkdir -p /conda-envs/2011d71a9562d9a905bb95c6b546141c
ADD https://github.com/snakemake/snakemake-wrappers/raw/v5.9.0/bio/salmon/index/environment.yaml /conda-envs/2011d71a9562d9a905bb95c6b546141c/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v5.9.0/bio/salmon/quant/environment.yaml
#   prefix: /conda-envs/9805e9e9b1e30e40480f1859d4dc652e
#   channels:
#     - bioconda
#     - conda-forge
#     - nodefaults
#   dependencies:
#     - salmon =1.10.3
#     - gzip =1.13
#     - bzip2 =1.0.8
RUN mkdir -p /conda-envs/9805e9e9b1e30e40480f1859d4dc652e
ADD https://github.com/snakemake/snakemake-wrappers/raw/v5.9.0/bio/salmon/quant/environment.yaml /conda-envs/9805e9e9b1e30e40480f1859d4dc652e/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v5.9.0/bio/trim_galore/pe/environment.yaml
#   prefix: /conda-envs/975a4a78cc02737b050b54b2645b9ecc
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - trim-galore =0.6.10
RUN mkdir -p /conda-envs/975a4a78cc02737b050b54b2645b9ecc
ADD https://github.com/snakemake/snakemake-wrappers/raw/v5.9.0/bio/trim_galore/pe/environment.yaml /conda-envs/975a4a78cc02737b050b54b2645b9ecc/environment.yaml

# Conda environment:
#   source: workflow/envs/deseq2.yml
#   prefix: /conda-envs/3da416eb407c3b71fca6864db70af3f3
#   name: deseq2
#   channels: 
#     - conda-forge
#     - bioconda
#     - defaults
#   dependencies:
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
RUN mkdir -p /conda-envs/3da416eb407c3b71fca6864db70af3f3
COPY workflow/envs/deseq2.yml /conda-envs/3da416eb407c3b71fca6864db70af3f3/environment.yaml

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

# Step 3: Generate conda environments

RUN conda env create --prefix /conda-envs/24b8923f8e4abe077ffe95b01bfc1652 --file /conda-envs/24b8923f8e4abe077ffe95b01bfc1652/environment.yaml && \
    conda env create --prefix /conda-envs/83e42843fbc76bf43674b2022b993bb2 --file /conda-envs/83e42843fbc76bf43674b2022b993bb2/environment.yaml && \
    conda env create --prefix /conda-envs/2011d71a9562d9a905bb95c6b546141c --file /conda-envs/2011d71a9562d9a905bb95c6b546141c/environment.yaml && \
    conda env create --prefix /conda-envs/9805e9e9b1e30e40480f1859d4dc652e --file /conda-envs/9805e9e9b1e30e40480f1859d4dc652e/environment.yaml && \
    conda env create --prefix /conda-envs/975a4a78cc02737b050b54b2645b9ecc --file /conda-envs/975a4a78cc02737b050b54b2645b9ecc/environment.yaml && \
    conda env create --prefix /conda-envs/3da416eb407c3b71fca6864db70af3f3 --file /conda-envs/3da416eb407c3b71fca6864db70af3f3/environment.yaml && \
    conda env create --prefix /conda-envs/e5d9fbb7bf25e32fd9c4c7d06bdf9507 --file /conda-envs/e5d9fbb7bf25e32fd9c4c7d06bdf9507/environment.yaml && \
    conda clean --all -y