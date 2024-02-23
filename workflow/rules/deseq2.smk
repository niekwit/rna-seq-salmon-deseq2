rule deseq2:
    input:
        salmon=expand("results/salmon/{sample}/quant.sf", sample=SAMPLES),
        gtf=resources.gtf,
    retries: 5 #bioMart sometimes fails to connect
    output:
        xlsx=report("results/deseq2/deseq2.xlsx", caption="report/deseq2.rst", category="Differential Expression Analysis"),
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

