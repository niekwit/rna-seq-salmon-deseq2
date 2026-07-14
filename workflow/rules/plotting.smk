rule mapping_rates_plot:
    input:
        expand("logs/salmon/quant-{sample}.log", sample=SAMPLES),
    output:
        report(
            "results/plots/mapping_rates.pdf",
            caption="../report/mapping_rates.rst",
            category="Mapping rates",
        ),
        csv="results/plots/mapping_rates.csv",
    log:
        "logs/plots/mapping_rates.log",
    conda:
        "../envs/deseq2.yml"
    threads: config["resources"]["plotting"]["cpu"]
    resources:
        runtime=config["resources"]["plotting"]["time"],
    script:
        "../scripts/mapping_rates.R"


rule pca_plot:
    input:
        dds="results/deseq2/{level}/dds.RData",
    output:
        report(
            "results/plots/{level}/pca.pdf",
            caption="../report/pca.rst",
            category="PCA",
        ),
    log:
        "logs/plots/pca_{level}.log",
    wildcard_constraints:
        level="|".join(LEVELS),
    conda:
        "../envs/deseq2.yml"
    threads: config["resources"]["plotting"]["cpu"]
    resources:
        runtime=config["resources"]["plotting"]["time"],
    script:
        "../scripts/pca.R"


rule heatmap_sample_distance:
    input:
        "results/deseq2/{level}/dds.RData",
    output:
        report(
            "results/plots/{level}/sample_distance.pdf",
            caption="../report/sample_distance.rst",
            category="Sample distances",
        ),
    log:
        "logs/plots/sample_distance_{level}.log",
    wildcard_constraints:
        level="|".join(LEVELS),
    conda:
        "../envs/deseq2.yml"
    threads: config["resources"]["plotting"]["cpu"]
    resources:
        runtime=config["resources"]["plotting"]["time"],
    params:
        genome=resources.genome,
    script:
        "../scripts/heatmap_sd.R"


rule volcano_plot:
    input:
        csv="results/deseq2/{level}/{comparison}.csv",
    output:
        pdf=report(
            "results/plots/volcano/{level}/{comparison}.pdf",
            caption="../report/volcano.rst",
            category="Volcano plots",
        ),
    log:
        "logs/plots/volcano_{level}_{comparison}.log",
    wildcard_constraints:
        level="|".join(LEVELS),
    conda:
        "../envs/deseq2.yml"
    threads: config["resources"]["plotting"]["cpu"]
    resources:
        runtime=config["resources"]["plotting"]["time"],
    params:
        fdr=config["fdr_cutoff"],
        fc=config["fc_cutoff"],
    script:
        "../scripts/volcano.R"
