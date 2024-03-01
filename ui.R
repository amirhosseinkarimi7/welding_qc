
library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Welding Defects Classifier"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose an image file"),
      actionButton("predict", "Predict")
    ),
    mainPanel(
      h4("Uploaded Image:"),
      imageOutput("uploaded_image"),
      h4("Prediction Results:"),
      textOutput("class_name"),
      textOutput("score")
    )
  )
)

