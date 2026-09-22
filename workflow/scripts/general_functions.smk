import os
import datetime
import pandas as pd
from scripts.resources import Resources
from snakemake.utils import min_version, validate
from snakemake.logging import logger


def targets():
    targets = [
        "results/qc/multiqc/multiqc.html",
        "results/plots/mapping_rates.pdf",
        "results/plots/mapping_rates.csv",
        expand("results/plots/{level}/pca.pdf", level=LEVELS),
        expand("results/plots/{level}/sample_distance.pdf", level=LEVELS),
        expand(
            "results/plots/volcano/{level}/{comparison}.pdf",
            level=LEVELS,
            comparison=COMPARISONS,
        ),
    ]
    return targets


def samples():
    """
    Generate wildcard values for {sample} based on sample names in samples.csv
    Perform checks on sample names and file existence in reads/, and detect
    whether each sample is paired-end (PE) or single-end (SE) based on the
    read file naming convention:
      - PE: reads/{sample}_R1_001.fastq.gz + reads/{sample}_R2_001.fastq.gz
      - SE: reads/{sample}.fastq.gz
    Detected end types are stored in the global END_TYPE dict (sample -> "pe"/"se").
    """
    csv = pd.read_csv("config/samples.csv")
    SAMPLES = csv["sample"]

    # Check if sample names match file names, and detect PE/SE per sample
    global END_TYPE
    END_TYPE = {}
    not_found = []
    for sample in SAMPLES:
        r1 = f"reads/{sample}_R1_001.fastq.gz"
        r2 = f"reads/{sample}_R2_001.fastq.gz"
        se = f"reads/{sample}.fastq.gz"

        if os.path.isfile(r1) and os.path.isfile(r2):
            END_TYPE[sample] = "pe"
        elif os.path.isfile(se):
            END_TYPE[sample] = "se"
        else:
            not_found.append(
                f"{sample}: expected either ({r1} and {r2}) for paired-end, "
                f"or ({se}) for single-end"
            )
    if len(not_found) != 0:
        not_found = "\n".join(not_found)
        raise ValueError(f"Could not find read files for the following sample(s):\n{not_found}")

    return SAMPLES


def is_pe(sample):
    """Return True if sample is paired-end, False if single-end."""
    return END_TYPE[sample] == "pe"


def trimmed_fastqc_targets():
    """
    Generate results/qc/fastqc/... targets for all samples, accounting for
    PE samples (R1/R2) and SE samples (single file).
    """
    targets = []
    for sample in SAMPLES:
        if is_pe(sample):
            targets.extend(
                [
                    f"results/qc/fastqc/{sample}_R1_fastqc.zip",
                    f"results/qc/fastqc/{sample}_R2_fastqc.zip",
                ]
            )
        else:
            targets.append(f"results/qc/fastqc/{sample}_SE_fastqc.zip")
    return targets


def salmon_quant_input(wildcards):
    """
    Return the appropriate trimmed read input(s) for salmon quant,
    depending on whether the sample is paired-end or single-end.
    """
    index = multiext(
        f"resources/{resources.genome}_{resources.build}_gentrome_index/",
        "index.ssi",
        "refseq_offsets.json",
        "index.ectab",
        "index.ctab",
        "refseq.bin",
        "index.ssi.mphf",
        "index.refinfo",
        "info.json",
        "duplicate_clusters.tsv",
    )
    if is_pe(wildcards.sample):
        return {
            "r1": f"results/trimmed/{wildcards.sample}_R1.fq.gz",
            "r2": f"results/trimmed/{wildcards.sample}_R2.fq.gz",
            "index": index,
        }
    else:
        return {
            "r": f"results/trimmed/{wildcards.sample}_SE.fq.gz",
            "index": index,
        }


def comparisons():
    """
    Create pairwise comparison strings from samples.csv
    """
    if (
        len(sample_info["genotype"].unique()) > 1
        and len(sample_info["treatment"].unique()) > 1
    ):
        # Combine genotype and treatment to get unique conditions
        sample_info["condition"] = sample_info[["genotype", "treatment"]].agg(
            "_".join, axis=1
        )

        # Get reference conditions
        reference_conditions = (
            sample_info[sample_info["reference"] == "yes"]["condition"]
            .unique()
            .tolist()
        )

        # Get all conditions
        all_conditions = sample_info["condition"].unique().tolist()
    elif (
        len(sample_info["genotype"].unique()) > 1
        and len(sample_info["treatment"].unique()) == 1
    ):
        # Get reference conditions
        reference_conditions = (
            sample_info[sample_info["reference"] == "yes"]["genotype"].unique().tolist()
        )

        # Get all conditions
        all_conditions = sample_info["genotype"].unique().tolist()

    elif (
        len(sample_info["genotype"].unique()) == 1
        and len(sample_info["treatment"].unique()) > 1
    ):
        # Get reference conditions
        reference_conditions = (
            sample_info[sample_info["reference"] == "yes"]["treatment"]
            .unique()
            .tolist()
        )

        # Get all conditions
        all_conditions = sample_info["treatment"].unique().tolist()
    else:
        raise ValueError(
            "Cannot create comparisons with only one treatment and one genotype..."
        )

    # Create strings for comparisons
    comparisons = []
    for test in all_conditions:
        for ref in reference_conditions:
            if test != ref:
                comparisons.append(f"{test}_vs_{ref}")

    if len(comparisons) == 0:
        raise ValueError(
            "No comparisons could be created — check that samples.csv has 'reference' set to 'yes' for at least one sample."
        )

    return comparisons
