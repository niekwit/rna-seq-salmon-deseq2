rule salmon_decoy:
    input:
        transcriptome="resources/transcriptome.fasta.gz",
        genome="genome.fasta.gz",
    output:
        gentrome="gentrome.fasta.gz",
        decoys="resources/decoys.txt",
    threads: 2
    log:
        "logs/decoys.log"
    wrapper:
        "v2.6.0/bio/salmon/decoys"


rule salmon_index:
    input:
        sequences="resources/transcriptome.fasta",
        decoys="resources/decoys.txt",
    output:
        temp(multiext(
            "resources/transcriptome_index/",
            "complete_ref_lens.bin",
            "ctable.bin",
            "ctg_offsets.bin",
            "duplicate_clusters.tsv",
            "info.json",
            "mphf.bin",
            "pos.bin",
            "pre_indexing.log",
            "rank.bin",
            "refAccumLengths.bin",
            "ref_indexing.log",
            "reflengths.bin",
            "refseq.bin",
            "seq.bin",
            "versionInfo.json",
        )),
    log:
        "logs/salmon_index/index.log",
    threads: config["resources"]["mapping"]["cpu"],
    params:
        # optional parameters
        extra=config["salmon"]["extra_params"],
    wrapper:
        "v2.6.0/bio/salmon/index"


rule salmon_quant:
    input:
        # If you have multiple fastq files for a single sample (e.g. technical replicates)
        # use a list for r1 and r2.
        r1="results/trimmed/{sample}_val_1.fq.gz",
        r2="results/trimmed/{sample}_val_2.fq.gz",
        index="resources/transcriptome_index",
    output:
        quant="results/salmon/{sample}/quant.sf",
        lib="results/salmon/{sample}/lib_format_counts.json",
    log:
        "logs/salmon_quant/{sample}.log",
    params:
        # optional parameters
        libtype="A", # automatic detection of library type
        extra="",
    threads: config["resources"]["mapping"]["cpu"],
    wrapper:
        "v2.6.0/bio/salmon/quant"


