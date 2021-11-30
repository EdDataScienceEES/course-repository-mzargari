#####################################################################################
###                     Efficient and beautiful data synthesis:                   ###
###                   Taking your tidyverse skills to the next level              ###
###                                                                               ###
###                                MICHAEL ZARGARI                                ###
###                               28-November-2021                                ###
###                       CONTACT EMAIL: S2253374@ED.AC.UK                        ###
###                                                                               ###
###   https://ourcodingclub.github.io/tutorials/dataviz-beautification-synthesis/ ###
#####################################################################################

# Continuation of Week 4's "Efficient and beautiful data visualisation - Really finessing your graphs.R"

### 1. Make and beautify maps ----

setwd("~/Desktop/EDS (Environmental Data Science) Course/course-repository-mzargari/Tutorials_Readings_Videos/Week_08/Week_8_Outputs")

# Libraries ----
# if you haven't installed them before, run the code install.packages("package_name")
library(tidyverse)
library(ggthemes)  # for a mapping theme

# if you have a more recent version of ggplot2, it seems to clash with the ggalt package
# installing this version of the ggalt package from GitHub solves it
# You might need to also restart your RStudio session
devtools::install_github("eliocamp/ggalt@new-coord-proj") # for custom map projections
library(ggalt)
library(ggrepel)  # for annotations
library(viridis)  # for nice colours
library(broom)  # for cleaning up models
# devtools::install_github("wilkox/treemapify")
library(treemapify)  # for making area graphs
library(wesanderson)  # for nice colours

# Data ----
# Load data - site coordinates and plant records from
# the Long Term Ecological Research Network
# https://lternet.edu and the Niwot Ridge site more specifically
lter <- read.csv("~/Desktop/EDS (Environmental Data Science) Course/course-repository-mzargari/Tutorials_Readings_Videos/Week_08/Week_8_Data/lter.csv")
niwot_plant_exp <- read.csv("~/Desktop/EDS (Environmental Data Science) Course/course-repository-mzargari/Tutorials_Readings_Videos/Week_08/Week_8_Data//niwot_plant_exp.csv")


# MAPS ----
# Get the shape of North America
north_america <- map_data("world", region = c("USA", "Canada"))

# Exclude Hawaii if you want to
north_america <- north_america[!(north_america$subregion %in% "Hawaii"),]

# A very basic map
(lter_map1 <- ggplot() +
    geom_map(map = north_america, data = north_america,
             aes(long, lat, map_id = region),
             color = "gray80", fill = "gray80", size = 0.3) +
    # Add points for the site locations
    geom_point(data = lter,
               aes(x = long, y = lat)))

# You can ignore this warning message, it's cause we have forced
# specific lat and long columns onto geom_map()
# Warning: Ignoring unknown aesthetics: x, y

# if you wanted to save this (not amazing) map
# you can use ggsave()
ggsave(lter_map1, filename = "map1.png",
       height = 5, width = 8)  # the units by default are in inches

(lter_map2 <- ggplot() +
    geom_map(map = north_america, data = north_america,
             aes(long, lat, map_id = region),
             color = "gray80", fill = "gray80", size = 0.3) +
    geom_point(data = lter,
               aes(x = long, y = lat, fill = ele),
               # when you set the fill or colour to vary depending on a variable
               # you put that (e.g., fill = ele) inside the aes() call
               # when you want to set a specific colour (e.g., colour = "grey30"),
               # that goes outside of the aes() call
               alpha = 0.8, size = 4, colour = "grey30",
               shape = 21))

ggsave(lter_map2, filename = "map2.png",
       height = 5, width = 8)

(lter_map3 <- ggplot() +
    geom_map(map = north_america, data = north_america,
             aes(long, lat, map_id = region),
             color = "gray80", fill = "gray80", size = 0.3) +
    # you can change the projection here
    # coord_proj("+proj=wintri") +
    # the wintri one above is good for the whole world, the one below for just North America
    coord_proj(paste0("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96",
                      " +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")) +
    geom_point(data = lter,
               aes(x = long, y = lat, fill = ele),
               alpha = 0.8, size = 4, colour = "grey30",
               shape = 21))

