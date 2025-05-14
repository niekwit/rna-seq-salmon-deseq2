# redirect R output to log
log <- file(snakemake@log[[1]], open = "wt")
sink(log, type = "output")
sink(log, type = "message")

library(tidyverse)
library(DESeq2)
library(RColorBrewer)
library(ggrepel)
library(cowplot)
library(limma)

# Read data
load(snakemake@input[["dds"]])

batches <- dds$batch

if (length(unique(batches)) > 1) {
  print("Removing batch effect from data...")
  # Extracting transformed values
  vsd <- vst(dds, blind = FALSE)

  # Remove batch variation with limma
  mat <- assay(vsd)
  mm <- model.matrix(~comb, colData(vsd))
  mat <- limma::removeBatchEffect(mat, batch = vsd$batch, design = mm)
  assay(vsd) <- mat

  # Select appropriate colour palette
  if (length(unique(vsd$treatment)) == 2) {
    palette <- "Paired"
  } else {
    palette <- "Dark2"
  }

  # Create PCA plot
  pca <- plotPCA(vsd, intgroup = c("genotype", "treatment")) +
    geom_text_repel(aes(label = vsd$sample), size = 6) +
    guides(colour = "none") +
    theme_cowplot(18) +
    scale_color_brewer(palette = palette)
} else {
  print("No correction for batch effect...")
  # Log transform data
  rld <- rlog(dds)

  # Select appropriate colour palette
  if (length(unique(rld$treatment)) == 2) {
    palette <- "Paired"
  } else {
    palette <- "Dark2"
  }

  # Create PCA plot
  pca <- plotPCA(rld, intgroup = c("genotype", "treatment")) +
    geom_text_repel(aes(label = rld$sample)) +
    guides(colour = "none") +
    theme_cowplot(18) +
    scale_color_brewer(palette = palette)
}

# Save plot to file
ggsave(snakemake@output[[1]], pca, width = 10, height = 10)
