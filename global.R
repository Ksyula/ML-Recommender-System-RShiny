# Shiny Development Playground With Modules
#
# This is the server logic for a Shiny web application.

# Please keep all libraries here!

library("shiny")
library("shinydashboard")
library("data.table")
library("arules")
library("DT")
library("arulesViz")
library("shinycssloaders")


# Load shiny modules by listing all R files in the workspace and filtering
# to those that contain "modules" in their path (i.e. the folder)
fileSources <- list.files(pattern = "*.R", recursive = T)
fileSources <- fileSources[grepl("modules", fileSources)]
sapply(fileSources, source, .GlobalEnv)


