###################################################################
##     Data Science in Ecological and Environmental Sciences     ##
##  Challenge 4 - Forest Coverage in the Pilliga Nature Reserve  ##
##                Date completed: 25-November-2021               ##
##                    Written and Edited by:                     ##
##                  Giada Leone (@giadaleone99)                  ##
##                      David Du (@xdu071)                       ##
##                  Michael Zargari (@mzargari)                  ##
##                Sarka Ondrouchova (@sharkie58)                 ##
##                   Lubin Grosbuis (@lubin-g)                   ##
###################################################################


##                                       Purpose of Script:                                   ##
##                                                                                            ## 
## This script models the forest changes in the Pilliga Nature Reserve between 2001 and 2016. ##
## This code also creates barplots and visualizations to better explain the changes overtime. ##
##                                                                                            ##
##  These conclusions are based on data from the fata provided: forest_change_Pink_Lake.csv   ## 
##                                                                                            ## 
## Live assignment feedback may be found here:                                                ##
## https://docs.google.com/document/d/1Y6QSo42c1shOLwfbXU1cJZe3rPJAkE8KVme_x_BOHM8/edit       ##


###################################################
##              Table of Contents                ##
##                                               ##
##                   Libraries                   ##
##              Installing Packages              ##
##                  Load Data                    ##
##            Making visualizations              ##
###################################################

## Libraries ----
library(tidyverse)   # Data wrangling
library(ggthemr)     # to set a custom theme 
library(forcats)     # to reorder categorical variables

## Install Packages ----
# install.packages("tidyverse")
# install.packages("ggthemr")  
# install.packages("forcats")

## Load data ----
pinkLake_raw <- read.csv("data/forest_change_Pink_Lake.csv", header = TRUE)

## Clean data ----

# Turn gain data to long format
pinkLake_gain <- gather(pinkLake_raw, "year", "change", 30:45)
pinkLake_gain$year <- parse_number(pinkLake_gain$year)
pinkLake_gain <- pinkLake_gain %>%
  select(c(47,48))

# Turn loss data to long format
pinkLake_raw_2 <- pinkLake_raw %>%
  select(-c(30:45))
pinkLake_loss <- gather(pinkLake_raw_2, "year", "change", 30:38)
pinkLake_loss$year <- parse_number(pinkLake_loss$year)
pinkLake_loss <- pinkLake_loss %>%
  select(c(38,39))

# Create identifier column for gain vs loss (create new column, similar to mutate)
pinkLake_gain$type <- "Gain"
pinkLake_loss$type <- "Loss"

# Bind the gain and loss data set
pinkLake <- rbind(pinkLake_gain, pinkLake_loss)
pinkLake$year <- as.factor(pinkLake$year)

pinkLake <- pinkLake %>%
        mutate(log_change = log(change),
               stan_change = scale(change),
               r_change = (change - min(change) / min(change) - max(change)))


ggplot(data = pinkLake, aes(x = year, y = log_change, fill = fct_rev(type))) +
        geom_bar(stat = "identity", position = "dodge") +
        scale_y_continuous(expand = c(0, 0)) +
        theme_classic() +
        ylab("log (change in forest coverage) ") +
        xlab("Year") +
        theme(text = element_text(size = 16),# makes font size larger
              legend.position = "right",  # changes the placement of the legend
              legend.title = element_blank(),  # gets rid of the legend title
              legend.background = element_rect(color = "black", 
                                               fill = "transparent",  
                                               linetype = "blank"))


ggplot(data = pinkLake, aes(x = year, y = change, fill = fct_rev(type))) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(expand = c(0, 0)) +
  theme_classic() +
  ylab("log (change in forest coverage) ") +
  xlab("Year") +
  theme(text = element_text(size = 16),# makes font size larger
        legend.position = "right",  # changes the placement of the legend
        legend.title = element_blank(),  # gets rid of the legend title
        legend.background = element_rect(color = "black", 
                                         fill = "transparent",  
                                         linetype = "blank"))

pinkLake1 <- pinkLake %>%
  filter(year %in% c(2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009))

pinkLake2 <- pinkLake %>%
  filter(year %in% c(2010, 2011, 2012, 2013, 2014, 2015, 2016))

# Visualization of forest fires                    
ggplot(data = pinkLake1, aes(x = year, y = change, fill = fct_rev(type))) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(expand = c(0, 0)) +
  theme_classic() +
  ylab("Change in forest coverage (km^2)") +
  xlab("Year") +
  theme(text = element_text(size = 16),# makes font size larger
        legend.position = "right",  # changes the placement of the legend
        legend.title = element_blank(),  # gets rid of the legend title
        legend.background = element_rect(color = "black", 
                                         fill = "transparent",  
                                         linetype = "blank"))

ggsave("outputs/forest_fire.png")

# Visualizations post forest fires
ggplot(data = pinkLake2, aes(x = year, y = change, fill = fct_rev(type))) +
  geom_bar(stat = "identity", position = "dodge", fill = "skyblue") +
  scale_y_continuous(expand = c(0, 0)) +
  theme_classic() +
  ylab("Change in forest coverage (km^2)") +
  xlab("Year") +
  theme(text = element_text(size = 16),# makes font size larger
        legend.position = "right",  # changes the placement of the legend
        legend.title = element_blank(),  # gets rid of the legend title
        legend.background = element_rect(color = "black", 
                                         fill = "transparent",  
                                         linetype = "blank"))


ggsave("outputs/posst_fire.png")









