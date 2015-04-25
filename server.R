# server.R

require(shiny)
require(caret)
require(e1071)
require(randomForest)

data <- read.csv("data/smallforestcoverdata.csv")
coverclasses <- c("Spruce_And_Fir",
                  "Lodgepole_Pine",
                  "Ponderosa_Pine",
                  "Cottonwood_And_Willow",
                  "Aspen",
                  "Douglas_Fir",
                  "Krummholz")
thesplit <- sample(1:dim(data)[1],500)
tr <- data[thesplit,]

# Define server logic
shinyServer(function(input, output) {
  
  bigmodel <- train(form=formula("CoverType~."),data=tr,method="rf",
                    trControl=trainControl(classProbs=TRUE))
  
  output$buildmessage <- renderText({
    withProgress(message="Growing random forest.  May take several minutes.  Please be patient!",
                 {modelBuilder()})
  })
  
  output$numberofsamples <- renderUI({
    sliderInput("numberofsamples","Number of samples for model building:",500,min=50,max=1500)
  })
  
  output$modelbutton <- renderUI({
    actionButton("modelbutton",label="Rebuild the model")
  })
  
  output$predictbutton <- renderUI({
    actionButton("predictbutton",label="Predict forest cover type")
  })
  
  output$coverclassprobs <- renderTable({
    withProgress(message="Using random forest to predict, please wait!",
      {predictions()}
    )
  })

  modelBuilder <- eventReactive(input$modelbutton,{
    thesplit <- sample(1:dim(data)[1],input$numberofsamples)
    tr <- data[thesplit,]
    bigmodel <<- train(form=formula("CoverType~."),data=tr,method="rf",
                       trControl=trainControl(classProbs=TRUE))
    return("All done.")
  })
  
  predictions <- eventReactive(input$predictbutton,{
    df<- data.frame(Elevation=input$elevation,
                    Aspect=input$aspect,
                    Slope=input$slope,
                    Horizontal_Distance_To_Hydrology=input$hdisttohydro,
                    Hillshade_Noon=input$shadenoon)
    z <- predict(bigmodel,df,"prob")
    z[,order(-z)]
  })
  
})