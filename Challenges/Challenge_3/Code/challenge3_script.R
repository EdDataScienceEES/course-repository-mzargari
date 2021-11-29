#################################################################
##    Data Science in Ecological and Environmental Sciences    ##
##             Challenge 3 - Statistical Modelling             ##
##              Date completed: 23-November-2021               ##
##                         Written by:                         ##
##        Michael Zargari (s2253374@ed.ac.uk, @mzargari)       ##
#################################################################

##                                       Purpose of Script:                                   ##
##                                                                                            ## 
##  This script models the changes of salmon egg, smolt, and adult populations over 40 years. ##
##      We are hoping to answer the main question to identify trends in salmon populations    ##
##       of eggs, smolts, and adults between 1970 and 2010 using a mixed effects model.       ##                       
##                                                                                            ##
##    These conclusions are based on data from the sources in the following link:             ## 
## https://docs.google.com/spreadsheets/d/1rkvBn87uJAhr_5cAlhm2fEgUYZiVENVBUYb3GeLhrQE/edit?usp=sharing


###################################################
##              Table of Contents:               ##
##                                               ##
##                   Libraries                   ##
##              Installing Packages              ##
##            Load Living Planet Data            ##
##  Filtering Atlantic Salmon Species from Data  ##
##              Creating CSV files               ##
##           Hierarchical Linear Model           ##
##              Checking Residuals               ##
##                  Predictions                  ##
##            Trends and Conclusions             ##
###################################################

### Libraries ----

library(tidyverse)           # Data wrangling
library(lme4)                # To create the mixed effects models
library(ggthemes)            # Extra themes, geoms and scales for ggplot2
library(gridExtra)           # Plot arrangement
library(ggeffects)           # Prediction functions
library(sjPlot)              # Visualizing random effects


### Installing Packages----

# install.packages("tidyverse")
# install.packages("lme4")     
# install.packages("ggthemes" ) 
# install.packages("gridExtra")
# install.packages("ggeffects")
# install.packages("sjPlot")   


### Load Living Planet Data ----

load("data/LPI_species.Rdata")


### Filtering Atlantic Salmon Species from Data----

atlsal <- filter(LPI_species, Species == "Salmo salar") # only get Atlantic salmon species
unique(atlsal$Common.Name) # double checking that I have only Atlantic salmon in my data 


### Creating CSV files ----

# Making a file containing all the sources of our data
write.csv(data_frame(unique(atlsal$Data.source.citation)), file = "data/atlsal_sources.csv")

# Making a file to visualize the Atlantic salmon data only
write.csv(atlsal, file = "data/atlsal.csv")

# We find that all Atlantic Salmon are in a freshwater system, are native ("yes"), are not 
# aliens ("no"), are not invasive ("no"), and understandably all have the same class, order, and 
# family so we can take out these columns as they are redundant
# We also remove the 'X' before the year as well

# Removing the Xs before the years
atlsal2 <- atlsal %>%
  mutate(year = parse_number(as.character(year))) %>% 
  dplyr::select(-c(Class, Order, Family, system, Native, Alien, Invasive)) 

# Making a file to visualize just the Atlantic salmon data we are interested in
write.csv(atlsal2, file = "data/atlsal2.csv")

# Defining variables that we will be using for this analysis for easier access
year <- atlsal2$year
scalepop <- atlsal2$scalepop
id <- atlsal2$id
country <- atlsal2$Country.list

# We plot our scaled data onto a histogram to idenitfy any patterns
hist(scalepop, col = terrain.colors(4))


### Hierarchical Linear Model ----

# Basic model finding changes in population overtime
model <- lm(scalepop ~ year) # Fixed factor is "year"

# Adding in new effects to better explain the model
# Finding changes in populations overtime taking country (location), year, and study (id) 
# into account as random effects as well since species counts are temporally autocorrelated
modelRE <- lmer(scalepop ~ year + (1|country) + (1|year) + (1|id))

# Checking which model is the best fit for the data
AIC(model)    
AIC(modelRE)

# Positive number >2 means that the mixed effects model is a better fit 
# The smaller Akaike Information Criterion (AIC) number the better
AIC(model) - AIC(modelRE)

# We find that modelRE is the best one to use as it has the smallest AIC and successfully converges
summary(modelRE)


### Checking Residuals ----

# Residuals are well behaved. They are equally spread around 0 on the x axis so we can assume that 
# the relationship is linear
plot(modelRE, col = "dark orange") 

qqnorm(residuals(modelRE), col = "dark red")  # is normally distributed since plot is mostly linear
qqline(residuals(modelRE), col = "black")     # plots lines through points

### Predictions ----

# Getting the overall predictions for the model
model_predictions <- ggpredict(modelRE, terms = c("year", "country"), type = "re") 
model_predictions

### Trends and Conclusions ----

# Find that no single part of the world has any major increase or decrease in population, however,
# there is a decline in population growths in the 1990s throughout the world
(ggplot(model_predictions) + 
   # plots year on x axis and scalepop on y axis with each data point colored by country
   geom_point(data = atlsal2,
              aes(x = year, y = scalepop, colour = country)) +
   labs(x = "Year", y = "Scaled Population", 
        title = "Atlantic Salmon Populations by Country") + 
   theme_minimal()
)

save_plot(filename = "Graphs/atlsal_populations_by_country.png",
          height = 16, width = 16)

#  Graphs indicate rising Atlantic salmon populations across both biomes and all countries, 
#  notably Finland, Norway, and Canada.
#  plots year on x axis and scalepop on y axis for all biomes with each data point colored by its country

(ggplot(atlsal2, aes(x = year, y = scalepop, colour = country)) + 
    facet_wrap(~ biome, ncol = 2) +  # plots biomes in a grid with 2 graphs per row
    geom_point(alpha = 0.3) +               # size of dots
    theme_classic() +
    # adds a predicted line from our mixed model 
    geom_line(data = cbind(atlsal2, pred = predict(modelRE)), aes(y = pred), size = 1) +   
    theme(legend.position = "bottom",
         panel.spacing = unit(1, "lines"),  # adding space between panels
         axis.text.x = element_text(angle = 45, hjust = 1)))

save_plot(filename = "Graphs/atlsal_populations_trends_by_country.png",
          height = 14, width = 16)

# Graphs show a steady increase in Atlantic Salmon populations in both North America and Europe 
# with similar population trends across both biomes
# plots year on x axis and scalepop on y axis for all biomes with each data point colored by its biome

(ggplot(atlsal2, aes(x = year, y = scalepop, colour = biome)) + 
    facet_wrap(~ Region, ncol = 2) +        # plots both regions in a grid with 2 graphs per row
    geom_point(alpha = 0.3) +               # size of dots
    theme_classic() +
    # adds a predicted line from our mixed model 
    geom_line(data = cbind(atlsal2, pred = predict(modelRE)), aes(y = pred), size = 1) +   
    theme(legend.position = "bottom",
          panel.spacing = unit(1, "lines"), # adding space between panels
          axis.text.x = element_text(angle = 45, hjust = 1)))

save_plot(filename = "Graphs/atlsal_populations_trends_by_continent.png",
          height = 12, width = 16)

