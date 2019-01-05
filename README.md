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
* Summary:
* Per Cycle Quality:
* Per Cycle Base Content: 
* Distribution of Quality Scores:
* Per Cycle N Content:
* Per Read GC Content:
* Read Length Distribution:
* Overrepresented Sequences:  
