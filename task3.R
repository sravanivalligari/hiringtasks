#!/usr/bin/env Rscript

# Loading libraries
library(ggplot2)
library(data.table)

# Reading the gene information file, selecting only the 'Symbol' and 'chromosome' columns
gene_info <- fread("C:/Users/srava/Desktop/Homo_sapiens.gene_info.gz", select = c("Symbol", "chromosome"), header = TRUE)

# Cleaning the data by removing entries where the chromosome field contains a ('|')
gene_info_clean <- gene_info[!grepl("\\|", chromosome), ]

# Aggregating the clean dataset by chromosome, counting the number of genes per chromosome
gene_counts <- gene_info_clean[, .(GeneCount = .N), by = .(Chromosome = chromosome)]

# Creating a bar plot using ggplot2
plot <- ggplot(gene_counts, aes(x = reorder(Chromosome, -GeneCount), y = GeneCount)) +
  geom_bar(stat = "identity", fill = "grey") +
  theme_minimal() +
  labs(title = "Number of genes in each chromosome", x = "Chromosomes", y = "Gene count") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

# Display the plot
print(plot)

# Saving the plot as a PDF file to a specified path, setting the dimensions of the output file
ggsave("gene_chromosome_plot.pdf", plot = plot, device = "pdf", path = "C:/Users/srava/Desktop/", width = 11, height = 8)