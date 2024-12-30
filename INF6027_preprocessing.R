# RQ 1: How has the prevalence of severe road accidents changed from 2012 to 2023?
# RQ 2: How does the prevalence of severe road accidents differ between road characteristics?
# RQ 3: Can road characteristics predict road accident severity in the UK?


install.packages("ggplot2")
install.packages("ggthemes")
install.packages("scales")
install.packages("tidyverse")
install.packages("MASS")
install.packages("rgl")
install.packages("caret")
install.packages("MLmetrics")

library(ggplot2)
library(ggthemes)
library(scales)
library(tidyverse)
library(MASS)
library(rgl)
library(caret)
library(nnet)
# STATS19 accident report form for reference:
# https://assets.publishing.service.gov.uk/media/60d0cc548fa8f57ce4615110/stats19.pdf

# importing the original datasets from https://www.data.gov.uk/dataset/cb7ae6f0-4be6-4935-9277-47e5ce24a11f/road-safety-data
road_data_casualty <- read.csv("dft-road-casualty-statistics-casualty-1979-latest-published-year.csv")
road_data_collision <- read.csv("dft-road-casualty-statistics-collision-1979-latest-published-year.csv")
road_data_vehicle <- read.csv("dft-road-casualty-statistics-vehicle-1979-latest-published-year.csv")

#joining the three sets into a single dataframe
df_complete <- road_data_collision %>% 
  dplyr::left_join(road_data_vehicle, by = "accident_index") %>%
  dplyr::left_join(road_data_casualty, by = "accident_index")


# creating a subset with only the relevant columns
df_subset <- subset(df_complete, select = c(accident_index,
                                            accident_severity,
                                            road_surface_conditions,
                                            urban_or_rural_area
                                             
))

#Taking subset for 2012-2023
df_sub_2012 <- df_subset[df_subset$accident_year.x %in% 2012:2023, ]



# recoding the variables to correspond with their labels on the STATS-19 form
df_recoded <- df_sub_2012 %>% 
  mutate(accident_severity = recode(accident_severity,
                                    '1' = "Fatal",
                                    '2' = "Serious",
                                    '3' = "Slight"),
         road_surface_conditions = recode(road_surface_conditions,
                                          '1' = "Dry",
                                          '2' = "Wet",
                                          '3' = "Snow",
                                          '4' = "Frost/Ice",
                                          '5' = "Flood"),
         urban_or_rural_area = recode(urban_or_rural_area,
                                      '1' = "Urban",
                                      '2' = "Rural"))

#grouping serious and fatal, consistent with literature:
df_recoded <- df_recoded %>%
  mutate(severity_combined = ifelse(accident_severity %in%
                                      c("Serious", "Fatal"),
                                    "Fatal/Serious", "Slight"))


# saving the subset for easier access
write.csv(df_recoded, "df_recoded.csv", row.names=FALSE)


### import each session:
df_recoded <- read.csv("df_recoded.csv")
