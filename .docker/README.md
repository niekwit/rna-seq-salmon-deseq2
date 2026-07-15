# Dockerfiles for each version (>= v0.7.0)

This directory contains Dockerfiles associated with each release.

The Docker image derived from this file contains all Conda environments for each rule, i.e. the whole workflow is run in one image.

These images are shared via [Docker Hub](https://hub.docker.com/repository/docker/niekwit/rna-seq-salmon-deseq2/general) and are generated as follows (from directory with workflow code):

```shell
snakemake --containerize > Dockerfile
docker build -t niekwit/rna-seq-salmon-deseq2:v0.8.0 .
docker login
docker push niekwit/rna-seq-salmon-deseq2:v0.8.0
```

> [!NOTE]
> Because `conda env create` runs at image-build time, each Conda environment gets whatever is the *current* highest build number on bioconda/conda-forge at that moment — package versions are pinned in the `envs/*.yml`/wrapper files, but package **builds** are not. This occasionally matters: bioconda briefly published a `trim-galore=2.2.0` build (`h9ee0642_0`) that was linked against a newer glibc than older host systems (e.g. Ubuntu 20.04, glibc 2.31) provide, causing `GLIBC_2.32/2.33/2.34 not found` errors. This was fixed upstream by a later build (`hf1b6044_1`, glibc ≤2.16), so simply rebuilding the image (or clearing a locally cached `.snakemake/conda/<hash>` env and letting it re-resolve) picks up the fix. If a similar issue ever recurs and needs a durable fix rather than a rebuild, pin the exact working build string (e.g. `trim-galore=2.2.0=hf1b6044_1`) in the relevant environment file.
