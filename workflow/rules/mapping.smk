rule salmon_quant:
    input:
        r1="results/trimmed/{sample}_R1.fq.gz",
        r2="results/trimmed/{sample}_R2.fq.gz",
        index=multiext(
            f"resources/{resources.genome}_{resources.build}_gentrome_index/",
            "index.ssi",
            "refseq_offsets.json",
            "index.ectab",
            "index.ctab",
            "refseq.bin",
            "index.ssi.mphf",
            "index.refinfo",
            "info.json",
            "duplicate_clusters.tsv",
        ),
    output:
        quant="results/salmon/{sample}/quant.sf",
        lib="results/salmon/{sample}/lib_format_counts.json",
        log="results/salmon/{sample}/logs/salmon_quant.log",
    log:
        "logs/salmon/quant-{sample}.log",
    params:
        # optional parameters
        libtype="A",  # automatic detection of library type
        extra=config["salmon-quant"]["extra_params"],
    threads: config["resources"]["mapping"]["cpu"]
    resources:
        runtime=config["resources"]["mapping"]["time"],
    wrapper:
        "v9.13.0/bio/salmon/quant"
