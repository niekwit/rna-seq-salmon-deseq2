import pandas as pd
import os
import re

def targets():
    targets = [
        "results/plots/mapping_rates.pdf",
        "results/plots/pca.pdf",
        "results/plots/sample_distance.pdf",
        expand("results/plots/volcano/{comparison}.pdf", comparison=COMPARISONS),
        "results/qc/multiqc/multiqc.html",
    ]
    return targets


def samples():
    """
    Generate wildcard values for {sample} based on sample names in samples.csv
    Perform checks on sample names and file existence in reads/
    """
    csv = pd.read_csv("config/samples.csv")
    SAMPLES = csv["sample"]

    # Check if sample names contain any characters that are not alphanumeric or underscore
    illegal = []
    for sample in SAMPLES:
        if not re.match("^[a-zA-Z0-9_]*$", sample):
            illegal.append(sample)
    if len(illegal) != 0:
        illegal = "\n".join(illegal)
        raise ValueError(f"Following samples contain illegal characters:\n{illegal}")

    # Check if each sample name ends with _[0-9]
    wrong = []
    for sample in SAMPLES:
        if not re.match(".*_[0-9]$", sample):
            wrong.append(sample)
    if len(wrong) != 0:
        wrong = "\n".join(wrong)
        raise ValueError(f"Following samples do not end with _[0-9]:\n{wrong}")

    # Check if sample names match file names
    not_found = []
    for sample in SAMPLES:
        r1= f"reads/{sample}_R1_001.fastq.gz"
        r2= f"reads/{sample}_R2_001.fastq.gz"
        if not os.path.isfile(r1):
            not_found.append(r1)
        if not os.path.isfile(r2):
            not_found.append(r2)
    if len(not_found) != 0:
        not_found = "\n".join(not_found)
        raise ValueError(f"Following files not found:\n{not_found}")

    return SAMPLES


def comparisons():
    """
    Create pairwise comparison strings from samples.csv
    """
    sample_info = pd.read_csv("config/samples.csv")
       
    # Combine genotype and treatment to get unique conditions
    sample_info["condition"] = sample_info["genotype"] + "_" + sample_info["treatment"]
    
    # Get reference conditions
    reference_conditions = sample_info[sample_info["reference"] == "yes"]["condition"].unique().tolist()
    
    # Get test conditions
    test_conditions = sample_info[sample_info["reference"] != "yes"]["condition"].unique().tolist()
    
    # Create strings for comparisons
    comparisons = []
    for test in test_conditions:
        for ref in reference_conditions:
            comparisons.append(f"{test}_vs_{ref}")
    
    return comparisons