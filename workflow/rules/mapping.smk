rule salmon_quant:
    input:
        unpack(salmon_quant_input),
    output:
        quant="results/salmon/{sample}/quant.sf",
        lib="results/salmon/{sample}/lib_format_counts.json",
        log="results/salmon/{sample}/logs/salmon_quant.log",
    log:
        "logs/salmon/quant-{sample}.log",
    params:
        # optional parameters
        libtype="A",  # automatic detection of library type
        extra=config["salmon-quant"]["extra_params"],
    threads: config["resources"]["mapping"]["cpu"]
    resources:
        runtime=config["resources"]["mapping"]["time"],
    wrapper:
        "v9.13.0/bio/salmon/quant"
