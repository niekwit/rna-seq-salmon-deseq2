# redirect R output to log
log <- file(snakemake@log[[1]], open="wt")
sink(log, type = "output")
sink(log, type = "message")

# load packages
library(DESeq2)
library(GenomicFeatures)
library(tximport)
library(dplyr)
library(biomaRt)
library(readr)

# load snakemake variables
files <- snakemake@input[["salmon"]]
genome <- snakemake@params[["genome"]]
gtf <- snakemake@input[["gtf"]]

# Load experiment information
samples <- read.csv("config/samples.csv", header=TRUE)
genotypes <- unique(samples$genotype)
treatments <- unique(samples$treatment)

if (length(treatments) > 1){
  samples$comb <- paste0(samples$genotype,"_",samples$treatments)
} else {
  samples$comb <- paste0(samples$genotype)
}
  
# Create txdb from GTF 
txdb <- makeTxDbFromGFF(gtf)
  
# Create transcript to gene file
k <- keys(txdb,keytype="TXNAME")
tx2gene <- AnnotationDbi::select(txdb,k,"GENEID","TXNAME")

# read Salmon quant.sf files
txi <- tximport(files, 
                type="salmon", 
                tx2gene=tx2gene)

# create DESeqDataSet
dds <- DESeqDataSetFromTximport(txi,
                                colData = samples,
                                design = ~ comb)

# save dds to file (input for other scripts)
save(dds, file=snakemake@output[["rdata"]])

# load data for gene annotation
mart <- useMart("ensembl")

if (genome == "human") {
  mart <- useDataset("hsapiens_gene_ensembl", mart = mart)
} else if (genome == "mouse"){
  mart <- useDataset("mmusculus_gene_ensembl", mart = mart)
} # add other genomes later!!!

# load reference samples
references <- unique(samples[samples$reference == "yes" ,]$comb)

# create nested list to store all pairwise comparisons (top level:references, lower level: samples without reference)
df.list <- vector(mode="list", length=length(references))
for (i in seq_along(references)){
  df.list[[i]] <- vector(mode="list", length=(length(unique(samples$comb)) - 1 ))
}

# for each reference sample, perform pairwise comparisons with all the other samples
for (r in seq_along(references)){
  cat(paste0("Setting reference level: ",references[r], " (",r,"/",length(references),")\n"))
  
  # copy dds
  dds_relevel <- dds
  
  # for each reference sample, set it as reference in dds
  dds_relevel$comb <- relevel(dds$comb, ref = references[r])
  
  # differential expression analysis
  dds_relevel <- DESeq(dds_relevel)
  
  # get comparisons
  library(stringr)
  comparisons <- resultsNames(dds_relevel)
  comparisons <- strsplit(comparisons," ")
  comparisons[1] <- NULL

  
  # create df for each comparison
  for (c in seq_along(comparisons)){
    comparison <- comparisons[[c]]
    comparison <- str_replace(comparison,"comb_","") #get name
    print(paste0("Specifiying contrast: ",comparison, " (",c,"/",length(comparisons),")"))
    
    res <- results(dds_relevel, name=comparisons[[c]])
    
    df <- as.data.frame(res) %>%
      mutate(ensembl_gene_id = res@rownames, .before=1) 
    
    #annotate df
    df$ensembl_gene_id <- gsub("\\.[0-9]*","",df$ensembl_gene_id) #tidy up gene IDs
    gene.info <- getBM(filters = "ensembl_gene_id", 
                       attributes = c("ensembl_gene_id", 
                                      "external_gene_name",
                                      "description",
                                      "gene_biotype", 
                                      "chromosome_name",
                                      "start_position",
                                      "end_position", 
                                      "percentage_gene_gc_content"), 
                       values = df$ensembl_gene_id, 
                       mart = mart)
    
    df <- left_join(df,gene.info,by="ensembl_gene_id")
    
    # remove genes with baseMean zero
    df <- df[df$baseMean != 0, ]
    
    # add normalised read counts for each sample to df  
    temp <- as.data.frame(counts(dds_relevel, normalized=TRUE))
    temp$ensembl_gene_id <- row.names(temp)
    temp$ensembl_gene_id <- gsub("\\.[0-9]*","",temp$ensembl_gene_id) #tidy up gene IDs
    names(temp)[1:length(dds_relevel@colData@listData$sample)] <- dds_relevel@colData@listData$sample
    
    df <- left_join(df,temp, by="ensembl_gene_id")
    
    # move some columns around
    df <- df %>%
      relocate(external_gene_name, .after=ensembl_gene_id) %>%
      relocate((ncol(df)-(length(dds_relevel@colData@listData$sample)-1)):ncol(df), .after=baseMean)
    
    # order data for padj
    df <- df[order(df$padj), ]
    
    # add column with just contrast name
    df <- df %>%
      mutate(contrast_name = comparison, .before=1)
    
    # sheet title can be max 31 characters
    # add column with contrast name and change it to a number (counter)
    df <- df %>%
      mutate(contrast_name = comparison, .before=1)
    
    # save df to df.list
    df.list[[r]][[c]] <- df
    
  }
  
}

# function to flatten nested lists (https://stackoverflow.com/questions/16300344/how-to-flatten-a-list-of-lists/41882883#41882883)
flattenlist <- function(x) {  
  morelists <- sapply(x, function(xprime) class(xprime)[1]=="list")
  out <- c(x[!morelists], unlist(x[morelists], recursive=FALSE))
  if(sum(morelists)){ 
    Recall(out)
  } else {
    return(out)
  }
}

# write all data frames in df.list to sheets in Excel file
library(openxlsx)

# flatten df.list
df.list <- flattenlist(df.list)

# get contrast names from each df in list
names <- lapply(df.list, function(x) unique(x$contrast_name))

# name data frames in list
names(df.list) <- names

# write to one file
print(paste0("Saving results to ",snakemake@output[["xlsx"]]," ..."))
write.xlsx(df.list, 
           snakemake@output[["xlsx"]],
           colNames = TRUE)

# close log file
sink(log, type = "output")
sink(log, type = "message")