# You don't need to worry about the warning messages
# that's just cause we've overwritten the default projection

ggsave(lter_map3, filename = "map3.png",
       height = 5, width = 8)

(lter_map4 <- ggplot() +
    geom_map(map = north_america, data = north_america,
             aes(long, lat, map_id = region),
             color = "gray80", fill = "gray80", size = 0.3) +
    coord_proj(paste0("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96",
                      " +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"),
               # zooming in by setting specific coordinates
               ylim = c(25, 80), xlim = c(-175, -50)) +
    geom_point(data = lter,
               aes(x = long, y = lat, fill = ele),
               alpha = 0.8, size = 4, colour = "grey30",
               shape = 21))

ggsave(lter_map4, filename = "map4.png",
       height = 5, width = 8)

(lter_map5 <- ggplot() +
    geom_map(map = north_america, data = north_america,
             aes(long, lat, map_id = region),
             color = "gray80", fill = "gray80", size = 0.3) +
    coord_proj(paste0("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96",
                      " +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"),
               ylim = c(25, 80), xlim = c(-175, -50)) +
    geom_point(data = lter,
               aes(x = long, y = lat, fill = ele),
               alpha = 0.8, size = 4, colour = "grey30",
               shape = 21) +
    # Adding a clean map theme
    theme_map() +
    # Putting the legend at the bottom
    theme(legend.position = "bottom"))

ggsave(lter_map5, filename = "map5.png",
       height = 5, width = 8)

(lter_map6 <- ggplot() +
    geom_map(map = north_america, data = north_america,
             aes(long, lat, map_id = region),
             color = "gray80", fill = "gray80", size = 0.3) +
    coord_proj(paste0("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96",
                      " +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"),
               ylim = c(25, 80), xlim = c(-175, -50)) +
    geom_point(data = lter,
               aes(x = long, y = lat, fill = ele),
               alpha = 0.8, size = 4, colour = "grey30",
               shape = 21) +
    theme_map() +
    theme(legend.position = "bottom") +
    # Adding point annotations with the site name
    geom_label_repel(data = lter,
                     aes(x = long, y = lat,
                         label = site),
                     # Setting the positions of the labels
                     box.padding = 1, size = 4, nudge_x = 1, nudge_y = 1))

ggsave(lter_map6, filename = "map6.png",
       height = 5, width = 8)

(lter_map7 <- ggplot() +
    geom_map(map = north_america, data = north_america,
             aes(long, lat, map_id = region),
             color = "gray80", fill = "gray80", size = 0.3) +
    coord_proj(paste0("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96",
                      " +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"),
               ylim = c(25, 80), xlim = c(-175, -50)) +
    geom_point(data = lter,
               aes(x = long, y = lat, fill = ele),
               alpha = 0.8, size = 4, colour = "grey30",
               shape = 21) +
    theme_map() +
    theme(legend.position = "bottom") +
    geom_label_repel(data = subset(lter, ele > 2000),
                     aes(x = long, y = lat,
                         label = site),
                     box.padding = 1, size = 4, nudge_x = 1, nudge_y = 12))

ggsave(lter_map7, filename = "map7.png",
       height = 5, width = 8)

