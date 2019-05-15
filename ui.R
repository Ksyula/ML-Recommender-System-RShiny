# eBiz Visual Graph Analytics
#
# This is the user-interface definition of a Shiny web application.

appName <- "Loyalty Cards"

dashboardPage(skin = "blue",
              dashboardHeader(title = appName, 
                              tags$li(tags$a("A prototype of the Recommender System for Loyalty cards users."), class="dropdown")),
              dashboardSidebar(shinyjs::useShinyjs(),
                               collapsed = FALSE,
                               # ceate sidebarMenu in server side because it depends on the data
                               # loaded in server
                               sidebarMenuOutput("sidebarMenu") %>% withSpinner),
              dashboardBody(
                tags$head(HTML('<link rel="stylesheet" href="css/style.css" />')),
                # while sidebarMenu is loading, show welcome UI as startup page
                div(
                  id = "startup_page",
                  welcomeUI("welcome")),
                tabItems(
                  tabItem(tabName = "tab_welcome", welcomeUI("welcome")),
                  tabItem(tabName = "tab_recommendation", recommendationUI("recommendation"))
                )
              )
)