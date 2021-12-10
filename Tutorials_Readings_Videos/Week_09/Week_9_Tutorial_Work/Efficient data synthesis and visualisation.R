########################################################################
###            Efficient data synthesis and visualisation           ###
###                                                                  ###
###                        MICHAEL ZARGARI                           ###
###                       28-November-2021                           ###
###               CONTACT EMAIL: S2253374@ED.AC.UK                   ###
###                                                                  ###
###   https://ourcodingclub.github.io/tutorials/data-synthesis/      ###
########################################################################

# Very similar to Week 8's "Efficient and beautiful data synthesis.R"

setwd("~/Desktop/EDS (Environmental Data Science) Course/course-repository-mzargari/Tutorials_Readings_Videos/Week_09/Week_9_Outputs")

# Libraries
library(tidyverse)
library(broom)
library(wesanderson)
library(ggthemes)
library(ggalt)
library(ggrepel)
library(rgbif)
library(CoordinateCleaner)
library(treemapify)
library(gridExtra)

### 1. Format and manipulate large datasets ----

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

# Check the distribution of duration across the time-series
# A quick and not particularly pretty graph
(duration_hist <- ggplot(aus_pops, aes(x = duration)) +
    geom_histogram())

(duration_hist <- ggplot() +
    geom_histogram(data = aus_pops, aes(x = duration), alpha = 0.6, 
                   breaks = seq(5, 40, by = 1), fill = "turquoise4"))

(duration_hist <- ggplot(aus_pops, aes(x = duration)) +
    geom_histogram(alpha = 0.6, 
                   breaks = seq(5, 40, by = 1), 
                   fill = "turquoise4") +
    # setting new colours, changing the opacity and defining custom bins
    scale_y_continuous(limits = c(0, 600), expand = expand_scale(mult = c(0, 0.1))))
# the final line of code removes the empty blank space below the bars

# Adding an outline around the whole histogram
h <- hist(aus_pops$duration, breaks = seq(5, 40, by = 1), plot = FALSE)
d1 <- data.frame(x = h$breaks, y = c(h$counts, NA))  
d1 <- rbind(c(5,0), d1)

(duration_hist <- ggplot() +
    geom_histogram(data = aus_pops, aes(x = duration), alpha = 0.6, 
                   breaks = seq(5, 40, by = 1), fill = "turquoise4") +
    scale_y_continuous(limits = c(0, 600), expand = expand_scale(mult = c(0, 0.1))) +
    geom_step(data = d1, aes(x = x, y = y),
              stat = "identity", colour = "deepskyblue4"))

summary(d1) # it's fine, you can ignore the warning message
# it's because some values don't have bars
# thus there are missing "steps" along the geom_step path

(duration_hist <- ggplot() +
    geom_histogram(data = aus_pops, aes(x = duration), alpha = 0.6, 
                   breaks = seq(5, 40, by = 1), fill = "turquoise4") +
    scale_y_continuous(limits = c(0, 600), expand = expand_scale(mult = c(0, 0.1))) +
    geom_step(data = d1, aes(x = x, y = y),
              stat = "identity", colour = "deepskyblue4") +
    geom_vline(xintercept = mean(aus_pops$duration), linetype = "dotted",
               colour = "deepskyblue4", size = 1))

(duration_hist <- ggplot() +
    geom_histogram(data = aus_pops, aes(x = duration), alpha = 0.6, 
                   breaks = seq(5, 40, by = 1), fill = "turquoise4") +
    scale_y_continuous(limits = c(0, 600), expand = expand_scale(mult = c(0, 0.1))) +
    geom_step(data = d1, aes(x = x, y = y),
              stat = "identity", colour = "deepskyblue4") +
    geom_vline(xintercept = mean(aus_pops$duration), linetype = "dotted",
               colour = "deepskyblue4", size = 1) +
    # Adding in a text allocation - the coordinates are based on the x and y axes
    annotate("text", x = 15, y = 500, label = "The mean duration\n was 23 years.") +
    # "\n" creates a line break
    geom_curve(aes(x = 15, y = 550, xend = mean(aus_pops$duration) - 1, yend = 550),
               arrow = arrow(length = unit(0.07, "inch")), size = 0.7,
               color = "grey20", curvature = -0.3))
