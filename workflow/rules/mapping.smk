rule salmon_quant:
    input:
        r1="results/trimmed/{sample}_R1.fq.gz",
        r2="results/trimmed/{sample}_R2.fq.gz",
        index=f"resources/{resources.genome}_{resources.build}_transcriptome_index/",
        idxfiles=multiext(
            f"resources/{resources.genome}_{resources.build}_transcriptome_index/",
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
    resources:
        runtime=config["resources"]["mapping"]["time"],
    wrapper:
        "v3.3.6/bio/salmon/quant"


