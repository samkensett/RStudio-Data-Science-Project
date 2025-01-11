# tables and visualizations

# these dataframes required for table 1 and figure 1:
accidents_by_severity_comb_year <- df_recoded %>% 
  group_by(severity_combined, accident_year.x) %>% 
  summarise(accident_count = n(), .groups="drop")%>%
  filter(accident_year.x %in% c(2012, 2023))

percentage_change_severity <- accidents_by_severity_comb_year %>%
  pivot_wider(names_from = accident_year.x, values_from = accident_count, names_prefix="year_") %>%
  mutate(count_change = (year_2023 - year_2012)
  ) %>%
  mutate(
    percentage_change_severity = ((year_2023 - year_2012) / year_2012) * 100
  )

# run this line for Table 1:
view(percentage_change_severity)

# Figure 1:
severity_perc_change <- ggplot(percentage_change_severity, aes(x = severity_combined, y = percentage_change_severity, fill = severity_combined)) +
  geom_bar(stat = "identity", width = 0.7) +
  labs(
    title = "Percentage Change in UK Road Accidents (2012 vs 2023)",
    x = "Accident Severity",
    y = "Percentage Change",
    caption="GOV.UK Road Safety Data"
  ) +
  geom_hline(yintercept=0, colour="black", size=0.5)+
  scale_fill_manual(values=c("#D55E00", "#F0E442",
                             "#D55E00", "#F0E442"))+
  scale_y_continuous(labels = scales::percent_format(scale = 1),
                     limits=c(-50, 50),
                     breaks=seq(-50, 50, 10)) +
  theme_clean()+
  theme(legend.position = "none",
        plot.title = element_text(face = "bold", hjust=0.5),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"))

severity_perc_change

ggsave("severity_perc_change.png", plot = severity_perc_change2, width=8, height=4.8, dpi = 300)




# percentage serious by road conditions
# these dataframes required for table 2 and figure 2: 
accidents_by_conditions_year <- df_recoded %>% 
  group_by(road_surface_conditions, accident_year.x, severity_combined) %>% 
  filter(accident_year.x %in% c(2012, 2023), severity_combined == "Severe",
         !is.na(road_surface_conditions))%>%
  summarise(accident_count = n(), .groups="drop")

percentage_change_conditions <- accidents_by_conditions_year %>%
  pivot_wider(names_from = accident_year.x, values_from = accident_count, names_prefix="year_") %>%
  mutate(
    percentage_change_conditions = ((year_2023 - year_2012) / year_2012) * 100
  ) 

# run this line for Table 2:
view(percentage_change_conditions)

# Figure 2:
severity_by_road <- df_recoded %>%
  filter(accident_year.x == 2023) %>% 
  group_by(road_surface_conditions, severity_combined) %>%
  summarise(accident_count = n(), .groups = "drop")

percentage_serious_by_condition <- severity_by_road %>%
  pivot_wider(names_from = severity_combined, values_from = accident_count, values_fill = 0) %>%
  mutate(
    percentage_serious = (`Severe` / (`Severe` + Slight)) * 100
  ) 

percentage_serious_by_condition <- 
  percentage_serious_by_condition[!is.na(percentage_serious_by_condition$road_surface_conditions),]

percentage_serious_by_condition <- percentage_serious_by_condition %>%
  mutate(road_surface_conditions = fct_reorder(road_surface_conditions, desc(percentage_serious)))

perc_serious_by_con <- ggplot(percentage_serious_by_condition,
       aes(x=road_surface_conditions,
           y=percentage_serious))+
  geom_bar(stat = "identity", width = 0.7, fill="#D55E00") +
  labs(
    title = "Percentage of Accidents that are Severe by Road Condition",
    x = "Road Condition",
    y = "Percentage Severe",
    caption="GOV.UK Road Safety Data"
  ) +
  geom_hline(yintercept=0, colour="black", size=0.5)+
  scale_y_continuous(labels = scales::percent_format(scale = 1),
                     limits=c(0, 50),
                     breaks=seq(0, 50, 10), 
                     expand = c(0, 0))+
  theme_clean()+
  theme(legend.position = "none",
        plot.title = element_text(face = "bold", hjust=0.5, size =13),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"))


perc_serious_by_con

ggsave("perc_serious_by_con.png", plot = perc_serious_by_con, width=8, height=4.8, dpi = 300)



#percentage serious rural urban
# dataframes required for table 3 and figure 3:
accidents_by_rurality_year <- df_recoded %>% 
  group_by(urban_or_rural_area, accident_year.x, severity_combined) %>% 
  filter(accident_year.x %in% c(2012, 2023), severity_combined == "Severe",
         !is.na(urban_or_rural_area))%>%
  summarise(accident_count = n(), .groups="drop")


percentage_change_rurality <- accidents_by_rurality_year %>%
  pivot_wider(names_from = accident_year.x, values_from = accident_count, names_prefix="year_") %>%
  mutate(
    percentage_change_conditions = ((year_2023 - year_2012) / year_2012) * 100
  ) 

# run this for table 3:
view(percentage_change_rurality)

# Figure 3:
severity_by_area <- df_recoded %>%
  filter(accident_year.x == 2023) %>% 
  group_by(urban_or_rural_area, severity_combined) %>%
  summarise(accident_count = n(), .groups = "drop")

percentage_serious_by_area <- severity_by_area %>%
  pivot_wider(names_from = severity_combined, values_from = accident_count, values_fill = 0) %>%
  mutate(
    percentage_serious = (`Severe` / (`Severe` + Slight)) * 100
  ) 

percentage_serious_by_area <- 
  percentage_serious_by_area[!is.na(percentage_serious_by_area$urban_or_rural_area),]


percentage_serious_by_area <- percentage_serious_by_area %>%
  mutate(urban_or_rural_area = fct_reorder(urban_or_rural_area, desc(percentage_serious)))


bar_rurality <- ggplot(percentage_serious_by_area,
       aes(x=urban_or_rural_area,
           y=percentage_serious,
           fill=urban_or_rural_area))+
  geom_bar(stat = "identity", width = 0.7) +
  labs(
    title = "Percentage of Accidents that are Severe by Rurality",
    x = "Rurality",
    y = "Percentage Severe",
    caption="GOV.UK Road Safety Data"
  ) +
  geom_hline(yintercept = 0, colour = "black", size = 0.5) +
  scale_y_continuous(labels = scales::percent_format(scale = 1),
                     limits=c(0, 50),
                     breaks=seq(0, 50, 10),
                     expand = c(0, 0))+
  scale_fill_manual(values = c("Rural"="#009E73", "Urban"="#CC79A7"))+
  theme_clean()+
  theme(legend.position = "none",
        plot.title = element_text(face = "bold", hjust=0.5),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"))

bar_rurality

ggsave("bar_rurality.png", plot = bar_rurality, width=8, height=4.8, dpi = 300)




