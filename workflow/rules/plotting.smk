rule mapping_rates_plot:
    input:
        expand("logs/salmon_quant/{sample}.log", sample=SAMPLES)
    output:
        "results/plots/mapping_rates.pdf"
    params:
        "salmon",
    conda:
        "envs/deseq2.yml"
    log:
        "logs/plots/mapping_rates.log"
    script:
        "scripts/mapping_rates.R"


rule pca_plot:
    input:
        "results/deseq2/dds.RData",
    output:
        "results/plots/pca.pdf",
    conda:
        "../envs/deseq2.yml"
    threads: config["resources"]["plotting"]["cpu"]
    resources:
        runtime=config["resources"]["plotting"]["time"]
    log:
        "logs/plots/pca.log"
    script:
        "../scripts/pca.R"


rule heatmap_sample_distance:
    input:
        "results/deseq2/dds.RData",
    output:
        "results/plots/sample_distance.pdf",
    conda:
        "../envs/deseq2.yml"
    threads: config["resources"]["plotting"]["cpu"]
    resources:
        runtime=config["resources"]["plotting"]["time"]
    log:
        "logs/plots/sample_distance.log"
    script:
        "../scripts/heatmap_sd.R"


rule volcano_plot:
    input:
        genes="results/deseq2/deseq2_genes.xlsx",
        te="results/deseq2/deseq2_te.xlsx",
    output:
        genes=directory("results/plots/volcano_genes/"),
        te=directory("results/plots/volcano_te/"),
    params:
        fdr=config["fdr_cutoff"],
        fc=config["fc_cutoff"]
    conda:
        "../envs/deseq2.yml"
    threads: config["resources"]["plotting"]["cpu"]
    resources:
        runtime=config["resources"]["plotting"]["time"]
    log:
        "logs/plots/volcano.log"
    script:
        "../scripts/volcano.R"   