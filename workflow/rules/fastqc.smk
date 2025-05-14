rule fastqc:
    input:
        "results/trimmed/{sample}_{end}.fq.gz"
    output:
        html="results/qc/fastqc/{sample}_{end}.html",
        zip="results/qc/fastqc/{sample}_{end}_fastqc.zip"
    params:
        extra = "--quiet"
    log:
        "logs/fastqc/{sample}{end}.log"
    threads: config["resources"]["fastqc"]["cpu"]
    resources:
        runtime=config["resources"]["fastqc"]["time"],
        mem_mb = 2048,
    wrapper:
        "v5.9.0/bio/fastqc"


rule multiqc:
        input:
            expand("results/qc/fastqc/{sample}_{end}_fastqc.zip", sample=SAMPLES, end=["R1","R2"])
        output:
            "results/qc/multiqc/multiqc.html",
        params:
            dir=lambda wildcards, output: os.path.dirname(output[0]),
            extra="",  # Optional: extra parameters for multiqc
        threads: config["resources"]["fastqc"]["cpu"]
        resources:
            runtime=config["resources"]["fastqc"]["time"],
            mem_mb = 2048,
        log:
            "logs/multiqc/multiqc.log"
        conda:
            "../envs/resources.yml"
        shell:
            "multiqc " 
            "--force "
            "--outdir {params.dir} "
            "-n multiqc.html "
            "{params.extra} "
            "{input} "
            "> {log} 2>&1"