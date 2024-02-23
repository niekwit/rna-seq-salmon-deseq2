rule fastqc:
    input:
        "reads/{sample}{end}.fastq.gz"
    output:
        html="results/qc/fastqc/{sample}{end}.html",
        zip="results/qc/fastqc/{sample}{end}_fastqc.zip"
    params:
        extra = "--quiet"
    log:
        "logs/fastqc/{sample}{end}.log"
    threads: config["resources"]["fastqc"]["cpu"]
    resources:
        runtime=config["resources"]["fastqc"]["time"],
        mem_mb = 2048,
    wrapper:
        "v3.3.6/bio/fastqc"


rule multiqc:
        input:
            expand("results/qc/fastqc/{sample}{end}_fastqc.zip", sample=SAMPLES, end=["_R1","_R2"])
        output:
            r="results/qc/multiqc/multiqc.html",
            d=directory("results/qc/multiqc/"),
        params:
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
            "--outdir {output.d} "
            "-n multiqc.html "
            "{params.extra} "
            "{input} "
            "> {log} 2>&1"