rule salmon_decoy:
    input:
        transcriptome=resources.gencode_trx_fasta,
        genome=resources.gencode_fasta,
    output:
        gentrome="resources/gentrome.fasta",
        decoys="resources/decoys.txt",
    threads: config["resources"]["mapping"]["cpu"]
    log:
        "logs/salmon/decoys.log"
    wrapper:
        "v2.6.0/bio/salmon/decoys"


rule salmon_index:
    input:
        sequences="resources/gentrome.fasta",
        decoys="resources/decoys.txt",
    output:
        multiext(
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
        ),
        directory("resources/transcriptome_index/"),
    log:
        "logs/salmon/index.log",
    threads: config["resources"]["mapping"]["cpu"]
    params:
        # optional parameters
        extra=config["salmon-index"]["extra_params"],
    wrapper:
        "v2.6.0/bio/salmon/index"


rule salmon_quant:
    input:
        r1="results/trimmed/{sample}_R1.fq.gz",
        r2="results/trimmed/{sample}_R2.fq.gz",
        index="resources/transcriptome_index/",
    output:
        quant="results/salmon/{sample}/quant.sf",
        lib="results/salmon/{sample}/lib_format_counts.json",
    log:
        "logs/salmon/quant-{sample}.log",
    params:
        # optional parameters
        libtype="A", # automatic detection of library type
        extra=config["salmon-quant"]["extra_params"],
    threads: config["resources"]["mapping"]["cpu"],
    wrapper:
        "v2.6.0/bio/salmon/quant"


