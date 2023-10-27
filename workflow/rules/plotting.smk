rule mapping_rates_plot:
    input:
        expand("logs/salmon/quant-{sample}.log", sample=SAMPLES)
    output:
        report("results/plots/mapping_rates.pdf", caption="report/mapping_rates.rst", category="Mapping rates")
    params:
        "salmon",
    conda:
        "../envs/deseq2.yml"
    log:
        "logs/plots/mapping_rates.log"
    script:
        "../scripts/mapping_rates.R"


rule pca_plot:
    input:
        "results/deseq2/dds.RData",
    output:
        report("results/plots/pca.pdf", caption="report/pca.rst", category="PCA"),
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
        report("results/plots/sample_distance.pdf", caption="report/sample_distance.rst", category="Sample distances"),
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
        xlsx="results/deseq2/deseq2.xlsx",
    output:
        report(directory("results/plots/volcano"), caption="report/volcano.rst", category="Volcano plots"),
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