This file includes all the meeting notes for Challenge 2 Group 2. It contains major discussion points and tasks to complete before the next meeting. 

## Tuesday 26 October: first meeting

We first discussed about our main topic of interest and whether data was easily accessible within such topics. The topics mentioned were the following: 
-	Fishing and overfishing 
-	Climate change 
-	Depression across country 
-	Food production and pollinator 
-	Energy poverty and indoor pollution: environmental inequity 
-	Smoking problem 

After a vote, we decided to look at whether the prevalence of mental health problem corrolates with the prevalence of drug abuse. We also plotted a graph of what the
final output would look like (as seen below) and then produced a workflow of what was needed to procude such graph: 

### Workflow: 

1.	Get mental health and substance abuse data set from OurWorldInData.com 

2. Tidy the data set: 
- Take out eating disorders from the data set 
- Combine alcohol and drug use into prevalence of drug abuse 
- Combine the mental health specific columns into a single column: prevalence of mental health disorders 

3. Average the values for all the years into a single value per country

4. Plot a graph for each individual contry and fit a linear model to the data points, or group per continent. 

We also agreed on a common coding etiquette which will be added on the repository and issues can be pulled on possible changes to this. 

### Tasks: 
- Michael is responsible for tidying the data 
- Mathis is creating the meeting file and coding etiquette for coding
- Create a README file for the repository  

### EXTRA:
We will also use a Twitter harvesting function to see where the current trends for eco-anxiety are located in the world, or the number of tweets throughout the year. 

## Thursday 28 October: second meeting

Following the Data Science class today, we agreed that we had to pick a different topic as the one we had chosen is outdated and also doesn't link back to a clear news story.

### New topic: Energy dependecy and subsistency of European countries 

Following the current events regarding the increase in energy prices in Europe, we thought that it would be good to have a look at this topic. 

We first had a look at the current news articles relating to the topic: 
https://www.euronews.com/2021/10/28/why-europe-s-energy-prices-are-soaring-and-could-get-much-worse
https://www.ft.com/content/52341bf5-ffc4-490d-8393-2c82d84df9b4 (Putin intervention)

### Rationale: 
Todays' announcement that energy prices are now falling after the intervention of Putin led us to question the dependency of European countries on the main oil, gas and electricity-producing countries. 

### Data collection and visualization:
We found data on the emergency energy stocks per country on the Euro Stat Data Browser: 
- https://ec.europa.eu/eurostat/data/database/ (main database)
- https://ec.europa.eu/eurostat/databrowser/view/nrg_stk_gasm/default/table?lang=en (specific to emergency oil stocks)
- https://ec.europa.eu/eurostat/databrowser/view/nrg_stk_gasm/default/table?lang=en (stock level for gas)
- https://ec.europa.eu/eurostat/databrowser/view/nrg_stk_gas/default/bar?lang=en (stock levels for gaseous and liquefied natural gas)
- https://ec.europa.eu/eurostat/databrowser/view/nrg_stk_oil/default/map?lang=en (Stock levels for oil)

We could then have a graph showing the country with the biggest emergency stock (thus most resilient to the crisis in the long-term for example if Putin had decided not to supply Europe) and how this relates to the share of supply for the main energy groups (gas, electricity and oil).

## Friday 29 October: third meeting 

We met on Friday and discussed the new topic more in depth, looking at the data available and what we wanted to know within the context of the current news. We decided to produce two complementary graphs within one panel: 

1. A map of the emergency stocks of oil in Europe broken down by country: showing a gradient of colour.  
2. A bar plot showing the different allocations towards emergency and commercial stock in Europe broken down by country. 

We set a group deadline of Tuesday 2 November to finish the main bit of code. The tasks were allocated as followed: 

- Lou and Tirso: produce the map 
- Mathis and Anna: produce the bar plot 
- Stavros: produce the news brief 
- Michael: arrange the repository 

## Sunday 31 October: Anna and Mathis meeting 

Anna and I met to create the worflow for our part of the assignment. We originally wanted to create a barplot showing the difference between commerical and emergency stocks per country. However one of the data set was using days until stocks are finished and the other is in tons. We then decided to change the figure that we were going to produce: 

### New figure

We will now be creating a bar plot showing the difference in investment in emergency stocks as energy prices started to rise in Europe broken down by country. This will allow us to see which country increased their stocks and which countries used some of it. Mathis noted that the Ireland's emergency stocks showed on of the highest percentage increases which might be something interesting to note in our pitch given that their increase in oil prices was very high. 
The workflow for the creation of this graph will be added to the repository by Anna. 

## Tuesday 2 November: 4th meeting 

We met to see how everyone was doing on their respective tasks and to agree on the next steps. 

- Anna and Mathis had finished to produce their graph and still had to make the script more readable and create a theme to be used for future projects based on the produced output.
- Lou and Tirso still had to produce the map. 
- Stavros is working on making the newspaper brief. 

We agreed to meet again on Wedenesday and to have produce a beautified map, organized the scripts and create a common them to be used. The scripts will then be combined into an effiient master scirpt to create the final panel output and save it as both pdf and png. 

Tasks: 
- Anna will tidy the script 
- Michael will create a theme 
- Lou and Tirso will produce the map 
- Starvos will write the brief 

## Wednesday 4 November: 5th meeting 

We met for the last time to finalize the project. We agreed to agree over messenger (or in the issues on whether we were all okay with the changes before the deadline tommorow). 

Tasks before deadline: 
- Mathis will create the common theme, combine the two scripts making them readable, effective and non-redundant, create final panel output 
- Anna will add README files to all created folders 
- Lou will make a document gathering evidence of collaboration over messenger 
- Stavros will create the brief and include the final panel in it
- Michael will add header descprition to group 2 final script 

Voilà :) 
