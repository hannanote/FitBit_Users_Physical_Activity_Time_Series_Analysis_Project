library(ggplot2)
library(ggfortify)
library(forecast)
library(dplyr)
library(lubridate)
library(lmtest)
source('eacf.R')
source('backtest.R')


steps <- read.csv("C:/Users/choin/Downloads/hannanote/FitBit_Users_Activity/hourlySteps_merged.csv")
head(steps)
steps$ActivityHour = mdy_hms(steps$ActivityHour)

steps_agg = steps %>% group_by(ActivityHour) %>% summarise(StepAvg = mean(StepTotal))

firstHour = 24*(as.Date("2016-04-12 00:00:00") - as.Date("2016-01-01 00:00:00"))

#data is number of steps taken each hour so not necessarily additive series; definitely not multiplicative
ts_steps = ts(steps_agg$StepAvg, start = c(2016, firstHour), frequency = 24)
autoplot(ts_steps)
autoplot(decompose(ts_steps))

Acf(ts_steps, lag = 50)
pacf(ts_steps, lag = 50)
eacf(ts_steps, ma.max=30)

Acf(diff(ts_steps), lag = 50)
pacf(diff(ts_steps), lag = 50)
eacf(diff(ts_steps), ma.max=30)

fit1 = Arima(ts_steps, order = c(2,0,2), seasonal = c(0,1,1))
coeftest(fit1)


fit2 = Arima(ts_steps, order=c(1,0,1), seasonal=c(0,1,1))
coeftest(fit2)
Acf(fit2$residuals)
Box.test(fit2$residuals, type="Ljung", lag = 24)
Box.test(fit2$residuals, type="Ljung", lag = 48)
plot(forecast(fit2,h=36), include = 48)

#Best model maybe
fit3 = Arima(ts_steps, order=c(1,0,0), seasonal=c(0,1,1))
coeftest(fit3)
Acf(fit3$residuals)
Box.test(fit3$residuals, type="Ljung", lag = 24)
Box.test(fit3$residuals, type="Ljung", lag = 48)
plot(forecast(fit3,h=36), include = 48)


aicFit = auto.arima(ts_steps, ic = "aic")
coeftest(aicFit)
Acf(aicFit$residuals)
Box.test(aicFit$residuals, type="Ljung", lag=24)
Box.test(bicFit$residuals, type="Ljung", lag=48)
plot(forecast(aicFit,h=36), include = 48)


bicFit = auto.arima(ts_steps, ic="bic")
coeftest(bicFit)
Acf(bicFit$residuals)
Box.test(bicFit$residuals, type="Ljung", lag=24)
Box.test(bicFit$residuals, type="Ljung", lag=48)
plot(forecast(bicFit,h=36), include = 48)


k = as.integer(.95*length(ts_steps))
backtest(fit2, ts_steps, orig=k, h=1)
backtest(aicFit, ts_steps, orig=k, h=1)
backtest(bicFit, ts_steps, orig=k, h=1)


#try aggregating over a day and see if there's a weekly pattern