# Similarly to the annotation, the curved line follows the plot's coordinates
# Have a go at changing the curve parameters to see what happens

(duration_hist <- ggplot() +
    geom_histogram(data = aus_pops, aes(x = duration), alpha = 0.6, 
                   breaks = seq(5, 40, by = 1), fill = "turquoise4") +
    scale_y_continuous(limits = c(0, 600), expand = expand_scale(mult = c(0, 0.1))) +
    geom_step(data = d1, aes(x = x, y = y),
              stat = "identity", colour = "deepskyblue4") +
    geom_vline(xintercept = mean(aus_pops$duration), linetype = "dotted",
               colour = "deepskyblue4", size = 1) +
    annotate("text", x = 15, y = 500, label = "The mean duration\n was 23 years.") +
    geom_curve(aes(x = 15, y = 550, xend = mean(aus_pops$duration) - 1, yend = 550),
               arrow = arrow(length = unit(0.07, "inch")), size = 0.7,
               color = "grey20", curvature = -0.3) +
    labs(x = "\nDuration", y = "Number of time-series\n") +
    theme_clean())

ggsave(duration_hist, filename = "hist1.png",
       height = 5, width = 6)


### 2. Automate repetitive tasks using pipes and functions ----

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
  do(mod = lm(scalepop ~ year, data = .)) %>%
  # Extract model coefficients using tidy() from the
  # *** tidy() function from the broom package ***
  tidy(mod) %>%
  # Filter out slopes and remove intercept values
  filter(term == "year") %>%
  # Get rid of the column term as we don't need it any more
  #  *** select() function from dplyr in the tidyverse ***
  dplyr::select(-term) %>%
  # Remove any groupings you've greated in the pipe
  ungroup()

head(aus_models)
# Check out the model data frame


# Make histograms of slope estimates for each system -----
# Set up new folder for figures
# Set path to relevant path on your computer/in your repository
path1 <- "system_histograms/"
# Create new folder
dir.create(path1) # skip this if you want to use an existing folder
# but remember to replace the path in "path1" if you're changing the folder

# First we will do this using dplyr and a pipe
aus_models %>%
  # Select the relevant data
  dplyr::select(id, system, species.name, estimate) %>%
  # Group by taxa
  group_by(system) %>%
  # Save all plots in new folder
  do(ggsave(ggplot(., aes(x = estimate)) +
              # Add histograms
              geom_histogram(colour = "deepskyblue4", fill = "turquoise4", binwidth = 0.02) +
              # Use custom theme
              theme_clean() +
              # Add axis lables
              xlab("Population trend (slopes)"),
            # Set up file names to print to
            filename = gsub("", "", paste0(path1, unique(as.character(.$system)),
                                           ".pdf")), device = "pdf"))


# Selecting the relevant data and splitting it into a list
aus_models_wide <- aus_models %>%
  dplyr::select(id, system, estimate) %>%
  spread(system, estimate) %>%
  dplyr::select(-id)

# We can apply the `mean` function using `purrr::map()`:
system.mean <- purrr::map(aus_models_wide, ~mean(., na.rm = TRUE))
# Note that we have to specify "."
# so that the function knows to use our taxa.slopes object
# This plots the mean population change per taxa
system.mean

### Using functions ----

# First let's write a function to make the plots
# This function takes one argument x, the data vector that we want to make a histogram

