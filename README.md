The INF6027 repository contains the R code for a project that aims to garner insight into potential risk factors for road accident severity in the UK, based on GOV.UK data from 2012 to 2023. Specifically, this project looks at road conditions and rurality and how these variables relate to accident severity. 

There are three research questions this project aims to answer:
  1.	How has the prevalence of severe road accidents changed in the UK between 2012 and 2023?
  2.	How does the prevalence of severe road accidents vary based on road conditions and rurality?
  3.	To what extent can road conditions and rurality predict the severity of road accidents in the UK?

The project is split into three R files. The preprocessing file should be used first as this includes all relevant packages and the importing and preprocessing of data files for subsequent analysis. The Tables and Visualizations file contains the code to produce descriptive tables and visualizations for specific insights. This file specifially relates to research questions 1 and 2. The multinomial logistic regression file contains the code for creating a multinomial logistic regression which aims to answer research question 3. This file contains three models which vary by sampling technique.

The key findings from these analyses are as follows.

In relation to the first research question ("How has the prevalence of severe road accidents changed in the UK between 2012 and 2023?"), the bar chart of percentage change in accident prevalence by severity (Figure 1) demonstrates that accidents of Fatal/Serious severity have increased whereas those of Slight severity have decreased. Table 1 further demonstrates this trend whilst emphasising that Slight accidents are significantly more prevalent than Fatal/Serious accidents. 

In relation to the second research question ("How does the prevalence of severe road accidents vary based on road conditions and rurality?"), the bar chart of the percentage of accidents that are Fatal/Serious by road condition (Figure 2) shows that accidents in adverse road conditions are more likely to be serious than those in dry road conditions. However, Table 2 shows that most of the increase in Fatal/Serious accidents since 2012 has actually taken place under dry road conditions. Further to this, Figure 3 shows that accidents in rural areas are more likely to be Fatal/Serious than those in urban areas, whilst Table 3 demonstrates that urban areas have experienced an increase in Fatal/Serious accidents since 2012, whilst rural areas have not.

Finally, in relation to the final research question ("To what extent can road conditions and rurality predict the severity of road accidents in the UK?"), the default MLR model was not effective as due to the imbalanced classes, resulting in 100% sensitivty and 0% specificity. Further models utilised over-sampling of the minority group and under-sampling of the majority group, both producing models that were ~53% accurate. As such, it was concluded that road accident severity could not be accurately predicted by road conditions and rurality using multinomial logistic regression.

Instructions for running the code:
1. To download the original datasets, navigate to: https://www.data.gov.uk/dataset/cb7ae6f0-4be6-4935-9277-47e5ce24a11f/road-safety-data
2. Press "show more", scroll down and download these datasets: "Road Safety Data - Casualties 1979 - Latest Published Year", "Road Safety Data - Collisions 1979 - Latest Published Year", and "Road Safety Data - Vehicles 1979 - Latest Published Year"
3. Download the R files from this repository and make sure they are part of the same project, and in the same folder as the downloaded datasets.
4. Run the code on the preprocessing file ("INF6027_preprocessing.R")
5. This code may take some time as the datasets are very large.
6. Once this code has been run, the code on the following file ("INF6027_tables_visualisations") can be run in stages specified by the comments within the code.
7. Finally, the code on the remaining file ("INF6027_multinomial_log_reg.R") can be run. Each model should be run individually to show the metrics for each in turn.