(lter_map8 <- ggplot() +
    geom_map(map = north_america, data = north_america,
             aes(long, lat, map_id = region),
             color = "gray80", fill = "gray80", size = 0.3) +
    coord_proj(paste0("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96",
                      " +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"),
               ylim = c(25, 80), xlim = c(-175, -50)) +
    geom_point(data = lter,
               aes(x = long, y = lat, fill = ele),
               alpha = 0.8, size = 4, colour = "grey30",
               shape = 21) +
    theme_map() +
    theme(legend.position = "bottom") +
    geom_label_repel(data = subset(lter, ele > 2000),
                     aes(x = long, y = lat,
                         label = site),
                     box.padding = 1, size = 4, nudge_x = 1, nudge_y = 12) +
    labs(fill = "Elevation (m)") +
    annotate("text", x = -150, y = 35, colour = "#553c7f",
             label = "At 3528 m above sea level,\nNiwot Ridge is\nthe highest LTER site.",
             size = 4.5, fontface = "bold") +
    scale_fill_viridis(option = "magma", direction = -1, begin = 0.2))

ggsave(lter_map8, filename = "map8.png",
       height = 5, width = 8)

### 2. Visualise distributions (and make them rain data with raincloud plots) ----
# DISTRIBUTIONS 
# Setting a custom ggplot2 function
# This function makes a pretty ggplot theme
# This function takes no arguments
# meaning that you always have just niwot_theme() and not niwot_theme(something else here)

theme_niwot <- function(){
  theme_bw() +
    theme(text = element_text(family = "Helvetica Light"),
          axis.text = element_text(size = 16),
          axis.title = element_text(size = 18),
          axis.line.x = element_line(color="black"),
          axis.line.y = element_line(color="black"),
          panel.border = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.y = element_blank(),
          plot.margin = unit(c(1, 1, 1, 1), units = , "cm"),
          plot.title = element_text(size = 18, vjust = 1, hjust = 0),
          legend.text = element_text(size = 12),
          legend.title = element_blank(),
          legend.position = c(0.95, 0.15),
          legend.key = element_blank(),
          legend.background = element_rect(color = "black",
                                           fill = "transparent",
                                           size = 2, linetype = "blank"))
}

# Calculate species richness per plot per year
niwot_richness <- niwot_plant_exp %>% group_by(plot_num, year) %>%
  mutate(richness = length(unique(USDA_Scientific_Name))) %>% ungroup()


(distributions1 <- ggplot(niwot_richness, aes(x = fert, y = richness)) +
    geom_violin())

ggsave(distributions1, filename = "distributions1.png",
       height = 5, width = 5)


(distributions2 <- ggplot(niwot_richness, aes(x = fert, y = richness)) +
    geom_violin(aes(fill = fert, colour = fert), alpha = 0.5) +
    # alpha controls the opacity
    theme_niwot())

ggsave(distributions2, filename = "distributions2.png",
       height = 5, width = 5)

(distributions3 <- ggplot(niwot_richness, aes(x = fert, y = richness)) +
    geom_violin(aes(fill = fert, colour = fert), alpha = 0.5) +
    geom_boxplot(aes(colour = fert), width = 0.2) +
    theme_niwot())

ggsave(distributions3, filename = "distributions3.png",
       height = 5, width = 5)

(distributions4 <- ggplot(niwot_richness, aes(x = fert, y = richness)) +
    geom_violin(aes(fill = fert, colour = fert), alpha = 0.5) +
    geom_jitter(aes(colour = fert), position = position_jitter(0.1),
                alpha = 0.3) +
    theme_niwot())

ggsave(distributions4, filename = "distributions4.png",
       height = 5, width = 5)


# We will use a function by Ben Marwick
# This code loads the function in the working environment
source("https://gist.githubusercontent.com/benmarwick/2a1bb0133ff568cbe28d/raw/fb53bd97121f7f9ce947837ef1a4c65a73bffb3f/geom_flat_violin.R")

