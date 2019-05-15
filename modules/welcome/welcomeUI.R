welcomeUI <- function(id){
  ns <- NS(id)
  
  fluidPage(
    headerPanel(title = "Welcome"), 
    wellPanel(
      fluidRow(
        column(width = 12,
               h5("This is a prototype of Recommender System to recommend loyalty cards to customers."),
               br(),
               p("Assume the case where customers have some loyalty cards of different brands in their wallets."), 
               p("Customer 1 has cards of brands A, B, C, D, E whereas customer 2 has cards of A, B, C, D. The Recommender System will recommend to customer 2 to consider the possibility of getting the loyalty card of the brand E because he has a similar taste on brands with customer 1 based on similarity of their wallets' content." ),
               br()
        )
      )
    )
  )
}

welcome <- function(input, output, session) {
  # set namespace
  ns <- session$ns
  
}
