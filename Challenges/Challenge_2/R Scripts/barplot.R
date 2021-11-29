# Data Science in Ecological and Environmental Sciences Challenge 2- Data Journalism 
# Created: 31/10/2021
# Edited by: Anna Cumming (s1950955@ed.ac.uk) and Mathis Gillio (s1843841@ed.ac.uk)

# This script creates a barplot of the percentage change in emergency oil stocks
# in European countries following the increase in oil prices in April 2021 based
# on data from the following link:
# https://ec.europa.eu/eurostat/databrowser/view/nrg_stk_oem/default/table?lang=en

# 1. Libraries ----
library(tidyverse) #  Includes dplyr (for data manipulation) and ggplot2 (for data visualisation)
library(ggthemes)  #  Extra themes, geoms and scales for ggplot2
library(gridExtra) #  Plot arrangement
library(RColorBrewer) # Allows us to pick a colour gradient 

# 2. Load the Data ----

# Load European emergency oil stocks data.
emergency_oil_stocks <- read.csv("Data/emergency-oil-stocks.csv")

# Explore the European emergency oil stocks data.
head(emergency_oil_stocks)  # show top 6 rows of data 
summary(emergency_oil_stocks) # gives a summary of oil_data
str(emergency_oil_stocks)  # tells you the nature of the variables 
                           # (continuous, integers, categorical or characters)

# 3. Tidy Dataset ----
# Change name of first column to "Countries".
names(emergency_oil_stocks)[1]<-paste("Countries")

# Remove columns and rows with incomplete data and calculate percentage change 
# in emergency oil stocks for each European country that remains.
oil_data <- emergency_oil_stocks %>% 
              filter(!(Countries=="")) %>%  # remove excess rows
              filter(is.finite(Jul.21)) %>%    # remove rows with insufficient data   
                                               # can also use drop_na(Jul.21)
              select(!("Aug.21")) %>% # very few countries have data for August 
                                      # and this affects the mean calculations :(
              mutate(mean_before = rowMeans(select(., Jan.21:Apr.21)), #  create column for 
                    # first half of the year (until April)
                   mean_after = rowMeans(select(., May.21:Jul.21)), #  create column for 
                   # second half of the year (post April)
                   percentage_change = ((mean_after-mean_before)/mean_before)*100) %>%   
                   # create column that calculates percentage change between first half 
                   # and second half of 2021
              mutate(percentage_change = replace(percentage_change, is.na(percentage_change), 0)) %>%
              filter(percentage_change^2 >= 1) %>% #  only keeps value that show a 
                                               # percentage change greater than 1%
              mutate(ymean = mean(percentage_change)) # create a column of the average 
                                                     # percentage change in oil stocks

# Percentage change in emergency oil stocks for each European country is
# calculated by finding the mean emergency oil stocks before the price increase
# (Jan-Apr) and after (May-Jul) and using these to calculate a percentage.

# 4. Create Barplot ----

# Define theme function to be used in the barplot and that can be used for future
# plots that we produce within our newspaper :) 

theme_group2 <- function(){            # creating a new theme function
     theme(plot.title = element_text(size = 20, face = "bold"),
           plot.subtitle = element_text(size = 16, face = "plain"),
           axis.title = element_text(size = 15,
                                     face = "bold"),
           axis.text.x = element_text(size = 12,
                                      angle = 45,
                                      vjust = 1,
                                      hjust = 1, face = "bold"), 
           axis.text.y = element_text(size = 12, face = "bold"),  # define font,
           # font sizes,
           # text angle and
           # alignment
           legend.position = "none",  # remove legend
           plot.margin = unit(c(0.5,0.5,0.5,0.5), units = , "cm"),  # create plot
           # margins
           panel.grid = element_blank())
}

# Plot percentage change in emergency oil stocks for European countries.
(emergency_oil_barplot <- ggplot(oil_data,
                                 aes(x = reorder(Countries, -percentage_change),
                                     y = percentage_change)) +
   geom_bar(position = position_dodge(), # create a barplot
            stat = "identity",
            colour = "white",
            aes(fill = percentage_change)) +  # fill the bars according to
                                              # percentage change value
   scale_fill_distiller(palette = "OrRd", direction = -1) +   # apply a colour
                                                              # gradient
   labs(title = "Finland is the Biggest Investor in Emergency Oil Stocks", 
         subtitle = "Investment in emergency stocks after April rise in oil prices, 2021",
         x = "\nCountry", 
         y = "Percentage Change in Emergency Oil Stocks\n") + # add title,
                                                              # subtitle and
                                                              # axis labels
    theme_group2() +  # apply the theme that we created earlier 
    ylim(-3, 10) +  # rescale y-axis limits
    scale_y_continuous(breaks = c(-2,0,2,4,6,8,10),
                       labels = function(x) paste0(x, "%")) +  # add finer 
                                                               # resolution to 
                                                               # x-axis and puts
                                                               # % after numbers
    geom_hline(aes(yintercept = ymean),
               col = "black",
               linetype = "dashed",
               size = 1) +  # create horizontal dashed line of mean percentage
                            # change
    annotate("text",
             x = 13.3,
             y = 4.2,
             label = "Average change = 3.5 %", size = 6)) + # add label to
                                                            # average line
    geom_hline(yintercept = 0, size = 0.4, colour = "black")  # create line at 
                                                             # 0% to show
                                                             # distinction
   
# 5. Save Plot ----

# Define new function to save plots both in png and pdf at the same time: 

save_plot <- function(plot_name, # first put the plot object name
                      file_name = "plot",  #give it a title 
                      width = 13, # set the width, heigh and dpi
                      height = 8, 
                      dpi = 150) {
  
  ggsave(
    paste0(file_name, ".png"), plot_name, width = width,  # save as png
    height = height, dpi = dpi) 
  
  ggsave(
    paste0(file_name, ".pdf"), plot_name, width = width, # save as pdf
    height = height, dpi = dpi
  )
}

save_plot(emergency_oil_barplot, file_name = "Plots/Emergency-oil-barplot", width = 13, 
          height = 8, dpi = 150) # use the save plot function created to save barblot

