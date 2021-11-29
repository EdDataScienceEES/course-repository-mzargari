################################################################################
##  Data Science in Ecological and Environmental Sciences - Data Journalism   ##
##                            Challenge 2 Group 2                             ##
##                      Date completed: 3-November-2021                       ##
##                                Written by:                                 ##
##              Anna Cumming (s1950955@ed.ac.uk, @annacumming)                ##
##              Lucas Lillelund (s1864014@ed.ac.uk, @loulillelund)            ##
##              Mathis Gillio (s1843841@ed.ac.uk, @mathisgillio)              ##
##              Tirso Ordaz García (s2139514@ed.ac.uk, @tirsoordaz)           ##
##                                 Edited by:                                 ##
##               Michael Zargari (s2253374@ed.ac.uk, @mzargari)               ##
################################################################################

#                               Purpose of Script:                                   #
#                                                                                    #
#   This script creates a map of European countries and shows how much emergency oil #
#     stock they have based off of the number of days their reserves will last them. #
#   This script also creates a boxplot of the percentage change in emergency oil     #
#      stocks in European countries following the increase in oil prices in          #
#              April 2021. We then get both outputs and combine them to              #
#                            output within a single panel                            #
#                                                                                    #     
#             These conclusions are based on data from the following link:           #
#  https://ec.europa.eu/eurostat/databrowser/view/nrg_stk_oem/default/table?lang=en  #

# 1. Installing Packages ----

# install.packages("tidyverse")
# install.packages("sf")
# install.packages("ggthemes")
# install.packages("gridExtra")
# install.packages("RColorBrewer")

# 2. Load the Libraries ----

library(tidyverse)           # For cleaning/wrangling data                    
library(sf)                  # For plotting map data              
library(ggthemes)            # Extra themes, geoms and scales for ggplot2
library(gridExtra)           # Plot arrangement
library(RColorBrewer)        # Allows us to pick a colour gradient 


# 3. Import the data ----

emergency_oil_stocks <- read.csv("Data/emergency-oil-stocks.csv")

# Explore the data to see what it looks like 

# Explore the European emergency oil stocks data.
head(em_oil_stocks)     # show top 6 rows of data 
str(em_oil_stocks)      # tells you the nature of the variables 
                        # (continuous, integers, categorical or characters)

# 4. Clean the data ----
# We decided to exclude Aug.21 from map data due to too many NA values

# Change name of first column to "Countries".
names(emergency_oil_stocks)[1] <- paste("Countries")

# We decided to exclude Aug.21 from map data due to too many NA values
oil_data <- emergency_oil_stocks %>% 
  filter(!(Countries=="")) %>%  # remove excess rows
  select(!("Aug.21"))           # very few countries have data for August 
  
# 5. Create a common theme ----

# Define a theme function to be used in the barplot and that can be used for future
# plots that we produce within our newspaper :) 

theme_group2 <- function(){            # creating a new theme function
  # define font, font sizes, text angle and alignment
  theme(plot.title    = element_text(size = 20, 
                                     face = "bold"),
        plot.subtitle = element_text(size = 16, 
                                     face = "plain"),
        axis.title    = element_text(size = 15,
                                     face = "bold"),
        axis.text.x   = element_text(size = 12,
                                     angle = 45,
                                     vjust = 1,
                                     hjust = 1, 
                                     face = "bold"), 
        axis.text.y   = element_text(size = 12, 
                                     face = "bold"),
        legend.position = "none",                                # remove legend
        plot.margin = unit(c(0.5,0.5,0.5,0.5), units = , "cm"),  # create plot margins
        panel.grid = element_blank())
}

# 6. Create the map ---- 
# Showing average European emergency oil stocks data 

# i. Transform the data set ----
oil_data_map <- oil_data %>%
  rowwise() %>% # Get mean over rows
  mutate(Avg_em_stocks = mean(c(Jan.21, Feb.21, Mar.21, Apr.21, May.21, Jun.21, Jul.21)))
# Create a mean column of our oil stock data from Jan. to July 2021

# Set default map background colors to black & white
theme_set(theme_bw())

# Merge countries coordinates with emergency stock data and arrange data

world_map <- map_data("world") %>% # Create dataframe for coordinates of all countries
  rename("Countries" = "region")   # Rename "region" column to "Countries"

oil_data_complete_map <- left_join(world_map, oil_data_map, by = "Countries")

oil_data_complete_map <- oil_data_complete_map %>% 
  filter(!is.na(oil_data_complete_map$Avg_em_stocks)) %>% 
  subset(select = -c(Jan.21:Jul.21))  # get rid of rows w/ NA values in mean column

# ii. Create the map of EU  ----
# showing countries emergency oil stocks

