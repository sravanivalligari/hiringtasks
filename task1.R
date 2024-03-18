#!/usr/bin/env Rscript

# Loading data.table library for data manipulation
library(data.table)

# Defining the file paths for input and output files

# Path to the gene info file
gene_info_path <- "C:/Users/srava/Desktop/Homo_sapiens.gene_info.gz"

# Path to the input GMT file
gmt_file_path <- "C:/Users/srava/Desktop/h.all.v2023.1.Hs.symbols.gmt"

# Path for the output GMT file with Entrez IDs
output_gmt_file_path <- "C:/Users/srava/Desktop/task1_output_entrez_id.gmt"

# Loading gene information, selecting only GeneID, Symbol, and Synonyms columns, and avoiding converting to data.table format
gene_info <- fread(gene_info_path, select = c("GeneID", "Symbol", "Synonyms"), header = TRUE, data.table = FALSE)

# Converting the 'Synonyms' column into lists of synonyms, splitting by the "|" delimiter
gene_info$Synonyms <- strsplit(as.character(gene_info$Synonyms), "\\|")

# Creating a mapping from gene symbols to GeneIDs
symbol_to_geneid <- setNames(gene_info$GeneID, gene_info$Symbol)

# Updating the mapping to include synonyms as keys pointing to the same GeneID
for (i in seq_along(gene_info$Synonyms)) {
  synonyms <- gene_info$Synonyms[[i]]
  valid_synonyms <- synonyms[synonyms != "-"] # Filter out invalid synonyms
  symbol_to_geneid[valid_synonyms] <- rep(gene_info$GeneID[i], length(valid_synonyms))
}

# Defining a function to replace gene symbols in GMT file lines with their corresponding Entrez IDs
replace_symbols_with_entrez_ids <- function(line) {
  fields <- strsplit(line, "\t")[[1]]
  pathway_name <- fields[1]
  pathway_description <- fields[2]
  gene_symbols <- fields[-c(1,2)]
  
  # Replacing each symbol with its Entrez ID, if available
  gene_ids <- sapply(gene_symbols, function(symbol) {
    if (symbol %in% names(symbol_to_geneid)) {
      return(as.character(symbol_to_geneid[symbol]))
    } else {
      return(NA)
    }
  })
  
  # Removing any symbols that couldn't be matched to an Entrez ID
  gene_ids <- gene_ids[!is.na(gene_ids)]
  return(paste(c(pathway_name, pathway_description, gene_ids), collapse = "\t"))
}

# Reading the input GMT file
gmt_lines <- readLines(gmt_file_path)

# Applying the symbol-to-Entrez ID replacement function to each line
gmt_lines_updated <- sapply(gmt_lines, replace_symbols_with_entrez_ids, USE.NAMES = FALSE)

# Writing the updated lines to the output file
writeLines(gmt_lines_updated, output_gmt_file_path)

# Printing a success message with the output file path
cat("The GMT file has been updated with Entrez IDs successfully and saved to: ", output_gmt_file_path, "\n")