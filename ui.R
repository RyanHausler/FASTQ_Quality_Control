# User Interface Side

# Install required packages
list.of.packages <- c("shiny", "shinyjs")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(shiny)
library(shinyjs)



shinyUI(fluidPage(
  useShinyjs(),
  includeCSS("animate.css"),

  # Application title
  titlePanel("FASTQ Quality Control", windowTitle ='FASTQ QC'),
  
  # Sidebar
  sidebarLayout(
    
    # Choose file located in working directory
    # A file browser is not provided as this app may be run on a private server. 
    # When running locally, a directory for file storage can be personalized below (~)
    sidebarPanel(
      selectInput("File", "Select a File:",
                  choices = c(list.files('~', pattern=c('*.fastq.gz', '*.fastq', '*.fq')), ""),
                              selected=""
      ),
      
      # Submit/update file
      actionButton('submit', "Submit"),
      
      br(),
      br(),
      
      # Select plot type
      selectInput("plot", "Select a plot:",
                  choices = c('Per Cycle Quality', 
                              'Per Cycle Base Content', 
                              'Per Cycle N Content',
                              'Distribution of Quality Scores',
                              'Per Read GC Content',
                              'Read Length Distribution'))
    ),
    # Main Panel
    mainPanel(
      # Loading message
      hidden(
        div(id = "loading-content",
          class = "loading-content",
          h2(class = "animated infinite pulse", "Loading data...")
        )
      ),
      # Summary, plot, and overrepresented sequences are given separate tabs
      tabsetPanel(type = "tabs",
        tabPanel("Summary", tableOutput("summary")),
        tabPanel("Plots", plotOutput("graph")),
        tabPanel("Overrepresented Sequences", tableOutput("Overrepresented"))
      )
    )
  )
))