(emergency_oil_map <- ggplot(oil_data_complete_map, aes(x = long, y = lat, group = group)) +
   geom_polygon(aes(fill = Avg_em_stocks), color = "black") +
   labs(title = "Finland would last the longest without new imports of oil", 
        subtitle = "Remaining Emergency oil stocks in days equivalent as of 2021") +
   theme_group2() +
   scale_fill_distiller(palette = "OrRd", 
                        direction = -1, 
                        na.value = "grey50",
                        name = "Remaining Emergency\nOil Stocks (in days equivalent)") +
   coord_cartesian(xlim = c(-9, 45), ylim = c(35, 72)) + #Scale to the map to UK size
   theme(legend.position = c(0.15, 0.85),
         legend.text = element_text(size = 9, face = "bold"),
         legend.title = element_text(size = 13, face = "bold"), 
         axis.text.x      =   element_blank(),
         axis.text.y      =   element_blank(),
         axis.ticks       =   element_blank(),
         axis.title.x     =   element_blank(),
         axis.title.y     =   element_blank(),
         panel.border     =   element_blank(),
         panel.grid.major =   element_blank(),
         panel.grid.minor =   element_blank()))


# 7. Create the barplot ---- 
# showing the percentage change in emergency oil stocks for European countries 

# i. Tidy the data for the bar plot ----

# Remove columns and rows with incomplete data
# calculate percentage change in emergency oil stocks for each European country that remains.
oil_data_barplot <- oil_data %>% 
  filter(is.finite(Jul.21)) %>%    # remove rows with insufficient data   
                                   # can also use drop_na(Jul.21)
  mutate(mean_before = rowMeans(select(., Jan.21:Apr.21)), # create column for January to April
         mean_after = rowMeans(select(., May.21:Jul.21)),  # create column for May to July
         percentage_change = ((mean_after-mean_before)/mean_before)*100) %>% 
  # create column that calculates percentage change between (Jan-Apr) and (May-Jul)
  mutate(percentage_change = replace(percentage_change, is.na(percentage_change), 0)) %>%
  filter(percentage_change^2 >= 1) %>%    # only keeps value that show a % change greater than 1%
  mutate(ymean = mean(percentage_change)) # create a column of the average % change in oil stocks


# ii. Plot the barplot ----

(emergency_oil_barplot <- ggplot(oil_data_barplot,
                                 aes(x = reorder(Countries, -percentage_change),
                                     y = percentage_change)) +
    geom_bar(position = position_dodge(), # create a barplot
             stat = "identity",
             colour = "white",
             aes(fill = percentage_change)) +   # fill the bars according to % change value
    scale_fill_distiller(palette = "OrRd", direction = -1) +   # apply a colour gradient
    labs(title = "Finland is the biggest investor in emergency oil stocks", 
         subtitle = "Investment in emergency stocks after April rise in oil prices, 2021",
         x = "\nCountry", 
         y = "Percentage Change in Emergency Oil Stocks\n") + # add title, subtitle and axis labels
   theme_group2() +  # apply the theme that we created earlier 
   ylim(-3, 10) +    # rescale y-axis limits
   # add finer resolution to x-axis and puts % after numbers
   scale_y_continuous(breaks = c(-2,0,2,4,6,8,10),
                       labels = function(x) paste0(x, "%")) +  
   geom_hline(aes(yintercept = ymean),
               col = "black",
               linetype = "dashed",
               size = 1) +  # create horizontal dashed line of mean percentage change
    annotate("text",
             x = 13.3,
             y = 4.2,
             label = "Average change = 3.5 %", size = 6) + # add label to average line
   geom_hline(yintercept = 0, size = 0.4, colour = "black")) # create line at 0% to show distinction

# 8. Create function to save outputs ----

# Define new function to save the map and the barplot both in png and pdf at the same time: 

save_plot <- function(plot_name, # first put the plot object name
                      file_name = "plot",  #give it a title 
                      width = 13, # set the width, height and dots per inch (DPI)
                      height = 8, 
                      dpi = 150) {
  
  # save as png
  ggsave(
    paste0(file_name, ".png"), 
    plot_name, 
    width = width, 
    height = height, 
    dpi = dpi) 
  
  # save as pdf
  ggsave(
    paste0(file_name, ".pdf"), 
    plot_name, 
    width = width, 
    height = height, 
    dpi = dpi
  )
}

# 9.Save the individual outputs ----
# use the save plot function created to save barplot
save_plot(emergency_oil_map, 
          file_name = "Plots/Final-Output-Emergency-oil-map", 
          width = 13, 
          height = 8, 
          dpi = 150) 

# use the save plot function created to save barplot
save_plot(emergency_oil_barplot, 
          file_name = "Plots/Final-Output-Emergency-oil-barplot", 
          width = 13, 
          height = 8, 
          dpi = 150) 

# 10. Save the panel ----
# Save a plot that combines the two graphs 
save_plot(grid.arrange(emergency_oil_map, emergency_oil_barplot, ncol = 2), 
          file_name = "Plots/Final-output-panel", 
          width = 20, 
          height = 8, 
          dpi = 150)
