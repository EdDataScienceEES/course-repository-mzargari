# Michael's clean up of the file
# Final analysis

Data <- read.csv("/Users/Downloads/CC-4-Datavis-master/LPIdata_CC.csv")

library(tidyr)
data_fix <- gather(Data, "year", "abundance", 9:53)
library(readr)
data_fix$year <- parse_number(data_fix$year)
names(data_fix)
names(data_fix) <- tolower(names(data_fix))
data_fix$abundance <- as.numeric(data_fix$abundance)

library(dplyr)
lpiBiomes <- data_fix %>%
  group_by(biome)%>%
  summarise(Pop. = n())
lpiBiomes[1:5, 1:2]

library(ggplot2)
ThemeForLPI <- function() {
theme_bw() +
theme(axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),
      axis.text.y = element_text(size = 12), 
      axis.title.x = element_text(size = 14,face = "plain"),
      axis.title.y = element_text(size = 14, face = "plain"),             
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank(),
      panel.grid.minor.y = element_blank(),
      panel.grid.major.y = element_blank(),  
      plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), units = , "cm"),
      plot.title = element_text(size=20, vjust=1, hjust=0.5),
      legend.text = element_text(size=12, face="italic"), 
      legend.title = element_blank(),
      legend.position = c(0.9, 0.9))
  }

levels(data_fix$biome)

#3 different graphs
type = "bar"
plot <- ggplot(data_fix, aes(biome, color = biome)) + {
  if(type=="bar")geom_bar() else geom_point(stat="count")
  } +
	ThemeForLPI() + ylab("Number of populations") + 
  xlab("Biome") +
	theme(legend.position = "none")
plot  # plot the ggplot plot

type = "point"
plot <- ggplot(data_fix, aes(biome, color = biome)) + 
  {
  if(type == "bar") geom_bar() else geom_point(stat = "count")
    } +
	ThemeForLPI() + 
  ylab("Number of populations") + 
  xlab("Biome") +
	theme(legend.position = "none")
plot
type = "bar"
pdf(file = "plot1.pdf",  width = 13.33, height = 26.66)
ggplot(data_fix, 
       aes(biome, color = biome)) + {
         if(type == "bar")geom_bar() else geom_point(stat = "count")
         } +
	ThemeForLPI() + 
  ylab("Number of populations") + 
  xlab("Biome") +
	theme(legend.position = "none") 
dev.off()
dev.off()

library(RCurl)