# note that when you run code for a function, you have to place the cursor
# on the first line (so not in the middle of the function) and then run it
# otherwise you get an error
# For most other things (like normal ggplot2 code, it doesn't matter 
# if the cursor is on the first line, or the 3rd, 5th...)
plot.hist <- function(x) {
  ggplot() +
    geom_histogram(aes(x), colour = "deepskyblue4", fill = "turquoise4", binwidth = 0.02) +
    theme_clean() +
    xlab("Population trend (slopes)")
}

system.plots <- purrr::map(aus_models_wide, ~plot.hist(.))
# We need to make a new folder to put these figures in
path2 <- "system_histograms_purrr/"
dir.create(path2)

# *** walk2() function in purrr from the tidyverse ***
walk2(paste0(path2, names(aus_models_wide), ".pdf"), system.plots, ggsave)


### 3. Synthesise information from different databases

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

# Calculating mean trends per diet categories
diet_means <- bird_models_traits %>% group_by(diet) %>%
  summarise(mean_trend = mean(estimate)) %>%
  arrange(mean_trend)

# Sorting the whole data frame by the mean trends
bird_models_traits <- bird_models_traits %>%
  group_by(diet) %>%
  mutate(mean_trend = mean(estimate)) %>%
  ungroup() %>%
  mutate(diet = fct_reorder(diet, -mean_trend))

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

# Get the shape of Australia
australia <- map_data("world", region = "Australia")

# Make an object for the populations which don't have trait data
# so that we can plot them too
# notice the use of anti_join that only returns rows
# in the first data frame that don't have matching rows
# in the second data frame
bird_models_no_traits <- anti_join(aus_models, bird_diet, by = "species.name")

(map <- ggplot() +
    geom_map(map = australia, data = australia,
             aes(long, lat, map_id = region), 
             color = "gray80", fill = "gray80", size = 0.3) +
    # you can change the projection here
    coord_proj(paste0("+proj=merc"), ylim = c(-9, -45)) +
    theme_map() +
    geom_point(data = bird_models_no_traits, 
               aes(x = decimal.longitude, y = decimal.latitude),
               alpha = 0.8, size = 4, fill = "white", colour = "grey30",
               shape = 21,
               position = position_jitter(height = 0.5, width = 0.5)) +
    geom_point(data = bird_models_traits, 
               aes(x = decimal.longitude, y = decimal.latitude, fill = diet),
               alpha = 0.8, size = 4, colour = "grey30", shape = 21,
               position = position_jitter(height = 0.5, width = 0.5)) +
    scale_fill_manual(values = wes_palette("Cavalcanti1"),
                      labels = c("Carnivore", "Fruigivore", "Omnivore", "Insectivore", "Herbivore")) +
    # guides(colour = FALSE) + # if you wanted to hide the legend
    theme(legend.position = "bottom",
          legend.title = element_blank(),
          legend.text = element_text(size = 12),
          legend.justification = "top"))

# You don't need to worry about the warning messages
# that's just cause we've overwritten the default projection

ggsave(map, filename = "map1.png",
       height = 5, width = 8)


diet_sum <- bird_models_traits %>% group_by(diet) %>%
  tally()

(diet_bar <- ggplot(diet_sum, aes(x = diet, y = n,
                                  colour = diet,
                                  fill = diet)) +
    geom_bar(stat = "identity") +
    scale_colour_manual(values = wes_palette("Cavalcanti1")) +
    scale_fill_manual(values = wes_palette("Cavalcanti1")) +
    guides(fill = FALSE))

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

# To display the legend, just remove the guides() line
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

### Download occurrence data through R ----
# Even more data synthesis - adding in occurrence data
# and comparing it across where emus are monitored

# Let's see how many emu populations are included in the Living Planet Database
emu <- bird_pops %>% filter(common.name == "Emu") # just one!

# Download species occurrence records from the Global Biodiversity Information Facility
# *** rgbif package and the occ_search() function ***
# You can increase or decrease the limit to get more records - 10000 takes a couple of minutes
emu_locations <- occ_search(scientificName = "Dromaius novaehollandiae", limit = 10000,
                            hasCoordinate = TRUE, return = "data") %>%
  # Simplify occurrence data frame
  dplyr::select(key, name, decimalLongitude,
                decimalLatitude, year,
                individualCount, country)

