#!/usr/bin/env bash

LOG=${snakemake_log[0]}
URL=${snakemake_params["url"]}
OUTPUT=${snakemake_output[0]}

echo "Downloading/decompressing $URL to $OUTPUT" > $LOG
wget -q $URL -O $OUTPUT.gz 2>> $LOG
pigz -df $OUTPUT.gz 2>> $LOG