# Now we can make the plot!
(distributions5 <-
    ggplot(data = niwot_richness,
           aes(x = reorder(fert, desc(richness)), y = richness, fill = fert)) +
    # The half violins
    geom_flat_violin(position = position_nudge(x = 0.2, y = 0), alpha = 0.8) +
    # The points
    geom_point(aes(y = richness, color = fert),
               position = position_jitter(width = 0.15), size = 1, alpha = 0.1) +
    # The boxplots
    geom_boxplot(width = 0.2, outlier.shape = NA, alpha = 0.8) +
    # \n adds a new line which creates some space between the axis and axis title
    labs(y = "Species richness\n", x = NULL) +
    # Removing legends
    guides(fill = FALSE, color = FALSE) +
    # Setting the limits of the y axis
    scale_y_continuous(limits = c(0, 30)) +
    # Picking nicer colours
    scale_fill_manual(values = c("#5A4A6F", "#E47250",  "#EBB261", "#9D5A6C")) +
    scale_colour_manual(values = c("#5A4A6F", "#E47250",  "#EBB261", "#9D5A6C")) +
    theme_niwot())

ggsave(distributions5, filename = "distributions5.png",
       height = 5, width = 5)

(distributions6 <-
    ggplot(data = niwot_richness,
           aes(x = reorder(fert, desc(richness)), y = richness, fill = fert)) +
    geom_flat_violin(position = position_nudge(x = 0.2, y = 0), alpha = 0.8) +
    geom_point(aes(y = richness, color = fert),
               position = position_jitter(width = 0.15), size = 1, alpha = 0.1) +
    geom_boxplot(width = 0.2, outlier.shape = NA, alpha = 0.8) +
    labs(y = "\nSpecies richness", x = NULL) +
    guides(fill = FALSE, color = FALSE) +
    scale_y_continuous(limits = c(0, 30)) +
    scale_fill_manual(values = c("#5A4A6F", "#E47250",  "#EBB261", "#9D5A6C")) +
    scale_colour_manual(values = c("#5A4A6F", "#E47250",  "#EBB261", "#9D5A6C")) +
    coord_flip() +
    theme_niwot())

ggsave(distributions6, filename = "distributions6.png",
       height = 5, width = 5)

# Create new columns based on a combo of conditions using case_when()
# A fictional example
alpine_magic <- niwot_richness %>% mutate(fairy_dust = case_when(fert == "PP" & hits > 5 ~ "Blue fairy dust",
                                                                 fert == "CC" & hits > 15 ~ "The ultimate fairy dust"))

(distributions_magic <-
    ggplot(data = alpine_magic,
           aes(x = reorder(fairy_dust, desc(richness)), y = richness, fill = fairy_dust)) +
    geom_flat_violin(position = position_nudge(x = 0.2, y = 0), alpha = 0.8) +
    geom_point(aes(y = richness, color = fairy_dust),
               position = position_jitter(width = 0.15), size = 1, alpha = 0.1) +
    geom_boxplot(width = 0.2, outlier.shape = NA, alpha = 0.8) +
    labs(y = "\nSpecies richness", x = NULL) +
    guides(fill = FALSE, color = FALSE) +
    scale_y_continuous(limits = c(0, 30)) +
    scale_fill_manual(values = c("turquoise4", "magenta4")) +
    scale_colour_manual(values = c("turquoise4", "magenta4")) +
    coord_flip() +
    theme_niwot())

alpine_magic_only <- alpine_magic %>% drop_na(fairy_dust)

(distributions_magic2 <-
    ggplot(data = alpine_magic_only,
           aes(x = reorder(fairy_dust, desc(richness)), y = richness, fill = fairy_dust)) +
    geom_flat_violin(position = position_nudge(x = 0.2, y = 0), alpha = 0.8) +
    geom_point(aes(y = richness, color = fairy_dust),
               position = position_jitter(width = 0.15), size = 1, alpha = 0.1) +
    geom_boxplot(width = 0.2, outlier.shape = NA, alpha = 0.8) +
    labs(y = "\nSpecies richness", x = NULL) +
    guides(fill = FALSE, color = FALSE) +
    scale_y_continuous(limits = c(0, 30)) +
    scale_fill_manual(values = c("turquoise4", "magenta4")) +
    scale_colour_manual(values = c("turquoise4", "magenta4")) +
    coord_flip() +
    theme_niwot())

