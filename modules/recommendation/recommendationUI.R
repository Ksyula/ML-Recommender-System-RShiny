# This module shows the balance of a particular tenant id, ibannumber

recommendationUI <- function(id) {
  ns <- NS(id)
  fluidPage(headerPanel(title = "Card recommendations"), 
            helpText("Choose  a customer to see recommendations"),
            wellPanel(fluidRow(column(width = 12, uiOutput(ns("customer_select")),
                                                  tags$h5(HTML("<strong> His cards: <strong>")),
                                                  tags$h5(htmlOutput(ns("selected_customer_cards")))))),
            
            mainPanel(tabsetPanel(type = "tab",
                                  tabPanel("Customer Recommendations",
                                            tags$h5("Recommended cards:"),
                                            tags$br(),
                                            fluidRow(column(width = 12, uiOutput(outputId = ns("Apriori_Account_Recommendations")))),
                                            tags$br(),
                                            box(DTOutput(outputId = ns('Apriori_Account_suitableRules')), title = "Suitable Apriori rules:", width = 12, solidHeader = T, collapsible = T, collapsed = T)),
                                  tabPanel("Apriory Plot",
                                            helpText("Scatter plot where dots are relevant rules with high support and confidence rates."),
                                            tags$br(),
                                            fluidRow(column(width = 6, plotOutput(outputId = ns("Apriori_Account_Recommendations_Plot")))))
                                                                                                                     
                 ), width = 12
                )
            )
}


recommendation <- function(input, output, session, data, Apriori_Matrix, Apriori_Rules) {
  ns=session$ns

######################################## Choose customer:
  
  output$customer_select<- renderUI({
      selectizeInput(ns('SelectedCustomer'), label = 'Choose a customer', choices = data$customer)
    })

  Customer <- reactive({
    validate(need(input$SelectedCustomer, "Choose customer!"))
    input$SelectedCustomer
  })
  
  Customer_cards <- reactive({data[customer == Customer()]$card})
  
  output$selected_customer_cards <- renderUI({HTML(paste0(seq(1,length(Customer_cards())), " ", as.character(Customer_cards()), " <br>"))})


  ####### Bild recommendations for selected Company name:
  Apriori_Account_suitableRules_indices <- reactive({
    # Bild account basket from full Apriori_Matrix by extracting only one row corresponded to Account name
    # From Apriori Matrix extract an account row, which contains TRUE for occured Recipient Codes:
    basket <- Apriori_Matrix[customer == Customer()]
    # Convert the set of Recipients' codes to Account basket:
    # Drop the transaction ID and create a logic matrix:
    basket <- as.matrix(basket[,-1])
    # Clean up the missing values to be FALSE
    basket[is.na(basket)] <- FALSE
    # Clean up names
    colnames(basket) <- gsub(x=colnames(basket), pattern="const\\.", replacement="")
    basket <- as(basket, "transactions") # convert 1-row Account matrix to 'transactions' class
    # Scan LHS parts of rules to find sutable matches with customer basket:
    rulesMatchLHS <- is.subset(Apriori_Rules@lhs, basket)
    # Searching for indices of rules having the same LHS parts
    suitableRules <-  rulesMatchLHS & !(is.subset(Apriori_Rules@rhs,basket))
    # Set of sutable for selected account rules
    suitableRules
  })
  
  output$Apriori_Account_suitableRules <- renderDT({
    inspect(Apriori_Rules[as.logical(Apriori_Account_suitableRules_indices())])
  })
  
  Recommended_cards <- reactive({unique(unlist(LIST((Apriori_Rules[as.logical(Apriori_Account_suitableRules_indices())]@rhs))))})
  
  output$Apriori_Account_Recommendations <- renderUI({
    validate(need(Recommended_cards(), "Sorry, we don't have reliable recommendations for this customer. Either he hasn't had enough cards yet or other customers have very different loyalty cards sets."))
    HTML(paste0("<strong> ", seq(1,length(Recommended_cards())), " ", as.character(Recommended_cards()), " <strong> <br>"))
  })
  
  output$Apriori_Account_Recommendations_Plot <- renderPlot({
    plot(Apriori_Rules[as.logical(Apriori_Account_suitableRules_indices())], measure = c("support", "confidence"), shading = "lift", jitter = 0)
  })
}
