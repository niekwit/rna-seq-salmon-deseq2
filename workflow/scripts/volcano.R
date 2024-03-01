# redirect R output to log
log <- file(snakemake@log[[1]], open = "wt")
sink(log, type = "output")
sink(log, type = "message")

library(ggplot2)
#library(readxl)
library(ggrepel)
library(dplyr)
library(cowplot)

# Get plotting paramaters
fdr <- -log10(snakemake@params[["fdr"]])
fc <- snakemake@params[["fc"]]

# Load data for contrast
df <- read.csv(snakemake@input[["csv"]])

# Get contrast name
contrast <- unique(df$contrast_name)

# Log transform padj
df$log.padj <- -log10(df$padj)

# Remove genes with NA in log.padj
df <- df[!(is.na(df$log.padj)), ]

# Add fill colour based on log2FC and pvalue
df <- df %>%
  mutate(colour = case_when(
    log2FoldChange > fc & log.padj > fdr ~ "red",
    log2FoldChange < -fc & log.padj > fdr ~ "blue",
    log2FoldChange < fc & log.padj < fdr ~ "grey40",
    log2FoldChange > -fc & log.padj < fdr ~ "grey40",
  ))

# Select top 5 down and up regulated for labels
df.up <- df %>%
  filter(log2FoldChange > fc) %>%
  filter(log.padj > fdr)
if (nrow(df.up) > 5){
  df.up <- df.up %>% slice(1:5)
}

df.down <- df %>%
  filter(log2FoldChange < -fc) %>%
  filter(log.padj > fdr)
if (nrow(df.down) > 5) {
  df.down <- df.down %>% slice(1:5)
}

df.label <- rbind(df.up, df.down)

# Create plot
p <- ggplot(df, aes(x = `log2FoldChange`,
                y = `log.padj`)) +
  theme_cowplot(16) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.line = element_line(colour = "black"),
        panel.border = element_blank(),
        panel.background = element_blank(),
        panel.spacing.x = unit(2, "lines")) +
  geom_point(alpha = 0.5,
              shape = 21,
              size = 5,
              colour = "black",
              fill = df$colour) +
  ylab("-log10(adj. p value)") +
  geom_vline(xintercept = c(-fc, fc),
              linetype = "dashed",
              color = "red",
              linewidth = 0.5) +
  geom_hline(yintercept = fdr,
              linetype = "dashed",
              color = "red",
              linewidth = 0.5) +
  ggtitle(contrast) +
  geom_label_repel(size = 5,
                    aes(x = `log2FoldChange`,
                        y = `log.padj`,
                        label = external_gene_name),
                    data = df.label,
                    nudge_x = -0.125,
                    nudge_y = 0.05) +
  scale_fill_manual(values = df$`colour`)

# Save plot to file
ggsave(snakemake@output[["pdf"]], p)

# Close log file
sink(log, type = "output")
sink(log, type = "message")
