rule deseq2:
    input:
        salmon=expand("results/te_count/{sample}.cntTable", sample=SAMPLES),
        gtf=resources.gencode_gtf,
    output:
        xlsx="results/deseq2/deseq2.xlsx",
        rdata="results/deseq2/dds.RData"
    params:
        genome=resources.genome,        
    threads: config["resources"]["deseq2"]["cpu"]
    resources:
        runtime=config["resources"]["deseq2"]["time"]
    conda:
        "../envs/deseq2.yml"
    log:
        "logs/deseq2/deseq2.log"
    script:
        "../scripts/deseq2.R"

