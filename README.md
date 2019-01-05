# FASTQ_Quality_Control
Using R Shiny, this program provides a user interface to quickly investigate the quality of fastq reads. 
This program utilizes the Bioconductor package "ShortReads".
> The ShortReads package can be found here [https://www.bioconductor.org/packages//2.10/bioc/html/ShortRead.html]

Installation
------
## Required Tools
*R/RStudio
*R Shiny
*ShortReads

Data Requirements
------
### Data types
This program works with any type of fastq file.
### Data location
Desired fastq files should be placed in the R's working directory.
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
