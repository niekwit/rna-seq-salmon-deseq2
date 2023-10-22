#redirect R output to log
log <- file(snakemake@log[[1]], open="wt")
sink(log, type = "output")
sink(log, type = "message")

library(DESeq2)
library(RColorBrewer)
library(pheatmap)


#create output dir
dir.create(file.path(getwd(),"plots-salmon"), showWarnings=FALSE)

#load DESeq2 data
load(snakemake@input[[1]])

#transform data
vsd <- vst(dds, blind=FALSE)

#calculate sample distances
sampleDists <- dist(t(assay(vsd)))

#create matrix
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- vsd$sample
colnames(sampleDistMatrix) <- vsd$sample

#set colours
colours <- colorRampPalette(rev(brewer.pal(9,"Greens")))(255)

#save heatmap
pdf(snakemake@output[[1]])
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colours)
dev.off()



#close redirection of output/messages
sink(log, type = "output")
sink(log, type = "message")


