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
        "v3.4.0/bio/fastqc"


rule multiqc:
        input:
            expand("results/qc/fastqc/{sample}{end}_fastqc.zip", sample=SAMPLES, end=["_R1_001","_R2_001"])
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