# Define server logic for random distribution application
shinyServer(function(input, output) {

s  ## Generate a summary of the data
  output$summary <- renderPrint({
    summary(datGlobal)
  })

  ## Generate an HTML table view of the data
  output$table <- renderDataTable({
    datGlobal
  }, options = list(lengthMenu = c(5, 30, 50, 150), pageLength = 5))

})