# We can check the validity of the coordinates using the CoordinateCleaner package
emu_locations_test <- clean_coordinates(emu_locations, lon = "decimalLongitude", lat = "decimalLatitude",
                                        species = "name", tests = c("outliers", "zeros"), 
                                        outliers_method = "distance", outliers_td = 5000)
# No records were flagged

# We do want to focus on just Australia though, as that's the native range
summary(as.factor(emu_locations$country))
# Thus e.g. no German emus
emu_locations <- emu_locations %>% filter(country == "Australia")

# Getting the data for the one monitored emu population
emu_long <- bird_pops_long %>% filter(common.name == "Emu") %>%
  drop_na(pop)

(emu_map <- ggplot() +
    geom_map(map = australia, data = australia,
             aes(long, lat, map_id = region), 
             color = "gray80", fill = "gray80", size = 0.3) +
    coord_proj(paste0("+proj=merc"), ylim = c(-9, -45)) +
    theme_map() +
    geom_point(data = emu_locations, 
               aes(x = decimalLongitude, y = decimalLatitude),
               alpha = 0.1, size = 1, colour = "turquoise4") +
    geom_label_repel(data = emu_long[1,],
                     aes(x = decimal.longitude, y = decimal.latitude,
                         label = location.of.population),
                     box.padding = 1, size = 5, nudge_x = -30,
                     nudge_y = -6,
                     min.segment.length = 0, inherit.aes = FALSE) +
    geom_point(data = emu_long[1,], 
               aes(x = decimal.longitude, y = decimal.latitude),
               size = 5, fill = "deepskyblue4", 
               shape = 21, colour = "white") +
    theme(legend.position = "bottom",
          legend.title = element_text(size = 16),
          legend.text = element_text(size = 10),
          legend.justification = "top"))

ggsave(emu_map, filename = "emu_map.png",
       height = 5, width = 8)

(emu_trend <- ggplot(emu_long, aes(x = year, y = pop)) +
    geom_line() +
    geom_point())

(emu_trend <- ggplot(emu_long, aes(x = year, y = pop)) +
    geom_line(linetype = "dotted", colour = "turquoise4") +
    geom_point(size = 6, colour = "white", fill = "deepskyblue4",
               shape = 21) +
    geom_rect(aes(xmin = 1987.5, xmax = 1988.5, ymin = 0, ymax = 0.3),
              fill = "turquoise4", alpha = 0.03) +
    annotate("text", x = 1986.2, y = 0.25, colour = "deepskyblue4",
             label = "Maybe 1988 was a wetter year\n or something else happened...",
             size = 4.5) +
    scale_y_continuous(limits = c(0, 0.3), expand = expand_scale(mult = c(0, 0)),
                       breaks = c(0, 0.1, 0.2, 0.3)) +
    labs(x = NULL, y = bquote(atop('Emus per ' ~ (km^2), ' ')),
         title = "Emu abundance in the\n pastoral zone of South Australia\n") +
    theme_clean())

ggsave(emu_trend, filename = "emu_trend.png",
       height = 5, width = 8)

### 5. Create beautiful and informative figure panels

# Panels ----
# Create panel of all graphs
# Makes a panel of the map and occurrence plot and specifies the ratio
# i.e., we want the map to be wider than the other plots
emu_panel <- grid.arrange(emu_map, emu_trend, ncol = 2)

# suppressWarnings() suppresses warnings in the ggplot call here
# (the warning messages about the map projection)
emu_panel <- suppressWarnings(grid.arrange(emu_map, emu_trend, 
                                           ncol = 2, widths = c(1.2, 0.8)))

