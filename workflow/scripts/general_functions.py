import pandas as pd
import sys
import glob
import os

def import_samples():
    try:
        csv = pd.read_csv("config/samples.csv")
        SAMPLES = csv["sample"]
        
        # check if samples from samples.csv match fastq files (both R1 and R2) in reads folder
        for sample in SAMPLES:
            r1 = f"reads/{sample}_R1.fastq.gz"
            r2 = f"reads/{sample}_R2.fastq.gz"
            
            assert any(os.path.isfile(x) for x in [r1,r2]), f"One or more fastq files (R1/R2) from sample {sample} not found in reads directory"

        return SAMPLES
        
    except FileNotFoundError:
        print("ERROR: config/samples.csv not found")
        sys.exit(1)
        
