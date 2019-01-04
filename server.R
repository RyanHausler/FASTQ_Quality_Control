# Server Side

# Install Recquired Packages
list.of.packages <- c("ShortRead", "BiocManager", "shiny", "shinyjs")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


library(shiny)
library(shinyjs)
library(BiocManager)
library(ShortRead)

shinyServer(function(input, output) {
  
  # Can't press submit until file is chosen
  observe({
    shinyjs::toggleState("submit", !is.null(input$File) && input$File != "")
  })
  
  # Update path when file is chosen and submit is pressed
  path = eventReactive(input$submit, {
    paste('C:\\Users\\Ryan\\Box Sync\\RNA-Seq Workflow\\Data\\', input$File, sep="")
  })
  
  # Reload fastq object ONLY when submit is pressed
  fq_object = eventReactive(input$submit, {
    # Hiding plots/tables and displaying loading icon when fastq is being loaded
    shinyjs::hide("graph")
    shinyjs::hide("summary")
    shinyjs::hide("Overrepresented")
    shinyjs::show("loading-content")
    Sys.sleep(.5)
    fq = FastqSampler(path(), 100000)
    fq = yield(fq)
    shinyjs::hide("loading-content")
    shinyjs::show("graph")
    shinyjs::show("summary")
    shinyjs::show("Overrepresented")
    return(fq)
  })
  
  # Plotting
  output$graph <- renderPlot({
    # Won't run until these are acquired
    req(input$File)
    req(input$submit)
    req(input$plot)
    input$submit
    # Acquire fastq object
    fq = fq_object()
    qa_matrix = as(quality(fq), 'matrix')
    read_fq = sread(fq)
    m = function(x){return(mean(x, na.rm=TRUE))}
    # Displays Per Cycle Quality plot when it is selected
    if(input$plot == 'Per Cycle Quality'){
      boxplot(qa_matrix, use.rows=TRUE, ylim=c(min(qa_matrix, na.rm=TRUE)-2, max(qa_matrix, na.rm=TRUE)+2),
              range=3, outline=FALSE, col='gold', lwd=1.25, whisklty=1,
              main='Per Base Quality',
              xlab='Read Position',
              ylab='Quality Score')
      lines(loess(apply(qa_matrix, 2, m) ~ c(1:dim(qa_matrix)[2]), span=0.5), lwd=1.5, col='green4')
    }
    # Displays Per Cycle Base Content plot when it is selected
    else if(input$plot == 'Per Cycle Base Content'){
      base_freq = alphabetByCycle(read_fq)[c("A", "C", "G", "T"),]
      plot(base_freq[1,], col=1, main='Base Content Across Cycles', xlab='Read Position', ylab='Base Frequency', ylim=c(min(base_freq)-.05, max(base_freq)+.05))
      lines(base_freq[1,], col=1)
      points(base_freq[2,], col=2)
      lines(base_freq[2,], col=2)
      points(base_freq[3,], col=3)
      lines(base_freq[3,], col=3)
      points(base_freq[4,], col=4)
      lines(base_freq[4,], col=4)
      legend("bottomright",legend=c('A','C','G','T'), col=c(1,2,3,4), pch=1)
    }
    # Displays Distribution of Quality Scores plot when it is selected
    else if(input$plot == 'Distribution of Quality Scores'){
      tab = table(qa_matrix)
      plot(tab, main='Distribution of Quality Scores', ylab='Frequency of Score', xlab='Score', 
           xaxt="n", col='white')
      di = as.numeric(names(tab)[dim(tab)])
      axis(1, at = seq(0, di, by = 1), las=2)
      lines(as.vector(tab) ~ as.numeric(names(tab)), col='darkred', lwd=2)
    }
    # Displays Per Cycle N Content plot when it is selected
    else if(input$plot =='Per Cycle N Content'){
      plot(alphabetByCycle(read_fq)["N",] / length(read_fq), ylim=c(0,1), col='white',
           main='Per Base N Content', xlab='Read Position', ylab='Percentage N across all reads')
      lines(alphabetByCycle(read_fq)["N",] / length(read_fq), col='red')
    }
    # Displays Per Read GC Content plot when it is selected
    else if(input$plot == 'Per Read GC Content'){
      gc_content = rowSums(alphabetFrequency(read_fq)[,c("G", "C")]) / width(fq)
      d = density(gc_content)
      hist(gc_content, main='Per Sequence GC Content', ylim=c(0,max(d$y)+.5),
           xlab='GC Content', ylab='Density of GC Content', freq=FALSE)
      curve(dnorm(x, mean=mean(gc_content), sd=sd(gc_content)), 
            col="darkblue", lwd=2, add=TRUE, yaxt="n")
      legend('topright', col='blue', lty=1, legend='Theoretical Normal Distribution')
    }
    # Displays Read Length Distribution plot when it is selected
    else if(input$plot == 'Read Length Distribution'){
      tab = table(width(fq))
      min = as.numeric(names(tab)[1]) - 1
      begin = 0
      names(begin) = as.character(min)
      max = as.numeric(names(tab)[dim(tab)]) + 1
      end = 0
      names(end) = as.character(max)
      plot(as.table(c(begin,tab,end)), main='Distribution of Read Lengths', ylab='Frequency of Length', xlab='Read Length', 
           xaxt="n", col='white')
      axis(1, at = seq(min, max, by = 1), las=2)
      lines(c(0, as.vector(tab), 0) ~ c(min, as.numeric(names(tab)), max), col='darkred', lwd=2)
    }
  })
  
  # Renders the summary table
  output$summary <- renderTable({
    req(input$File)
    req(input$plot)
    fq = fq_object()
    qa_matrix = as(quality(fq), 'matrix')
    Measure = c('Filename', 'File type', 'Total Sequences', 'Average Sequence Length', 'GC Content')
    gc = alphabetFrequency(sread(fq))[,c("G", "C")]
    Value = c(input$File, 'FASTQ', dim(qa_matrix)[1], mean(width(fq)), mean(rowSums(gc) / width(fq)))
    as.matrix(data.frame(Measure, Value))
  })
  
  # Renders a table for overrepresented sequences
  output$Overrepresented <- renderTable({
    req(input$File)
    req(input$plot)
    fq = fq_object()
    # The top 10 sequences
    head(table(sread(fq)), 10)
  })
})



