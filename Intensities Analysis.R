library("dplyr")
library(stringr)
library(ggplot2)   # For qplot
library(fBasics)
library(lubridate) # for mdy date conversion
library(ggfortify) # for ts autoplot
library(zoo)

intensity <- hourlyIntensities_merged
typeof(intensity$ActivityHour)

#intensity1 <- intensity
intensity$ActivityHour <- substring(intensity$ActivityHour,1,9)
intensity$ActivityHour =  as.Date(intensity$ActivityHour, "%m/%d/%Y")

########## by id ##########

by_id <- intensity %>% filter(str_detect(Id, "1503960366"))
by_id1 <- by_id %>% group_by(ActivityHour)  %>%
  summarise(Id = mean(Id),
            sum_TotalIntensity = sum(TotalIntensity),
            avg_AverageIntensity = mean(AverageIntensity),
            .groups = 'drop')
by_id1_zoo = zoo(by_id1$avg_AverageIntensity, by_id1$ActivityHour)

autoplot(by_id1_zoo,xlab = "Date",ylab = "Total Intensity", main = "Average intensity for ID 1503969366 daily")
acf(by_id1_zoo, main = "ACF plot")
pacf(by_id1_zoo, main = "PACF plot")

########## by date ##########

by_date <- intensity %>% group_by(ActivityHour)  %>%
  summarise(sum_TotalIntensity = sum(TotalIntensity),
  avg_AverageIntensity = mean(AverageIntensity),
  .groups = 'drop')
by_date_zoo = zoo(by_date$avg_AverageIntensity, by_date$ActivityHour)

autoplot(by_date_zoo,xlab = "Date", ylab = "Total Intensity", main = "Average intensity for everybody(sum) daily")
acf(by_date_zoo,main = "ACF plot")
pacf(by_date_zoo,main = "PACF plot")
