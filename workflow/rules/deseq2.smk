rule deseq2:
    input:
        salmon=expand("results/salmon/{sample}/quant.sf", sample=SAMPLES),
        gtf=resources.gtf,
    output:
        csv=report(expand("results/deseq2/{comparison}.csv", comparison=COMPARISONS), caption="../report/deseq2.rst", category="Differential Expression Analysis"),
        rdata="results/deseq2/dds.RData"
    params:
        genome=resources.genome,
        design=config["deseq2"]["design"],      
    threads: config["resources"]["deseq2"]["cpu"]
    resources:
        runtime=config["resources"]["deseq2"]["time"]
    conda:
        "../envs/deseq2.yml"
    log:
        "logs/deseq2/deseq2.log"
    script:
        "../scripts/deseq2.R"

