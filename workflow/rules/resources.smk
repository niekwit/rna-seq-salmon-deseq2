rule get_genome_fasta:
    output:
        resources.fasta,
    retries: 3
    cache: False
    params:
        url=resources.fa_url,
    log:
        "logs/resources/get_genome_fasta.log"
    threads: 1
    resources: 
        runtime=15
    conda:
        "../envs/resources.yml"
    script:
        "../scripts/get_resource.sh"


use rule get_genome_fasta as get_trx_fasta with:
        output:
            resources.trx_fasta,
        params:
            url=resources.trx_fa_url,
        log:
            "logs/resources/get_gtf.log"


use rule get_genome_fasta as get_gtf with:
        output:
            resources.gtf,
        params:
            url=resources.gtf_url,
        log:
            "logs/resources/get_gtf.log"


rule salmon_decoy:
    input:
        transcriptome=resources.trx_fasta,
        genome=resources.fasta,
    output:
        gentrome=temp("resources/gentrome.fasta"),
        decoys="resources/decoys.txt",
    cache: False
    threads: config["resources"]["mapping"]["cpu"]
    resources: 
        runtime=config["resources"]["mapping"]["time"]
    log:
        "logs/salmon/decoys.log"
    wrapper:
        f"{wrapper_version}/bio/salmon/decoys"


rule salmon_index:
    input:
        sequences="resources/gentrome.fasta",
        decoys="resources/decoys.txt",
    output:
        multiext(
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
    cache: False #https://github.com/snakemake/snakemake/issues/1808
    log:
        "logs/salmon/index.log"
    threads: config["resources"]["mapping"]["cpu"] * 3
    params:
        # optional parameters
        extra=config["salmon-index"]["extra_params"],
    wrapper:
        f"{wrapper_version}/bio/salmon/index"