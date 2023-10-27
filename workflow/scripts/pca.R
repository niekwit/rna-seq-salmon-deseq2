# redirect R output to log
log <- file(snakemake@log[[1]], open="wt")
sink(log, type = "output")
sink(log, type = "message")

library(ggplot2)
library(DESeq2)
library(RColorBrewer)
library(ggrepel)

# read in data
load(snakemake@input[[1]])

# log transform data
rld <- rlog(dds)

# select appropriate colour palette
if (length(unique(rld$treatment)) == 2) {
  palette <- "Paired"
} else {
  palette <- "Dark2"
}

#create PCA plot
pca <- plotPCA(rld, intgroup=c("genotype", "treatment")) +
  geom_label_repel(aes(label = rld$sample)) + 
  guides(colour = "none") +
  theme_bw() +
  theme(text=element_text(size = 16)) +
  scale_color_brewer(palette = palette)

# save plot to file
ggsave(snakemake@output[[1]], 
       pca, 
       width=10,
       height=10)


# close redirection of output/messages
sink(log, type = "output")
sink(log, type = "message")