ggsave(distributions_magic2, filename = "distributions_magic2.png",
       height = 5, width = 5)


### 3. Make, customise and annotate histograms ----

# Calculate number of data records per plot per year
# Using the tally() function


observations <- niwot_plant_exp %>% group_by(USDA_Scientific_Name) %>%
  tally() %>% arrange(desc(n))  # rearanging the data frame so that the most common species are first

# Filtering out just Carex species
carex <- niwot_plant_exp %>%
  filter(str_detect(USDA_Scientific_Name, pattern = "Carex"))

(histogram1 <- ggplot(carex, aes(x = hits)) +
    geom_histogram())

ggsave(histogram1, filename = "histogram1.png",
       height = 5, width = 5)

(histogram2 <- ggplot(carex, aes(x = hits)) +
    geom_histogram(alpha = 0.6,
                   breaks = seq(0, 100, by = 3),
                   # Choosing a Carex-like colour
                   fill = "palegreen4") +
    theme_niwot())

ggsave(histogram2, filename = "histogram2.png",
       height = 5, width = 5)

(histogram3 <- ggplot(carex, aes(x = hits)) +
    geom_histogram(alpha = 0.6,
                   breaks = seq(0, 100, by = 3),
                   fill = "palegreen4") +
    theme_niwot() +
    scale_y_continuous(limits = c(0, 100), expand = expand_scale(mult = c(0, 0.1))))
# the final line of code removes the empty blank space below the bars)

ggsave(histogram3, filename = "histogram3.png",
       height = 5, width = 5)

# Adding an outline around the whole histogram
h <- hist(carex$hits, breaks = seq(0, 100, by = 3), plot = FALSE)
d1 <- data.frame(x = h$breaks, y = c(h$counts, NA))
d1 <- rbind(c(0, 0), d1)

(histogram4 <- ggplot(carex, aes(x = hits)) +
    geom_histogram(alpha = 0.6,
                   breaks = seq(0, 100, by = 3),
                   fill = "palegreen4") +
    theme_niwot() +
    scale_y_continuous(limits = c(0, 100), expand = expand_scale(mult = c(0, 0.1))) +
    # Adding the outline
    geom_step(data = d1, aes(x = x, y = y),
              stat = "identity", colour = "palegreen4"))

summary(d1) # it's fine, you can ignore the warning message
# it's because some values don't have bars
# thus there are missing "steps" along the geom_step path

ggsave(histogram4, filename = "histogram4.png",
       height = 5, width = 5)

(histogram5 <- ggplot(carex, aes(x = hits)) +
    geom_histogram(alpha = 0.6,
                   breaks = seq(0, 100, by = 3),
                   fill = "palegreen4") +
    theme_niwot() +
    scale_y_continuous(limits = c(0, 100), expand = expand_scale(mult = c(0, 0.1))) +
    geom_step(data = d1, aes(x = x, y = y),
              stat = "identity", colour = "palegreen4") +
    geom_vline(xintercept = mean(carex$hits), linetype = "dotted",
               colour = "palegreen4", size = 1) +
    # Adding in a text allocation - the coordinates are based on the x and y axes
    annotate("text", x = 50, y = 50, label = "The mean number of\nCarex observations was 16.") +
    # "\n" creates a line break
    geom_curve(aes(x = 50, y = 60, xend = mean(carex$hits) + 2, yend = 60),
               arrow = arrow(length = unit(0.07, "inch")), size = 0.7,
               color = "grey30", curvature = 0.3) +
    labs(x = "\nObservation hits", y = "Count\n"))
# Similarly to the annotation, the curved line follows the plot's coordinates
# Have a go at changing the curve parameters to see what happens

ggsave(histogram5, filename = "histogram5.png",
       height = 5, width = 5)

