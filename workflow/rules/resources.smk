rule get_genome_fasta:
    output:
        resources.fasta,
    retries: 3
    params:
        url=resources.fa_url,
    log:
        "logs/resources/get_genome_fasta.log"
    threads: 1
    resources: 
        runtime=15
    conda:
        "../envs/resources.yaml"
    script:
        "../scripts/get_resource.sh"


use rule get_fasta as get_trx_fasta with:
        output:
            resources.trx_fasta,
        params:
            url=resources.trx_fa_url,
        log:
            "logs/resources/get_gtf.log"


use rule get_fasta as get_gtf with:
        output:
            resources.gtf,
        params:
            url=resources.gtf_url,
        log:
            "logs/resources/get_gtf.log"


rule salmon_decoy:
    input:
        transcriptome=resources.gencode_trx_fasta,
        genome=resources.gencode_fasta,
    output:
        gentrome=temp("resources/gentrome.fasta"),
        decoys="resources/decoys.txt",
    threads: config["resources"]["mapping"]["cpu"]
    log:
        "logs/salmon/decoys.log"
    wrapper:
        "v3.3.6/bio/salmon/decoys"


rule salmon_index:
    input:
        sequences="resources/gentrome.fasta",
        decoys="resources/decoys.txt",
    output:
        multiext(
            f"resources/transcriptome_index_{resources.genome}_{recources.build}",
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
        directory(f"resources/transcriptome_index_{resources.genome}_{recources.build}"),
    cache: True
    log:
        f"logs/salmon/index_{resources.genome}_{recources.build}.log",
    threads: config["resources"]["mapping"]["cpu"]
    params:
        # optional parameters
        extra=config["salmon-index"]["extra_params"],
    wrapper:
        "v3.3.6/bio/salmon/index"