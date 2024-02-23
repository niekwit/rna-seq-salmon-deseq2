#!/usr/bin/env bash

### Using human gencode v44 data
# Subset fasta/gtf files for protein coding genes on chr22
# Reduces analysis time

# Subset genome fasta file for chr22 sequence
samtools faidx GRCh38.p14.genome.fa chr22 > GRCh38.p14.chr22.fa

### Subset transcript fasta file for chr22 protein coding genes
# Generate chr22 protein_coding only GTF file 
grep "^chr22" gencode.v44.annotation.gtf | grep "protein_coding" > gencode.v44.annotation.chr22.gtf

# Extract Ensembl gene ids from chr22
awk -F"\t" '{print $9}' gencode.v44.annotation.chr22.gtf | awk -F";" '{print $1}' | awk -F" " '{print $2}' | sed 's/"//g' | sort | uniq > chr22_ensembl_gene_ids.txt

# Get transcript fasta headers that match chr22_ensembl_gene_ids.txt
grep -w -f chr22_ensembl_gene_ids.txt gencode.v44.transcripts.fa | sed 's/^>//' > chr22_genes_fasta_headers.txt

# For each header in chr22_genes_fasta_headers.txt, get the corresponding sequence
for HEADER in $(cat chr22_genes_fasta_headers.txt); do
    samtools faidx gencode.v44.transcripts.fa "$HEADER" >> gencode.v44.transcripts.chr22.fa
done

# Compression of gencode.v44.annotation.chr22.gtf, gencode.v44.transcripts.chr22.fa and GRCh38.p14.chr22.fa
pigz gencode.v44.transcripts.chr22.fa GRCh38.p14.chr22.fa gencode.v44.annotation.chr22.gtf

# Remove intermediates
rm chr22_ensembl_gene_ids.txt chr22_genes_fasta_headers.txt
