library(ggplot2)
library(ggfortify)
library(forecast)
library(dplyr)
library(lubridate)
library(lmtest)
library(fGarch)
source('eacf.R')
source('backtest.R')

calories <- read.csv("C:/Users/isabe/Downloads/425 Final Project/hourlyCalories_merged.csv")
head(calories)
calories$ActivityHour = mdy_hms(calories$ActivityHour)

caloriesAg = calories %>% group_by(ActivityHour) %>% summarise(caloriesAvg = mean(Calories))

calHour = 24*(as.Date("2016-04-12 00:00:00") - as.Date("2016-01-01 00:00:00"))

tsCal = ts(caloriesAg$caloriesAvg, start = c(2016, calHour), frequency = 24)
autoplot(tsCal)
autoplot(decompose(tsCal))

plot(tsCal)
Acf(tsCal, lag = 50, main = "Hourly Calories")
pacf(tsCal, lag = 50)
eacf(tsCal, ma.max=24)

Acf(diff(tsCal), lag = 50, main = "Hourly Calories - Differenced")
pacf(diff(tsCal), lag = 50, main = "Hourly Calories - Differenced")
eacf(diff(tsCal), ma.max=24)

fit0 = auto.arima(tsCal, ic = c("aic"))
coeftest(fit0)
fitt = auto.arima(tsCal, trace = TRUE, ic = "aic")
# ARIMA(1,0,0)(2,1,0)[24] 
coeftest(fitt)
Acf(fitt$residuals, main = "ACF plot of Residuals")
pacf(fitt$residuals, main = "PACF plot of Residuals")
Box.test(fitt$residuals, type="Ljung", lag = 24)
Box.test(fitt$residuals, type="Ljung", lag = 48)
plot(forecast(fitb,h=36), include = 48)

fitb = auto.arima(tsCal, trace = TRUE, ic ='bic')
coeftest(fitb)

fit1 = Arima(tsCal, order = c(2,0,2), seasonal = c(0,1,1))
coeftest(fit1)


fit2 = Arima(tsCal, order=c(1,0,2), seasonal=c(2,1,0))
coeftest(fit2)
Acf(fit1$residuals)
Box.test(fit1$residuals, type="Ljung", lag = 24)
Box.test(fit1$residuals, type="Ljung", lag = 48)
plot(forecast(fit1,h=36), include = 48)

ntest = length(tsCal) * .8
backtest(fitb, tsCal, ntest, 1)

gitt = arima(tsCal, order = c(0,0,1))
gFit = garchFit( ~ arma(1, 0) + garch(1, 1), data=tsCal, trace=F)
summary(gFit)
predict(gFit, n.ahead=10, plot=T, nx=58)
