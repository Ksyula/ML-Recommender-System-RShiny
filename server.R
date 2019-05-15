values <- reactiveValues(recommendation_initialized = FALSE,
                         egonetwork_initialized = FALSE,
                         data_loaded = FALSE)

shinyServer(function(input, output, session) {
  # output sidebar menu only after necessary data has been read from database
  output$sidebarMenu <- renderMenu({
    s <- sidebarMenu(id = "tabs",
                     # here are the menu items
                     # find icons here: https://fontawesome.com/v4.7.0/icons/
                     menuItem("Welcome", tabName = "tab_welcome", icon = icon("dashboard"), selected = TRUE),
                     menuItem("Card Recommendation", tabName = "tab_recommendation", icon = icon("line-chart"))
    )
    values$data_loaded = TRUE
    return(s)
  })
  
  # when data has been loaded from db and sidebarMenu is shown, hide startup page
  observeEvent(values$data_loaded, {
    shinyjs::hide("startup_page")
  })
  
  data <- fread("Cards_.csv")
  ######################################## Recommendation based on association rules mining
  ####### Association Rules Calculation:
  # Bild Apriori_Matrix as an auxiliary initial object for: 
  # 1. mining Associations Rules; 
  # 2. mining account basket of selected customer
  Apriori_Matrix_Calculation <- function(data){
    validate(need(data, "Calculate Recommendations"))
    # Converting to a logic Matrix 
    data$const <- TRUE
    # Need to reshape the matrix
    apriori_input_matrix_full <- reshape(data = data, idvar = "customer", timevar = "card", direction = "wide")
    # Clean up the missing values to be FALSE
    apriori_input_matrix_full[is.na(apriori_input_matrix_full)] <- FALSE
    return(apriori_input_matrix_full)
  }
  
  # Mine Associations Rules set over entire set
  Calculate_Apriori_Rules <- function(Apriori_Matrix){
    # Drop the customers and creale logic matrix contains TRUE-FALSE
    apriori_input_matrix <- as.matrix(Apriori_Matrix[,-1])
    # Clean up names
    colnames(apriori_input_matrix) <- gsub(x=colnames(apriori_input_matrix),
                                           pattern="const\\.", replacement="")
    # convert to 'transactions' class (apriori_input_matrix is logic matrix: it's required for as())
    tData <- as(apriori_input_matrix, "transactions") 
    rules <- apriori(tData, parameter = list(supp = 0.01, conf = 0.75, minlen = 2, maxlen=12), control = list(verbose = FALSE))
    # Order rules by decreasing support
    rules_support <- sort(rules, by="support", decreasing=TRUE)
    return(rules_support)
  }
  Apriori_Matrix <- Apriori_Matrix_Calculation(data)
  Apriori_Rules <- Calculate_Apriori_Rules(Apriori_Matrix)
  # observe menu tabs and call modules once to initialize the first time that
  # the relevant menu item is selected

  callModule(recommendation, "recommendation", 
                 data,
                 Apriori_Matrix,
                 Apriori_Rules)
  session$onSessionEnded(stopApp)
})

