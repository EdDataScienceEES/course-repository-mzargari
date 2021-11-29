################################################################################
##  Data Science in Ecological and Environmental Sciences - Data Journalism   ##
##                            Challenge 2 Group 2                             ##
##                      Date completed: 1-November-2021                       ##
##                                Written by:                                 ##
##              Lucas Lillelund (s1864014@ed.ac.uk, @loulillelund)            ##
##            Tirso Ordaz García (s2139514@ed.ac.uk, @tirsoordaz)             ##
##                                 Edited by:                                 ##
##               Michael Zargari (s2253374@ed.ac.uk, @mzargari)               ##
################################################################################

#                               Purpose of Script:                                   #
#                                                                                    #
#   This script creates a map of European countries and shows how much emergency oil #
#     stock they have based off of the number of days their reserves will last them  #
#             These conclusions are based on data from the following link:           #
#                                                                                    #
#  https://ec.europa.eu/eurostat/databrowser/view/nrg_stk_oem/default/table?lang=en  #

## Libraries ----

library("tidyverse")           # For cleaning/wrangling data                    
library("dplyr")               # For cleaning/wrangling data                 
library("ggplot2")             # For plotting data                  
library("sf")                  # For plotting map data              
library("rnaturalearth")       # Please list why we are using each package                         
library("rnaturalearthdata")   # Please list why we are using each package                             
library("rgeos")               # Please list why we are using each package                 

### Installing Packages ----

# install.packages("rnaturalearth")
# install.packages("rnaturalearthdata")
# install.packages("ggplot2")
# install.packages("rgeos")
# install.packages("dplyr")
# install.packages("maps")

### Import the data ----

em_oil_stocks <- read.csv("Data/emergency-oil-stocks.csv")

### Data Exploration ----

# Explore the European emergency oil stocks data.
head(em_oil_stocks)     # show top 6 rows of data 
summary(em_oil_stocks)  # gives a summary of oil_data
str(em_oil_stocks)      # tells you the nature of the variables 
                        # (continuous, integers, categorical or characters)

# We find many NA values in the Aug.21 column, should look at the whole column
em_oil_stocks[, "Aug.21"]

## Data Cleaning ----

# We want to map emergency oil stocks data in Europe
# We decide to exclude Aug.21 from map data due to too many NA values
# Then, we create a mean column of our oil stock data from Jan. to July 2021

em_oil_stocks_clean <- em_oil_stocks %>%
  select(-Aug.21) %>% # Delete Aug.21
  rowwise() %>%       # Get mean over rows
  # New mean column
  mutate(Avg_em_stocks = mean(c(Jan.21, Feb.21, Mar.21, Apr.21, May.21, Jun.21, Jul.21)))

head(em_oil_stocks_clean) # View cleaned dataset

## Mapping ----

theme_set(theme_bw()) # setting default map background colors to black & white

world_map <- map_data("world") %>% # creating dataframe for coordinates of all countries
  rename("Countries" = "region")   # renaming "region" column to "Countries"

# creating new joined data by joining em_oil_stocks_clean data with world_map data
EU_OilStks_Map <- left_join(world_map, em_oil_stocks_clean, by = "Countries")

EU_OilStks_Map1 <- EU_OilStks_Map %>% 
  filter(!is.na(EU_OilStks_Map$Avg_em_stocks)) %>% 
  subset(select = -c(Jan.21:Jul.21))
# getting rid of rows w/ NA values in mean column & leaving only mean column

# creating basic map for avg European emergency oil stocks data 
(EUOilMap <- ggplot(EU_OilStks_Map1, aes( x = long, y = lat, group = group)) +
    geom_polygon(aes(fill = Avg_em_stocks), color = "black") +
    labs(title = "Map of emergency oil stocks across Europe (in days)") +
    theme(plot.title = element_text(size = 25 , face = "bold.italic", hjust = 0.5),
          legend.position = c(0.88, 0.5)))

# beautifying map for avg European emergency oil stocks data
(EUOilMapFinal <- EUOilMap + 
    scale_fill_distiller(palette = "OrRd", direction = -1, 
                         name = "Remaining Emergency\nOil Stocks (in days)") + 
    theme(axis.text.x   =   element_blank(),
       axis.text.y      =   element_blank(),
       axis.ticks       =   element_blank(),
       axis.title.x     =   element_blank(),
       axis.title.y     =   element_blank(),
       panel.border     =   element_blank(),
       panel.grid.major =   element_blank(),
       panel.grid.minor =   element_blank()))

## Save the map figure into a panel with the barplot ----

ggsave(EUOilMapFinal, file = "Plots/EU-Emergency-Oil-Map.png", width = 12, height = 10)
ggsave(EUOilMapFinal, file = "Plots/EU-Emergency-Oil-Map.pdf", width = 12, height = 10)