### 4. Format and manipulate large datasets ----
bird_pops <- read.csv("~/Desktop/EDS (Environmental Data Science) Course/course-repository-mzargari/Tutorials_Readings_Videos/Week_08/Week_8_Data/bird_pops.csv")
bird_traits <- read.csv("~/Desktop/EDS (Environmental Data Science) Course/course-repository-mzargari/Tutorials_Readings_Videos/Week_08/Week_8_Data/elton_birds.csv")

# Data formatting ----
# Rename variable names for consistency
names(bird_pops)
names(bird_pops) <- tolower(names(bird_pops))
names(bird_pops)

bird_pops_long <- gather(data = bird_pops, key = "year", value = "pop", 27:71)

# Examine the tidy data frame
head(bird_pops_long)

# Get rid of the X in front of years
# *** parse_number() from the readr package in the tidyverse ***
bird_pops_long$year <- parse_number(bird_pops_long$year)

# Create new column with genus and species together
bird_pops_long$species.name <- paste(bird_pops_long$genus, bird_pops_long$species, sep = " ")

# *** piping from from dplyr
bird_pops_long <- bird_pops_long %>%
  # Remove duplicate rows
  # *** distinct() function from dplyr
  distinct() %>%
  # remove NAs in the population column
  # *** filter() function from dplyr
  filter(is.finite(pop)) %>%
  # Group rows so that each group is one population
  # *** group_by() function from dplyr
  group_by(id) %>%
  # Make some calculations
  # *** mutate() function from dplyr
  mutate(maxyear = max(year), minyear = min(year),
         # Calculate duration
         duration = maxyear - minyear,
         # Scale population trend data
         scalepop = (pop - min(pop))/(max(pop) - min(pop))) %>%
  # Keep populations with >5 years worth of data and calculate length of monitoring
  filter(is.finite(scalepop),
         length(unique(year)) > 5) %>%
  # Remove any groupings you've greated in the pipe
  ungroup()

head(bird_pops_long)

# Which countries have the most data
# Using "group_by()" to calculate a "tally"
# for the number of records per country
country_sum <- bird_pops %>% group_by(country.list) %>%
  tally() %>%
  arrange(desc(n))

country_sum[1:15,] # the top 15

# Data extraction ----
aus_pops <- bird_pops_long %>%
  filter(country.list == "Australia")

# Giving the object a new name so that you can compare
# and see that in this case they are the same
aus_pops2 <- bird_pops_long %>%
  filter(str_detect(country.list, pattern = "Australia"))

# Calculate population change for each forest population
# 4331 models in one go!
# Using a pipe
aus_models <- aus_pops %>%
  # Group by the key variables that we want to iterate over
  # note that if we only include e.g. id (the population id), then we only get the
  # id column in the model summary, not e.g. duration, latitude, class...
  group_by(decimal.latitude, decimal.longitude, class,
           species.name, id, duration, minyear, maxyear,
           system, common.name) %>%
  # Create a linear model for each group
  # Extract model coefficients using tidy() from the
  # *** tidy() function from the broom package ***
  do(broom::tidy(lm(scalepop ~ year, .))) %>%
  # Filter out slopes and remove intercept values
  filter(term == "year") %>%
  # Get rid of the column term as we don't need it any more
  #  *** select() function from dplyr in the tidyverse ***
  dplyr::select(-term) %>%
  # Remove any groupings you've greated in the pipe
  ungroup()

head(aus_models)
# Check out the model data frame

### 5. Synthesise information from different databases ----
# Data synthesis - traits! ----

# Tidying up the trait data
# similar to how we did it for the population data
colnames(bird_traits)
bird_traits <- bird_traits %>% rename(species.name = Scientific)
# rename is a useful way to change column names
# it goes new name =  old name
colnames(bird_traits)

# Select just the species and their diet
bird_diet <- bird_traits %>% dplyr::select(species.name, `Diet.5Cat`) %>%
  distinct() %>% rename(diet = `Diet.5Cat`)

