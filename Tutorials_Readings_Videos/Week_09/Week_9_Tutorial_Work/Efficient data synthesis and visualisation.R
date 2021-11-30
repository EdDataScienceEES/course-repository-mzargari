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
# devtools::install_github("wilkox/treemapify")
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



