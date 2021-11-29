# Changes in Forest Coverage at Pilliga Nature Reserve in Eastern Australia.
![image](https://user-images.githubusercontent.com/91272449/143470966-e2516218-06a0-4fd8-9931-2fb59b69769b.png)
(Inland Rail, 2021)
# Group 4

# Group participants

Michael Zargari       (Github: @mzargari)

Giada Leone           (Github: @giadaleone99)

David Du              (Github: @xdu071)

Sarka Ondrouchova     (Github: @sharkie58)

Lubin Grosbuis        (Github: @lubin-g)




# Research question
__How much forest cover loss and gain has occurred in your protected area?__


# Introduction

Pilliga Nature Reserve, Located in New South Wales, Eastern Australia, was created in 2005 following approval by Australia's minister for the Environment. This reserve harbors the nation's largest remaining native forest, covering 80627 hectares of land (NSW National Parks and Wildlife Service, 2015). In the context of on going climate change; Eastern Australia has been prone to increasingly frequent extreme climatic events, such as droughts, and a longer, more intense fire season (Henessy et al., 2005). Pilliga Nature Reserve is known to undergo a natural annual regime of forest fires and vegetation recovery. However, intensification of forest fires has led to concerns on the overall viability of the reserve through time, and reserve management plans have incorporated fire mitigation strategies since 2016 (NSW National Parks and Wildlife Service, 2016). To monitor effectiveness of these mitigation strategies and the overall balance in forest loss and gains through time, our research team investigates how forest cover has changed through time since the creation of the reserve, using the google earth engine, and Hansen et al.'s global database of forest change.


# Workflow

- Develop a research question and hypothesis
- Write introductions
- Import data in GEE
- Calculate forest losses and changes in GEE
- Download the data in R
- Visualise the trends in R
- Conclude the results and polish the code and the repo

Roles: 

<<<<<<< HEAD
Lubin: research and introduction, Figure, references, map and description  

Michael: filled out the final report file answering the questions  

Giada: visualisation  

=======
Lubin: research and introduction, Figure, references, map and description
Michael: provides the dongle and fills out the markdown file  
Giada: visualisation  
>>>>>>> 9874af8ea07cec2645846d9ac1baa66aad7c4fb0
David: creates the script in R  
Sharka: runs script in GEE and saves data, helps with readme, pt 4/5  


# Specific hypotheses and predictions

We know that this areas experiences regular forest fires as part of its healthy nutrient cycle, however since the beginning of the 21st century, seasons have gotten drier and fires have burned longer over larger areas. The factors that could influence forest cover change in the Pilliga Nature Reserve would be the weather patterns in the area over prior years (i.e. how dry the climate is), tourists that may set off manmade fires, deforestation, and annual rain coverage.

Hypothesis: Based on our research, we hypothesis that forest coverage will decrease over this 16 year period in the Pilliga Nature Reserve.


# Methods


We used the Google Earth Engine (GEE) to analyse the forest change in the Pink Lake national park. Specifically, we used the open source global Hansen forest change dataset from 2017 ("global_forest_change_2017_v1_5") to filter data on the Pink Lake national park between 2001 and 2016, and then calculate the forest change (combined loss and gain) within GEE. The calculation of forest change is available in the repository in the script [group4_GEE_code.rtf](https://github.com/EdDataScienceEES/challenge4-group-4-1/blob/master/group4/group4_GEE_code.rtf). We then exported the data to csv (available in the repository at [forest_change_Pink_Lake.csv](https://github.com/EdDataScienceEES/challenge4-group-4-1/blob/master/group4/forest_change_Pink_Lake.csv)) and further visualisation was done in R, using RStudio.

R was used to filter the data and create a bar chart to visualize the trends in each year between 2001 and 2016. A map visualization was created.

# Data vis and summary methods

After filtering out the data, we created a barplot using the ggplot function to compare forest gains and losses from 2001 to 2016.


```
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
```

# 1. Maps of forest cover change for your protected area

_
![image](https://user-images.githubusercontent.com/91272449/143478445-45466af7-d31d-4d46-9d32-5ae57585381f.png)
Figure 1: Map of the forest change between 2001 and 2016 in the Pilliga Lake National Reserve in East Australia. Red Shaded areas represent Pilliga Nature reserve areas and boundaries. Purple and orange areas represent areas of overall forest cover loss, and gain, respectively.

# 2. Visualisation of the amount of forest cover loss and gain for your protected area
![image](https://user-images.githubusercontent.com/91272449/143479720-29c204ba-b3e4-4eaf-b149-c7ad68309895.png)

![image](https://user-images.githubusercontent.com/91272449/143479799-6721725d-7cec-4049-a070-d60ecf55b4cf.png)

**Figure 2: Forest losses and gains between 2001 and 2016 in the Pink Lake National Reserve in East Australia**

For the first barplot we can see the effect of the forset fires in 2002, 2003 and 2006 on the forest coverage area as losses were the greatest in these years.
In the second plot we can see there is a gradual recovery of forest area as there are no losses in these years

# 3. How do your results compare with your predictions? What do you think might explain the patterns you found?

Our results are in line with our predictions as we initially hypothesized that the forest area has decreased which is in line with what has happened. We believe that large forest fires in 2002, 2003, and 2006 are what dwindled the impact of the gains that the forest has experienced from 2001 to 2016. If trends continue, the forest gains will not make up for the anount of forest loss in select years.


# 4. What other datasets, available within the GEE, could you use to test the potential drivers of forest cover change in your group's protected area that you identified in point #3. ?

Considering the weather event occurence mentioned in the introduction, the changes in forest cover in Pink Lake can be driven by both rainfall and forest fire occurence. For this, we can choose two datasets available in the Google Earth Engine, namely:  
[FIRMS: Fire Information for Resource Management System,](https://developers.google.com/earth-engine/datasets/catalog/FIRMS) which provides information on fire management, including active fire locations from 2000 to 2021,  
and [GRIDMET DROUGHT: CONUS Drought Indices](https://developers.google.com/earth-engine/datasets/catalog/GRIDMET_DROUGHT) which contains information on precipitation and drought from 1980 to 2021.


# 5. What research question and hypotheses would you test with those additional datasets in your proposed future research and why does that research matter for the park management?
We would test whether the rainfall and active fires are significantly correlated with forest cover change, or in other words, whether the reduction in rainfall is negativelly affecting forest gain and whether active forest fire occurence has an effect on forest loss. This could be used by managers of the Natural Reserve to prioritize their efforts into either forest prevention or pushing wider climate goals within the country.

# Conclusions

We have found that forest coverage in Pilliga Nature Reserve in Eastern Australia has been increasing, but the overall forest coverage has decreased. We have found this by comparing the forest changes from 2001 to 2016. We see that the gains pale in comparison to the forest losses from wildfires. This indicates that the reserve forest size has decreased which indicates a loss in biodiversity and an increase habitat destruction. As climates are getting hotter and drier, we can expect these effects to be exacerbated by climate change where forest fires continue to burn longer and wider. Forest management is strongly advised and efforts towards maintaining minimizing climate change and upkeeping the forest is crucial to preserve the biodiversity of the forest. 

# References
Inland Rail (2021) Available at. https://inlandrail.artc.com.au/where-we-go/projects/narromine-to-narrabri/works-and-planning/

Hennessy, K., Lucas, C., Nicholls, N., Bathols, J., Suppiah, R., Ricketts, J. (2005) Climate Change Impacts on Fire Weather in South-East Australia, CSIRO Marine and Atmospheric Research, Bushfire CRC and Australian Bureau of Meteorology. Available at: https://www.researchgate.net/profile/James-Ricketts-3/publication/252471836_Climate_Change_Impacts_on_Fire-Weather_in_South-East_Australia/links/54a86d870cf257a6360bdfea/Climate-Change-Impacts-on-Fire-Weather-in-South-East-Australia.pdf

NSW National Parks and Wildlife Service (2015) Plan of Management, Office of Environment and Heritage. Available at: https://www.environment.nsw.gov.au/-/media/OEH/Corporate-Site/Documents/Parks-reserves-and-protected-areas/Parks-plans-of-management/pilliga-nature-reserve-plan-of-management-150615.pdf

NSW National Parks and Wildlife Service (2016) Fire Management Strategy. Available at: https://www.environment.nsw.gov.au/-/media/OEH/Corporate-Site/Documents/Parks-reserves-and-protected-areas/Fire-management-strategies/pilliga-south-fire-management-strategy-170072.pdf