# Combine the two datasets
# The second data frame will be added to the first one
# based on the species column
bird_models_traits <- left_join(aus_models, bird_diet, by = "species.name") %>%
  drop_na()
head(bird_models_traits)

(trends_diet <- ggplot(bird_models_traits, aes(x = diet, y = estimate,
                                               colour = diet)) +
    geom_boxplot())

(trends_diet <- ggplot(data = bird_models_traits, aes(x = diet, y = estimate,
                                                      colour = diet)) +
    geom_jitter(size = 3, alpha = 0.3, width = 0.2))

# Sorting the whole data frame by the mean trends
bird_models_traits <- bird_models_traits %>%
  group_by(diet) %>%
  mutate(mean_trend = mean(estimate)) %>%
  ungroup() %>%
  mutate(diet = fct_reorder(diet, -mean_trend))

# Calculating mean trends per diet categories
diet_means <- bird_models_traits %>% group_by(diet) %>%
  summarise(mean_trend = mean(estimate)) %>%
  arrange(mean_trend)

(trends_diet <- ggplot() +
    geom_jitter(data = bird_models_traits, aes(x = diet, y = estimate,
                                               colour = diet),
                size = 3, alpha = 0.3, width = 0.2) +
    geom_segment(data = diet_means,aes(x = diet, xend = diet,
                                       y = mean(bird_models_traits$estimate),
                                       yend = mean_trend),
                 size = 0.8) +
    geom_point(data = diet_means, aes(x = diet, y = mean_trend,
                                      fill = diet), size = 5,
               colour = "grey30", shape = 21) +
    geom_hline(yintercept = mean(bird_models_traits$estimate),
               size = 0.8, colour = "grey30") +
    geom_hline(yintercept = 0, linetype = "dotted", colour = "grey30") +
    coord_flip() +
    theme_clean() +
    scale_colour_manual(values = wes_palette("Cavalcanti1")) +
    scale_fill_manual(values = wes_palette("Cavalcanti1")) +
    scale_y_continuous(limits = c(-0.23, 0.23),
                       breaks = c(-0.2, -0.1, 0, 0.1, 0.2),
                       labels = c("-0.2", "-0.1", "0", "0.1", "0.2")) +
    scale_x_discrete(labels = c("Carnivore", "Fruigivore", "Omnivore", "Insectivore", "Herbivore")) +
    labs(x = NULL, y = "\nPopulation trend") +
    guides(colour = FALSE, fill = FALSE))

ggsave(trends_diet, filename = "trends_diet.png",
       height = 5, width = 8)

diet_sum <- bird_models_traits %>% group_by(diet) %>%
  tally()

(diet_bar <- ggplot(diet_sum, aes(x = diet, y = n,
                                  colour = diet,
                                  fill = diet)) +
    geom_bar(stat = "identity") +
    scale_colour_manual(values = wes_palette("Cavalcanti1")) +
    scale_fill_manual(values = wes_palette("Cavalcanti1")) +
    guides(colour = FALSE))

(diet_area <- ggplot(diet_sum, aes(area = n, fill = diet, label = n,
                                   subgroup = diet)) +
    geom_treemap() +
    geom_treemap_subgroup_border(colour = "white", size = 1) +
    geom_treemap_text(colour = "white", place = "center", reflow = T) +
    scale_colour_manual(values = wes_palette("Cavalcanti1")) +
    scale_fill_manual(values = wes_palette("Cavalcanti1")) +
    guides(fill = FALSE))  # this removes the colour legend
# later on we will combine multiple plots so there is no need for the legend
# to be in twice

# To display the legend, just remove the guides() line:
(diet_area <- ggplot(diet_sum, aes(area = n, fill = diet, label = n,
                                   subgroup = diet)) +
    geom_treemap() +
    geom_treemap_subgroup_border(colour = "white", size = 1) +
    geom_treemap_text(colour = "white", place = "center", reflow = T) +
    scale_colour_manual(values = wes_palette("Cavalcanti1")) +
    scale_fill_manual(values = wes_palette("Cavalcanti1")))

