import pandas as pd
import sys

def import_samples():
    try:
        csv = pd.read_csv("config/samples.csv")
        SAMPLES = csv["sample"]
        
        return SAMPLES

    except FileNotFoundError:
        print("ERROR: config/samples.csv not found!")
        sys.exit(1)