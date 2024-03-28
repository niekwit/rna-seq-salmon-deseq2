import pandas as pd
import os

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
    if len(sample_info["genotype"].unique()) > 1 and len(sample_info["treatment"].unique()) > 1:
        # Combine genotype and treatment to get unique conditions
        sample_info["condition"] = sample_info[["genotype","treatment"]].agg('_'.join, axis=1)

        # Get reference conditions
        reference_conditions = sample_info[sample_info["reference"] == "yes"]["condition"].unique().tolist()
        
        # Get test conditions
        test_conditions = sample_info[sample_info["reference"] != "yes"]["condition"].unique().tolist()
    elif len(sample_info["genotype"].unique()) > 1 and len(sample_info["treatment"].unique()) == 1:
        # Get reference conditions
        reference_conditions = sample_info[sample_info["reference"] == "yes"]["genotype"].unique().tolist()

        # Get test conditions
        test_conditions = sample_info[sample_info["reference"] != "yes"]["genotype"].unique().tolist()
    elif len(sample_info["genotype"].unique()) == 1 and len(sample_info["treatment"].unique()) > 1:
        # Get reference conditions
        reference_conditions = sample_info[sample_info["reference"] == "yes"]["treatment"].unique().tolist()

        # Get test conditions
        test_conditions = sample_info[sample_info["reference"] != "yes"]["treatment"].unique().tolist()
    
    # Create strings for comparisons
    comparisons = []
    for test in test_conditions:
        for ref in reference_conditions:
            comparisons.append(f"{test}_vs_{ref}")
    
    return comparisons