###########################################################################
###                                                                     ###
###                            CHALLENGE 1:                             ###
###                           MICHAEL ZARGARI                           ###
###                                                                     ###
###########################################################################

## Introduction----------------------------------------------------------------
##  
##  Instructions:
##    "Please rewrite this code to make it as efficient as possible using pipes 
##    (dplyr)"  
##    
##  Function of code:
##    This code below pulls data from a comma separated file data set   
##    called 'LPI_birds' and makes edits to the data set. We later get the     
##    data set and plot it on a chart and map to show the final area where the   
##    birds in the United Kingdom are located.    
##                  
##  Contact:
##    If you have any questions, comments, or concerns, please reach out to me
##    on Github @mzargari or feel free to email me at s2253374@ed.ac.uk            

# Libraries ----
library(dplyr)
library(tidyverse)
library(ggthemes)
library(gridExtra)
library(ggplot2)

# Ensuring my working directory is in the place I want it to be----
setwd ("/Users/mikey/Desktop/EDS (Environmental Data Science) Course/challenge1-mzargari")

# Load Living Planet Data and Explore it----
LPI_data <- read.csv("Data/LPI_birds.csv")

# Explore data ----
head(LPI_data)
summary(LPI_data)
summary(LPI_data$Class)
str(LPI_data)

# Reshape data into long form ----
LPI_long <- pivot_longer(data = LPI_data, 
                         cols = 25:69, 
                         names_to = "year", 
                         values_to = "pop")

# Add new columns to LPI_long and modify existing ones ----
# Starts by indicating which source data from (LPI_long) we are editing
LPI_long <- LPI_long %>% 
  # Extracts numeric values from year column and 
  # makes concatenation of genus and species and population id
  mutate(year = parse_number(LPI_long$year), 
         genus_species_id = paste(LPI_long$Genus, 
                                  LPI_long$Species, 
                                  LPI_long$id, sep="_")) %>% 
  # Filters to see if values under column "pop" are null. If they are, they will
  # be labelled as "TRUE" but this code negates that to make them say "FALSE"
  # The opposite is true for values that are not null that originally come up as "FALSE"
  filter(!is.na(pop)) %>% 
  # Groups the data by genus_species_id
  group_by(genus_species_id) %>% 
  # Creates a column for duration of monitoring for each population and another
  # column called "scalepop" which subtracts the population by the
  # minimum population and divides that by the difference between the maximum
  # and minimum populations
  mutate(lengthyear = max(year) - min(year), 
         scalepop = (pop - min(pop)) / (max(pop) - min(pop))) %>%      
  # Only keep rows with numeric values with more than 5 years of data
  filter(is.finite(scalepop) & lengthyear > 5) %>%
  ungroup() %>% # Remove any groupings
  select(-Data.source.citation, -Authority)   # Remove unnecessary columns

# Filter out Curlew populations ----
# Start by loading in the LPI_long data and filter data to find the criteria:
Curlew <- LPI_long %>% 
  filter(Class == "Aves",                     # Finds all Aves           
         Common.Name == "Eurasian curlew",    # that have Common.Name as "Eurasian curlew"          
         Order == "Charadriiformes",          # and order "Charadriiformes"   
         Family == "Scolopacidae",            # and family "Scolopacidae"
         Genus == "Numenius",                 # and genus "Numenius"
         Species == "arquata") %>%            # and species == "arquata"  
  group_by(Country.list) %>%                  # Groups by Country.list
  ungroup()                                   # Remove any groupings
 
unique(Curlew$Country.list)                   # Finds only distinct countries 

# Pick the countries of interest ----
CurlewPops <- rbind(Curlew %>% filter(Country.list == "United Kingdom"))

# Data for plotting----
plotCurlewData <- CurlewPops %>% # Start by Loading in the data
  select(Country.list,                        # Picks only the listed columns 
         year,
         scalepop,
         id,
         lengthyear) %>% 
  group_by(id) %>%                            # Groups by id
  # Get only the populations with more than 15 years of data from those locations
  filter(lengthyear > 15)

# Plot Curlew populations over time ----
(f1 <- ggplot(plotCurlewData,                 # Loads in the data to be plotted   
              aes(x = year,                   # x-axis will be labelled "year"
                  y = scalepop,               # y-axis will be labelled "scalepop"
                  group = id,                    
                  colour = Country.list)) +
   geom_line() +                              # Plots a blue line
   geom_point() +                             # Plots orange data points
   # Puts the legend at the bottom and Sets the size of the title
   theme(legend.position = "bottom", 
         plot.title = element_text(size = 15, hjust = 0.5))+        
   # Sets the title of the graph
   labs(title = "Curlew population trends\nfrom 1970 to 2004"))

# Load Site Coordinate Data ----
site_coords <- read.csv("Data/site_coords.csv")
head(site_coords)

# Merge Curlew data with site coordinates ----
Curlew_sites <- left_join(plotCurlewData, site_coords, by = "id")

# Make map of where the Curlew populations are located ----
(f2 <- ggplot(Curlew_sites,                   # Loads in the data to be plotted   
              aes(x = Decimal.Longitude,                
                  y = Decimal.Latitude,               
                  color = Country.list)) +
   # Sets borders and colors 
   borders("world", colour = "gray40", fill = "gray75", size = 0.3) +  
   # Sets the coordinates of where the point will be plotted
   coord_cartesian(xlim = c(-10, 35), ylim = c(30, 70)) + 
   # Makes the graph into a map and removes grid lines behind it
   theme_map() +
   # Sets the color and size of the dot
   geom_point(size = 4, color = "orange") +
   # Ensures there is no legend and sets the font size for the title
   theme(legend.position = "none", 
         plot.title = element_text(size = 15, hjust = 0.5)) +
   # Sets the title name
   labs(title = "Map of Curlew Populations\nin the United Kingdom"))

# Make and view a panel of the two graphs ----
grid.arrange(f1, f2, ncol = 2)

# Save the panel of the two graphs ----
ggsave("Plots/My_Final_Plot.pdf",                    # Saves plot as PDF
       grid.arrange(f1, f2, ncol = 2),               # The graph to save
       height = 12,                                  # Sets the height in cm    
       width = 16,                                   # Sets the width in cm    
       units = "cm")                                 # Sets the units as cm     
