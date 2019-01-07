# FASTQ_Quality_Control
Using R Shiny, this program provides a user interface to quickly investigate the quality of fastq reads. In favor of speed and convenience, a maximum of 100,000 reads will be loaded into R. This process provides a general overview of the quality of fastq reads. More thorough quality control should be performed following use of this program.
This program utilizes the Bioconductor package "ShortReads".
> The ShortReads package can be found at this link [https://www.bioconductor.org/packages//2.10/bioc/html/ShortRead.html]

Installation
------
### Required Tools
* R/RStudio
* R Shiny
* ShortReads

Data Requirements
------
### Data types
This program works with any type of fastq file. Files should have one of the following file extensions (*.fastq.gz, *.fastq, *.fq). 
### Data location
Desired fastq files should be placed in R's working directory. The user interface provides the ability to select which of these files will be investigated.
### Data size
To reduce memory costs, this program will not read in more than 100,000 fastq reads into working memory. 
If a file contains more than 100,000 reads, these reads will be randomly selected from the file.

Plotting Options
------
* Summary: Displays basic information about uploaded FASTQ file like filename, filetype, GC content, number of reads, and average read length.
* Per Cycle Quality: Plots histograms showing the distribution of read qualities over all reads for each cycle.
* Per Cycle Base Content: Plots the frequency of bases at each cycle position.
* Distribution of Quality Scores: Shows the overall distribution of quality scores.
* Per Cycle N Content: Shows the frequency of N's over all reads for each cycle.
* Per Read GC Content: Shows the distribution of the GC content of every read as well as the expected normal distribution.
* Read Length Distribution: Shows the distribution of the length of every read.
* Overrepresented Sequences: Shows the frequency of reads that occur more than once.
