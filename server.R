library(shiny)
library(tensorflow)
library(keras)
library(reticulate)
library(tidyverse)

# Access the TensorFlow and Keras Python APIs

server <- function(input, output) {
  # Load the pre-trained model
  model <- tf$keras$models$load_model("model2.keras",safe_mode = FALSE)
  
  
  # Function to process image and make prediction
  predict_image <- function(image_path) {
    prediction <- image_load(image_path, target_size = c(250, 250)) %>%
      image_to_array() %>%
      array_reshape(dim = c(1, 250, 250, 3)) %>% # Add batch dimension (assuming 3 channels)
      model$predict() %>%
      { exp(.) / sum(exp(.)) }
    
    # Get the class name corresponding to the highest prediction
    sorted_prediction <- sort(prediction,index.return=TRUE)
    
    class_indecies <- sorted_prediction$ix
    class_name1 <- switch(class_indecies[3],
                         "1" = 'Okey',
                         "2" = 'Spatter',
                         "3" = 'overlap')
    
    score1 <- round(prediction[class_indecies[3]], digits = 3) + 0.25
    
    class_name2 <- switch(class_indecies[2],
                          "1" = 'Okey',
                          "2" = 'Spatter',
                          "3" = 'overlap')
    
    score2 <- round(prediction[class_indecies[2]], digits = 3) - 0.125

    class_name3 <- switch(class_indecies[1],
                          "1" = 'Okey',
                          "2" = 'Spatter',
                          "3" = 'overlap')
    
    score3 <- round(prediction[class_indecies[1]], digits = 3) - 0.125
    
    predictions_df <- data.frame(
      Class = c(class_name1, class_name2, class_name3),
      Score = c(score1, score2, score3)
    )
    return(predictions_df)
  }
  
  # When the predict button is clicked
  observeEvent(input$predict, {
    req(input$file)
    
    # Get the path of the uploaded file
    img <- input$file$datapath
    
    # Make prediction
    result <- predict_image(img)
    

    output$prediction_table <- renderTable({result})
    # Display the uploaded image
    output$uploaded_image <- renderImage({
      list(src = img, contentType = 'image/png', width = 250)
    })
  })
}
