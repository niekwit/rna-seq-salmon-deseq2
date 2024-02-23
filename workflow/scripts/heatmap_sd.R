# Redirect R output to log
log <- file(snakemake@log[[1]], open = "wt")
sink(log, type = "output")
sink(log, type = "message")

library(DESeq2)
library(RColorBrewer)
library(pheatmap)

# Load DESeq2 data
load(snakemake@input[[1]])

# Get genome and transform data
genome <- snakemake@params[["genome"]]
if (genome == "test") {
  # For data set with few genes
  # https://support.bioconductor.org/p/98634/
  dds <- estimateSizeFactors(dds)
  rows <- sum( rowMeans( counts(dds, normalized=TRUE)) > 5 )
  vsd <- vst(dds, nsub = rows)
} else {
  vsd <- vst(dds, blind=FALSE)
}

# Calculate sample distances
sampleDists <- dist(t(assay(vsd)))

# Create matrix
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- vsd$sample
colnames(sampleDistMatrix) <- vsd$sample

# Set colours
colours <- colorRampPalette(rev(brewer.pal(9, "Greens")))(255)

# Save heatmap
pdf(snakemake@output[[1]])
pheatmap(sampleDistMatrix,
         clustering_distance_rows = sampleDists,
         clustering_distance_cols = sampleDists,
         col = colours)
dev.off()


# Close redirection of output/messages
sink(log, type = "output")
sink(log, type = "message")