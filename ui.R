#
# ui.R
#
# CORD Ministries
#
# Calculation tool for 2017 donation charges.

library(shiny)
library(plotly)

##############
##
## Define UI for application
##
##############

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Cord Ministries Donation Income Investigation Tool"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      h2("Donation Data:"),
      h3("Number of Donations:"),
      textOutput("numberOfDonations"),
      h3("Date Range:"),
      textOutput("FirstLast"),
#      h3("Days Months"),textOutput("days"),textOutput("months"),
      h3("Donation Amount: "),
      textOutput("MinMaxAvg"),
      h3("Total Donations:"),
      textOutput("totalDonations")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Donation Overview",
                           br(),
                           plotlyOutput("histoplot"),
                           br(),
                           sliderInput("sliderHisto", "Select Min & Max Donation Values:",
                                       value=c(0,500), min = 0, 30000, step=10)
                  ),
                  tabPanel("Income Calculation",
                           br(),
                           plotlyOutput("DonationIncomePlot"),
                           br(),
                           fluidRow(
                             column(6,
                                    numericInput("incomeTarget", "Income Target (in US$):", 
                                                 value = 500, min = 0, max = 2000, step = 1),
                                    sliderInput("sliderPerCent", "Pick Min and Max PerCent Values:",
                                                min=0, max=50, value = c(0, 10), step=0.10)
                             ),
                             column(6,
                                    br(),
                                    actionButton("goButton","Submit (This may take a couple moments.)"),
                                    br(),
                                    br(),
                                    sliderInput("sliderLimit", "Pick Min and Max Fee Limit Values:",
                                                min=0, max=1000, value = c(0, 200), step=10)
                             )
                           )
                  )
      )
    )
  )
))
