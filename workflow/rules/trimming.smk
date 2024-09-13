rule trim_galore_pe:
    input:
        ["reads/{sample}_R1_001.fastq.gz", "reads/{sample}_R2_001.fastq.gz"],
    output:
        fasta_fwd=temp("results/trimmed/{sample}_R1.fq.gz"),
        report_fwd="logs/trim_galore/{sample}_R1_trimming_report.txt",
        fasta_rev=temp("results/trimmed/{sample}_R2.fq.gz"),
        report_rev="logs/trim_galore/{sample}_R2_trimming_report.txt",
    threads: config["resources"]["trim"]["cpu"],
    resources: 
        runtime=config["resources"]["trim"]["time"],
    params:
        extra="--illumina -q 20",
    log:
        "logs/trim_galore/{sample}.log",
    wrapper:
        "v4.3.0/bio/trim_galore/pe"

        