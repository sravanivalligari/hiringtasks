#!/bin/bash

# Defining the FASTA file URL
fasta_url="https://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.faa"
fasta_file="NC_000913.faa"

# Downloading the FASTA file
curl -o ${fasta_file} ${fasta_url}

# Checking if the FASTA file is downloaded
if [ ! -f ${fasta_file} ]; then
    echo "Failed to download the FASTA file."
    exit 1
fi

# Counting the number of sequences in the FASTA file
num_sequences=$(grep -c '^>' ${fasta_file})
echo "Number of sequences: $num_sequences"
#!/bin/bash

# Defining the URL from which to download the FASTA file.
fasta_url="https://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.faa"

# Specifing the name of the file to save the downloaded FASTA data.
fasta_file="NC_000913.faa"

# Using curl to download the FASTA file from the specified URL and save it to the designated file name.
curl -o ${fasta_file} ${fasta_url}

# Checking if the FASTA file has been successfully downloaded by verifying its presence.
# If the file is not found, print an error message and exit the script with a status code of 1.
if [ ! -f ${fasta_file} ]; then
    echo "Failed to download the FASTA file."
    exit 1
fi

# Counting the number of sequences in the FASTA file.
num_sequences=$(grep -c '^>' ${fasta_file})
echo "Number of sequences: $num_sequences"

# Calculating the total number of amino acids in the FASTA file by excluding header lines.
# removing newline characters to concatenate all sequences into a single line, and then counting the characters.
total_amino_acids=$(grep -v '^>' ${fasta_file} | tr -d '\n' | wc -c)
echo "Total number of amino acids: $total_amino_acids"

# If there are sequences present (num_sequences > 0), then we calculate the average protein length by dividing
# the total number of amino acids by the number of sequences. The result is printed to the console.
# If no sequences are found, print an error message and exit the script with a status code of 2.
if [[ $num_sequences -gt 0 ]]; then
    average_length=$(awk "BEGIN {print $total_amino_acids / $num_sequences}")
    echo "The average protein length is: $average_length"
else
    echo "No sequences found."
    exit 2
fi

# Now, Count the total number of amino acids in the FASTA file
total_amino_acids=$(grep -v '^>' ${fasta_file} | tr -d '\n' | wc -c)
echo "Total number of amino acids: $total_amino_acids"

# Then, Calculate and print the average protein length
if [[ $num_sequences -gt 0 ]]; then
    average_length=$(awk "BEGIN {print $total_amino_acids / $num_sequences}")
    echo "The average protein length is: $average_length"
else
    echo "No sequences found."
    exit 2
fi