(emu_trend <- ggplot(emu_long, aes(x = year, y = pop)) +
    geom_line(linetype = "dotted", colour = "turquoise4") +
    geom_point(size = 6, colour = "white", fill = "deepskyblue4",
               shape = 21) +
    geom_rect(aes(xmin = 1987.5, xmax = 1988.5, ymin = 0, ymax = 0.3),
              fill = "turquoise4", alpha = 0.03) +
    annotate("text", x = 1986, y = 0.25, colour = "deepskyblue4",
             label = "Maybe 1988 was a wetter year\n or something else happened...",
             size = 4.5) +
    scale_y_continuous(limits = c(0, 0.3), expand = expand_scale(mult = c(0, 0)),
                       breaks = c(0, 0.1, 0.2, 0.3)) +
    labs(x = "\n\n", y = bquote(atop('Emus per ' ~ (km^2), ' ')),
         title = "\n\nEmu abundance in the\n pastoral zone of South Australia\n") +
    theme_clean())

emu_panel <- suppressWarnings(grid.arrange(emu_map, emu_trend, 
                                           ncol = 2, widths = c(1.1, 0.9)))

ggsave(emu_panel, filename = "emu_panel.png", height = 6, width = 14)

# Map on top, two panels below
diet_panel <- suppressWarnings(grid.arrange(timeline_aus,
                                            trends_diet, ncol = 2))
diet_panel_map <- suppressWarnings(grid.arrange(map, diet_panel, nrow = 2))
# The equal split might not be the best style for this panel

# change the ratio
diet_panel_map <- suppressWarnings(grid.arrange(map, diet_panel, nrow = 2, heights = c(1.3, 0.7)))

(timeline_aus <- ggplot() +
    geom_linerange(data = bird_models_traits, aes(ymin = minyear, ymax = maxyear, 
                                                  colour = diet,
                                                  x = fct_reorder(id, desc(sort))),
                   size = 1) +
    scale_colour_manual(values = wes_palette("Cavalcanti1")) +
    labs(x = NULL, y = "\n") +
    theme_clean() +
    coord_flip() +
    guides(colour = F) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major.y = element_blank(),
          panel.grid.major.x = element_line(),
          axis.ticks = element_blank(),
          legend.position = "bottom", 
          panel.border = element_blank(),
          legend.title = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          plot.title = element_text(size = 20, vjust = 1, hjust = 0),
          axis.text = element_text(size = 16), 
          axis.title = element_text(size = 20)))

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
    theme_minimal() +
    theme(axis.text.x = element_text(size = 14),
          axis.text.y = element_text(size = 14),
          axis.title.x = element_text(size = 14, face = "plain"),             
          axis.title.y = element_text(size = 14, face = "plain"),             
          plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), units = , "cm"),
          plot.title = element_text(size = 15, vjust = 1, hjust = 0.5),
          legend.text = element_text(size = 12, face = "italic"),          
          legend.title = element_blank(),                              
          legend.position = c(0.5, 0.8)) +
    scale_colour_manual(values = wes_palette("Cavalcanti1")) +
    scale_fill_manual(values = wes_palette("Cavalcanti1")) +
    scale_y_continuous(limits = c(-0.23, 0.23),
                       breaks = c(-0.2, -0.1, 0, 0.1, 0.2),
                       labels = c("-0.2", "-0.1", "0", "0.1", "0.2")) +
    scale_x_discrete(labels = c("Carnivore", "Fruigivore", "Omnivore", "Insectivore", "Herbivore")) +
    labs(x = NULL, y = "\nPopulation trend") +
    guides(colour = FALSE, fill = FALSE))

diet_panel <- suppressWarnings(grid.arrange(timeline_aus,
                                            trends_diet, ncol = 2))
diet_panel_map <- suppressWarnings(grid.arrange(map, diet_panel, nrow = 2, heights = c(1.3, 0.7)))

ggsave(diet_panel_map, filename = "diet_panel.png", height = 9, width = 10)




