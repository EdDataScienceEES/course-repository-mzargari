# Barplot Workflow
The barplot part of our data journalism project will show the percentage change in emergency oil stocks in European countries following the increase in oil prices.
Oil prices were increased in April of 2021 so months January to April will represent emergency oil stocks before and May through August will represent oil stocks after the price increase. An average for emergency oil stocks before and after will be calculated. The difference between these will be divided by the stocks before and multiplied by 100 to give a percentage value. Percentage change in emergency oil stocks for each European country will be plotted to see if there was a change in emergency oil stocks that could have been caused by the increase in oil prices. 

## Workflow
1. Load packages
	- tidyverse
2. Load emergency stocks dataset and explore
3. Tidy Dataset
	- calculate the average emergency oil stocks for before (Jan-April) and after (May-Aug) and use mutate to create two new columns ("before" and "after") containing these 	   values
	- calculate the percentage change in emergency oil stocks and use mutate to create a new column called "percentage_change"
	- re-arrange the dataset so countries are in descending order of percentage change in emergecny oil stocks
4. Create barplot percentage change in emergency oil stocks for European countries
	- define x and y variables and dataset
	- define graph title and font size
	- axes titles are spaced from axes
	- define axes titles (and units), font size, angle and location
	- make sure x-axis labels aren't covered by bars 
	- add colour gradient (should match map and be colourblind friendly)
	- remove gridlines (use theme_bw or similar)
5. Save plot as pdf and png- consider image dimensions 
6. Save with map as panel using grid.arrange function

(Possibly also create a theme to use on both map and barplot.)
