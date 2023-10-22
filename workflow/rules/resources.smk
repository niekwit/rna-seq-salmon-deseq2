rule get_genome_fasta:
    output:
        ensure(resources.gencode_fasta, sha256=resources.gencode_fa_sha256)
    retries: 3
    params:
        url=resources.gencode_fa_url,
    log:
        "logs/resources/get_gencode_fasta.log"
    conda:
        "../envs/mapping.yml"
    shell:
        "wget -q {params.url} -O {output}.gz && gunzip -f {output}.gz 2> {log}"


rule get_transcriptome_fasta:
    output:
        ensure(resources.gencode_trx_fasta, sha256=resources.gencode_trx_fa_sha256)
    retries: 3
    params:
        url=gencode_trx_fa_url,
    log:
        "logs/resources/get_transcriptome_fasta.log"
    conda:
        "../envs/mapping.yml"
    shell:
        "wget -q {params.url} -O {output}.gz && gunzip -f {output}.gz 2> {log}"


rule get_gencode_gtf:
    output:
        ensure(resources.gencode_gtf, sha256=resources.gencode_gtf_sha256)
    retries: 3
    params:
        url=resources.gencode_gtf_url,
    log:
        "logs/resources/get_gencode_gtf.log"
    conda:
        "../envs/mapping.yml"
    shell:
        "wget -q {params.url} -O {output}.gz && gunzip -f {output}.gz 2> {log}"


