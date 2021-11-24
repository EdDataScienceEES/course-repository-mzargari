############################################################################
###                     Intro to the Google Earth Engine:                ###
###                                                                      ###
###                            MICHAEL ZARGARI                           ###
###                           24-November-2021                           ###
###                   CONTACT EMAIL: S2253374@ED.AC.UK                   ###
###                                                                      ###
###         https://ourcodingclub.github.io/tutorials/earth-engine/      ###
############################################################################

# Load libraries ----
library(ggplot2)
devtools::install_github('Mikata-Project/ggthemr') # to install the ggthemr package
# if you don't have it already
library(ggthemr)  # to set a custom theme but non essential!
library(forcats)  # to reorder categorical variables

# Set theme for the plot
ggthemr('dust', type = "outer", layout = "minimal")

# This theme will now be applied to all plots you make, if you wanted to
# get rid of it, use:
# ggthemr_reset()

# Read in the data ----
NP_forest_gain <- read.csv("~/Desktop/EDS (Environmental Data Science) Course/course-repository-mzargari/Tutorials_Readings_Videos/Week 10/Week_10_Data/NP_forest_gain.csv")
NP_forest_loss <- read.csv("~/Desktop/EDS (Environmental Data Science) Course/course-repository-mzargari/Tutorials_Readings_Videos/Week 10/Week_10_Data/NP_forest_loss.csv")

# Create identifier column for gain vs loss
NP_forest_gain$type <- "Gain"
NP_forest_loss$type <- "Loss"

# Bind the objects together
forest_change <- rbind(NP_forest_gain, NP_forest_loss)

(forest_barplot <- ggplot(forest_change, aes(x = NAME, y = sum/GIS_AREA, 
                                             fill = fct_rev(type))) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(x = NULL, y = "Forest change (% of park area)\n") +
    # Expanding the scale removes the emtpy space below the bars
    scale_y_continuous(expand = c(0, 0)) +
    theme(text = element_text(size = 16),  # makes font size larger
          legend.position = c(0.1, 0.85),  # changes the placement of the legend
          legend.title = element_blank(),  # gets rid of the legend title
          legend.background = element_rect(color = "black", 
                                           fill = "transparent",   # removes the white background behind the legend
                                           linetype = "blank")))

ggsave(forest_barplot, filename = "Week 10/Week_10_Outputs/forest_barplot.png",
       height = 5, width = 7)
