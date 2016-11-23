#
# server.R
#
# CORD Ministries
#
# Calculation tool for 2017 donation charges.

library(shiny)

##############
##
## This Code is run ONLY ONCE
##
##############

rm(list = ls())
library(shiny)
library(plotly)
library(plyr)
library(ggplot2)
library(reshape2)
library(RCurl)
library(formattable)

#
# Get donation data from spreadsheet as local file
#
#filePath = "C:/Users/Ken/Documents/Ken/Continuing Education/Johns Hopkins School of Public Health - Data Science 9 - Developing Data Products/CourseWork/Week 3"
#XLS_filename = paste(filePath, "/donationdetails.csv", sep="")
#rawDonationData = read.csv(XLS_filename, header = TRUE, colClasses = c("character", "character", "character", "character", "character", "character", "character", "character", "character", "character", "character"))

#
# Get donation data from spreadsheet as GitHub file
#
#XLS_filename = getURL("https://github.com/KenWade/FCFExploreDonations/raw/master/donationdetails.csv")*** Gets redirect to:
XLS_filename = "https://raw.githubusercontent.com/KenWade/FCFExploreDonations/master/donationdetails.csv"
csvTextConnection = getURL(XLS_filename)
rawDonationData = read.csv(textConnection(csvTextConnection), header = TRUE, colClasses = c("character", "character", "character", "character", "character", "character", "character", "character", "character", "character", "character"))

rawDonationData=rawDonationData[-nrow(rawDonationData), ]    # Remove last row

DonationData = rawDonationData
DonationData$Date    = as.Date(DonationData$Date, format = "%m/%d/%Y")
DonationData$Amount  = as.numeric(gsub(",","", DonationData$Amount))
DonationData$Account = substring(DonationData$Account, 16, 32)

##############
##
## Define server logic
##
##############

shinyServer(function(input, output) {
  
  ####
  #
  # Calculate zoomed in calculations of income as a reactive function
  #
  ####
  
  Income <- reactive({
    
    input$goButton
    pmin = isolate(input$sliderPerCent[1]/100)
    pmax = isolate(input$sliderPerCent[2]/100)
    lmin = isolate(input$sliderLimit[1])
    lmax = isolate(input$sliderLimit[2])
    numDays = as.numeric(max(DonationData$Date) - min(DonationData$Date))
    numMonths = numDays / (365/12)
    
    #
    # Start To Make Revenue Model of N+1 by N+1 Matrix
    #
    # Make the matrix something like 0.0, 0.5, 1.0, 1.5, 2.0 so it includes both 0 and the Max
    #
    
    N = 100 + 1
    MCORD <- matrix(data = 0, nrow=N, ncol=N)
    
    for (l in 1:N)    # Limit Loop
    {
      l_amount = ((l-1)/(N-1))*(lmax-lmin) + lmin
      for (p in 1:N)  # Percent Loop
      {
        p_amount = ((p-1)/(N-1))*(pmax-pmin) + pmin
        
        DonationData$fees = DonationData$Amount * p_amount
        DonationData$fees[DonationData$fees > l_amount] = l_amount
        MCORD[l, p] = sum(DonationData$fees)
        
      }
    }
    
    mMCORD <- melt(MCORD)
    names(mMCORD) <- c("Limit","Percent","Income")
    mMCORD$Limit <- (mMCORD$Limit-1)/(N-1)*(lmax-lmin) + lmin
    mMCORD$Percent <- 100*((mMCORD$Percent-1)/(N-1)*(pmax-pmin) + pmin)
    mMCORD$Income = (mMCORD$Income / numMonths)
    mMCORD
  })
  
  #
  # Make the plot of the donations
  #
  
  output$DonationIncomePlot<-renderPlotly({
    
    input$goButton
    target = isolate(input$incomeTarget)

    gg <- ggplot(Income(), aes(Limit, Percent)) + geom_tile(aes(fill = Income), colour = "white") + 
      labs(title=paste("Cord Ministries Income From Donations", sep=""), x="PerCent Limit in US$", y="PerCent") +
      scale_fill_gradient2(limits=c(0, max(Income()$Income)), low = "red", mid = "white", high = "blue",
                           midpoint = target, space = "Lab")
    ggplotly(gg)
  })
  
  ####
  #
  # Generate Histogram:
  #
  ####
  
  output$histoplot = renderPlotly({
    interestingAmount = DonationData$Amount[(DonationData$Amount >= input$sliderHisto[1]) &
                                              (DonationData$Amount <= input$sliderHisto[2])]
    lengthInterestingAmount = length(interestingAmount)
    
    plot_ly(x=interestingAmount, type="histogram") %>%
      layout(title=paste("Distrubution of ",lengthInterestingAmount, " (",
                         round(100*lengthInterestingAmount/nrow(DonationData),1),
                         "%) Donations", sep=""),
             xaxis=list(title="Donation Amount (in US$)"),
             yaxis=list(title="Number of Donations")
      )})
  
  ####
  #
  # Generate Project Graph
  #
  ####
  
  output$projectplot = renderPlotly({
    plot_ly(GivingStats, x=~NumberOfDonations, y=~ProjectTotal, mode="markers", type="scatter",
            color = ~as.factor(Account), size=~AvgProjectDonation) %>%
      layout(title="# of Donations  vs.  Year-to-Date Total",
             xaxis=list(title="Year-to-Date # of Donations (Radius = Avg Project Donation in US$)"),
             yaxis=list(title="Project Year-to-Date Total Donations in US$"))
  })
  
  ####
  #
  # Generate Sidebar Information
  #
  ####
  
  output$FirstLast = renderText({paste(min(DonationData$Date), " to ", max(DonationData$Date), sep="")})
  output$MinMaxAvg = renderText({paste( "Min: ", accounting(min(DonationData$Amount), 2),
                                        " Max: ", accounting(max(DonationData$Amount), 2),
                                        " Avg: ", accounting(mean(DonationData$Amount), 2), sep="")})
  output$max = renderText({max(DonationData$Amount)})
  output$numberOfDonations = renderText(nrow(DonationData))
  output$totalDonations = renderText(accounting(sum(DonationData$Amount)))
#  numDays = as.numeric(max(DonationData$Date) - min(DonationData$Date))
#  numMonths = numDays / (365/12)
#  output$days = renderText(numDays)
#  output$months = renderText(numMonths)
})
