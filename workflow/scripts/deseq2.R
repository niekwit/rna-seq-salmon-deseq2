# redirect R output to log
log <- file(snakemake@log[[1]], open = "wt")
sink(log, type = "output")
sink(log, type = "message")

# load packages
library(DESeq2)
library(GenomicFeatures)
library(tximport)
library(dplyr)
library(stringr)
library(biomaRt)
library(readr)
library(openxlsx)
library(rtracklayer)

# load snakemake variables
files <- snakemake@input[["salmon"]]
genome <- snakemake@params[["genome"]]
gtf <- snakemake@input[["gtf"]]

# Load experiment information
samples <- read.csv("config/samples.csv", header=TRUE)
genotypes <- unique(samples$genotype)
treatments <- unique(samples$treatment)
design <- snakemake@params[["design"]]

if (length(treatments) > 1) {
  samples$comb <- paste0(samples$genotype, "_", samples$treatment)
} else {
  samples$comb <- paste0(samples$genotype)
}

# Check if batch column exists
if ("batch" %in% colnames(samples)) {
  batches <- unique(samples$batch)
  samples$batch <- as.factor(samples$batch)
} else {
  # Add batch column with just one batch
  samples$batch <- as.factor("1")
  batches <- 1
}

# Gene annotation info
print("Reading gene annotation info...")
db <- rtracklayer::import(gtf)
gene.info <- data.frame(ensembl_gene_id = db$gene_id, 
                  external_gene_name = db$gene_name, 
                  gene_biotype = db$gene_biotype)

# Create txdb from GTF
print("Creating txdb from GTF...")
txdb <- makeTxDbFromGFF(gtf)

# Create transcript to gene file
k <- keys(txdb, keytype = "TXNAME")
tx2gene <- AnnotationDbi::select(txdb, k, "GENEID", "TXNAME")

# Read Salmon quant.sf files
txi <- tximport(files,
                type = "salmon",
                tx2gene = tx2gene)

# Create DESeqDataSet
if (str_length(design) == 0) {
  if (length(batches) == 1){
  print("Not including batch factor in DESeq2 design...")
  dds <- DESeqDataSetFromTximport(txi,
                                  colData = samples,
                                  design = ~ comb)
  } else {
  print("Including batch factor in DESeq2 design...")
  dds <- DESeqDataSetFromTximport(txi,
                                  colData = samples,
                                  design = ~ batch + comb)
  }
} else {
  print(paste0("Using custom DESeq2 design: ", design, "..."))
  dds <- DESeqDataSetFromTximport(txi,
                                  colData = samples,
                                  design = as.formula(design))
}

# Save dds to file (input for other scripts)
save(dds, file = snakemake@output[["rdata"]])

# Load reference samples
references <- unique(samples[samples$reference == "yes", ]$comb)

# List to store data from each contrast
resList <- list()

# For each reference sample, perform pairwise comparisons with all the other samples
for (r in seq_along(references)){
  cat(paste0("Setting reference level: ",references[r], " (",r,"/",length(references),")\n"))

  # Copy dds
  dds_relevel <- dds

  # For each reference sample, set it as reference in dds
  dds_relevel$comb <- relevel(dds$comb, ref = references[r])

  # Differential expression analysis
  dds_relevel <- DESeq(dds_relevel)

  # Get comparisons
  comparisons <- resultsNames(dds_relevel)
  comparisons <- strsplit(comparisons, " ")
  comparisons[1] <- NULL

  
  # Create df for each comparison
  for (c in seq_along(comparisons)){
    comparison <- comparisons[[c]]
    comparison <- str_replace(comparison, "comb_", "") # Get name
    print(paste0("Specifiying contrast: ",comparison, " (",c,"/",length(comparisons),")"))

    res <- results(dds_relevel, name = comparisons[[c]])
    df <- as.data.frame(res) %>%
      mutate(ensembl_gene_id = res@rownames, .before = 1)

    # Annotate df
    df <- left_join(df, gene.info, by = "ensembl_gene_id")

    # Remove genes with baseMean zero
    df <- df[df$baseMean != 0, ]

    # Add normalised read counts for each sample to df
    temp <- as.data.frame(counts(dds_relevel, normalized = TRUE))
    temp$ensembl_gene_id <- row.names(temp)
    names(temp)[1:length(dds_relevel@colData@listData$sample)] <- dds_relevel@colData@listData$sample

    df <- left_join(df, temp, by = "ensembl_gene_id")

    # Move some columns around
    df <- df %>%
      relocate(external_gene_name, .after = ensembl_gene_id) %>%
      relocate((ncol(df) - (length(dds_relevel@colData@listData$sample) - 1)):ncol(df), .after = baseMean)

    # Order data for padj
    df <- df[order(df$padj), ]

    # Add column with just contrast name
    df <- df %>%
      mutate(contrast_name = comparison, .before = 1)

    # Sheet title can be max 31 characters
    # Add column with contrast name and change it to a number (counter)
    df <- df %>%
      mutate(contrast_name = comparison, .before = 1)

    # Save df to resList
    resList[[(length(resList) + 1)]] <- df
  }
}

# Get contrast names from each df in list
names <- lapply(resList, function(x) unique(x$contrast_name))

# Name data frames in list
names(resList) <- names

# Write each df also to separate csv file
for (i in seq(resList)){
  write_csv(resList[[i]],
            paste0("results/deseq2/", names(resList)[i], ".csv"))
}

# Check if any df name is longer than 31 characters (not supported by openxlsx)
if (any(nchar(names) > 31)) {
  # change names to numbers
  names <- seq_along(length(names))

  # Rename data frames in list
  names(resList) <- names
}

# Write to one file
write.xlsx(resList,
           snakemake@output[["xlsx"]],
           colNames = TRUE)

# Close log file
sink(log, type = "output")
sink(log, type = "message")