ggsave(diet_area, filename = "diet_area.png",
       height = 5, width = 8)

# Timeline
# Making the id variable a factor
# otherwise R thinks its a number
bird_models_traits$id <- as.factor(as.character(bird_models_traits$id))

(timeline_aus <- ggplot() +
    geom_linerange(data = bird_models_traits, aes(ymin = minyear, ymax = maxyear,
                                                  colour = diet,
                                                  x = id),
                   size = 1) +
    scale_colour_manual(values = wes_palette("Cavalcanti1")) +
    labs(x = NULL, y = NULL) +
    theme_bw() +
    coord_flip())

# Create a sorting variable
bird_models_traits$sort <- bird_models_traits$diet
bird_models_traits$sort <- factor(bird_models_traits$sort, levels = c("VertFishScav",
                                                                      "FruiNect",
                                                                      "Omnivore",
                                                                      "Invertebrate",
                                                                      "PlantSeed"),
                                  labels = c(1, 2, 3, 4, 5))

bird_models_traits$sort <- paste0(bird_models_traits$sort, bird_models_traits$minyear)
bird_models_traits$sort <- as.numeric(as.character(bird_models_traits$sort))

(timeline_aus <- ggplot() +
    geom_linerange(data = bird_models_traits, aes(ymin = minyear, ymax = maxyear,
                                                  colour = diet,
                                                  x = fct_reorder(id, desc(sort))),
                   size = 1) +
    scale_colour_manual(values = wes_palette("Cavalcanti1")) +
    labs(x = NULL, y = NULL) +
    theme_bw() +
    coord_flip() +
    guides(colour = F) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major.y = element_blank(),
          panel.grid.major.x = element_line(),
          axis.ticks = element_blank(),
          legend.position = "bottom",
          panel.border = element_blank(),
          legend.title = element_blank(),
          axis.title.y = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          plot.title = element_text(size = 20, vjust = 1, hjust = 0),
          axis.text = element_text(size = 16),
          axis.title = element_text(size = 20)))

ggsave(timeline_aus, filename = "timeline.png",
       height = 5, width = 8)

# Combining the datasets
mass <- bird_traits %>% dplyr::select(species.name, BodyMass.Value) %>%
  rename(mass = BodyMass.Value)
bird_models_mass <- left_join(aus_models, mass, by = "species.name") %>%
  drop_na(mass)
head(bird_models_mass)

(trends_mass <- ggplot(bird_models_mass, aes(x = log(mass), y = abs(estimate))) +
    geom_point() +
    geom_smooth(method = "lm") +
    theme_clean() +
    labs(x = "\nlog(mass)", y = "Absolute population change\n"))

# A more beautiful and clear version
(trends_mass <- ggplot(bird_models_mass, aes(x = log(mass), y = abs(estimate))) +
    geom_point(colour = "turquoise4", size = 3, alpha = 0.3) +
    geom_smooth(method = "lm", colour = "deepskyblue4", fill = "turquoise4") +
    geom_label_repel(data = subset(bird_models_mass, log(mass) > 9),
                     aes(x = log(mass), y = abs(estimate),
                         label = common.name),
                     box.padding = 1, size = 5, nudge_x = 1,
                     # We are specifying the size of the labels and nudging the points so that they
                     # don't hide data points, along the x axis we are nudging by one
                     min.segment.length = 0, inherit.aes = FALSE) +
    geom_label_repel(data = subset(bird_models_mass, log(mass) < 1.8),
                     aes(x = log(mass), y = abs(estimate),
                         label = common.name),
                     box.padding = 1, size = 5, nudge_x = 1,
                     min.segment.length = 0, inherit.aes = FALSE) +
    theme_clean() +
    labs(x = "\nlog(mass)", y = "Absolute population change\n"))

ggsave(trends_mass, filename = "trends_mass.png",
       height = 5, width = 6)


