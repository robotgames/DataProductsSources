# ui.R

library(shiny)

# Define UI 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Random Forest Model for Predicting Forest Cover"),
  
  # Sidebar layout
  sidebarLayout(position="right",
    sidebarPanel(
      h4("Environmental Variables"),
      sliderInput("elevation","Elevation:",
                   3000,min=2000,max=3500),
      sliderInput("aspect","Aspect:",
                   120,min=0,max=360),
      sliderInput("slope","Slope:",
                   12,min=0,max=60),
      sliderInput("hdisttohydro","Horizontal Distance to Hydrology:",
                   200,min=0,max=1000),
      sliderInput("shadenoon","Hillshade at noon:",
                   220,min=0,max=250)
      
    ),
    
    mainPanel(
      h4("Background"),
      p("This app explores the forest cover type data set, 
        available at",a("http://archive.ics.uci.edu/ml/datasets/Covertype",
                        href="http://archive.ics.uci.edu/ml/datasets/Covertype"),
        ".  The description of the data set and variables can be found at ",
        a("http://archive.ics.uci.edu/ml/machine-learning-databases/covtype/covtype.info",
          href="http://archive.ics.uci.edu/ml/machine-learning-databases/covtype/covtype.info"),
        ".  In brief, one of 7 types of forest cover are predicted based on the
        values of a number of environmental variables."),
      p("Detailed instructions are provided below."),
      h4("Model building and prediction (available after initialization)"),
      p(strong("Loading and initial model build may take up to two minutes.  
               Buttons will appear when predictions can be made.  
               Please be patient!"),style="color:red"),
      p(strong("Predict the forest cover type!")),
      uiOutput("predictbutton"),
      p("The predictions on forest cover type, from most likely to 
        least with probabilities, are:"),
      tableOutput("coverclassprobs"),
      br(),
      p("To rebuild the model, select the number of samples to draw randomly from the 
                data to build the random forest model.  Rebuilding the model may 
                take 1-2 minutes."),
      uiOutput("numberofsamples"),
      uiOutput("modelbutton"),
      textOutput("buildmessage"),
      h4("Instructions"),
      p("In the sidebar to the right, set the values of the environmental
        variables.  Then, set the size of the random sample to draw from the
        original data set, below.  A larger sample will lead to higher
        accuracy, but will require more time to build the model and make
        predictions.  We find that a sample size of about 500 works nicely,
        and larger samples do not increase accuracy overly much."),
      p("Once the model is built and values for environmental variables set,
        predict the forest cover type.  A list of types is produced, with the
        probability that the variable values provided have each forest cover
        type (types are produced sorted from highest to least likelihood).")
    )
)
))