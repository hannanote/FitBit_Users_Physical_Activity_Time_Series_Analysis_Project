library(tseries)
library(fBasics)
library(zoo)
library(ggplot2)
library(ggfortify)
library(lubridate)
library(TSA)
library(forecast)

library(lmtest)
library(fUnitRoots)
library(tseries)
library(fpp2)


weight = read.csv("C:/Users/choin/Downloads/Hannanote/FitBit_Users_Activity/weightLogInfo_merged.csv")
head(weight)
tail(weight)
class(Date1)

#convert date to proper 
weight$date = as.Date(weight$Date, format = "%m/%d/%Y")
head(weight$date)

#create time series 
head(weight)
head(WeightPounds)
weight$WeightPounds=weight$WeightPounds
head(weight$WeightPounds)


summary(Weightlbsts)

Weightlbsts=ts(weight$WeightPounds, weight$date, frequency = 31)
autoplot(Weightlbsts)

autoplot(diff(Weightlbsts))

lag.plot(Weightlbsts, do.lines=F)
qplot(weight$date, weight$WeightPounds, geom="line") #the date looks bad here

#box Test 
Box.test(Weightlbsts, type = "Ljung-Box")
Box.test(diff(Weightlbsts, type = "Ljung-Box")) #this is closer to 0, use the diff 

#ttest 
t.test(Weightlbsts, conf.level = .95)
t.test(diff(Weightlbsts, conf.level = .95)) #CI in between 0 here
#mean not equal to 0

plot(decompose(Weightlbsts))
plot(decompose(diff(Weightlbsts)))


Box.test(diff(Weightlbsts), type="Ljung") #box test says p value is close to 0
Box.test(Weightlbsts, type="Ljung")

adfTest(diff(Weightlbsts)) 
kpss.test(diff(Weightlbsts)) 


#is this normal 
jarque.bera.test(Weightlbsts)
jarque.bera.test(diff(Weightlbsts))
# check for normality, the p is less than 0.05



kurtosis(Weightlbsts)
mean(Weightlbsts)
sd(Weightlbsts)

#log
kurtosis(diff(Weightlbsts))
mean(diff(Weightlbsts))
sd(diff(Weightlbsts))


#regular & diff 
Acf(Weightlbsts)
Acf(diff(Weightlbsts))

pacf(Weightlbsts)
pacf(diff(Weightlbsts))

eacf(Weightlbsts)
eacf(diff(Weightlbsts))

#Fit 1
#use the log fit one model here 

fitweight1 = Arima(Weightlbsts,order=c(1, 0, 1))
fitweight1
coeftest(fitweight1)


adf.test(fitweight1$residuals)
kpss.test(fitweight1$residuals)

Box.test(fitweight1$residuals, type="Ljung")

Box.test(fitweight1$residuals, type="Ljung")

fitWeight1BIC = Arima(Weightlbsts,order=c(1, 0, 1),ic="bic")


#Fit 2 

fitweight2 = Arima(Weightlbsts,order=c(1, 0, 0))
fitweight2
coeftest(fitweight2)

adf.test(fitweight2$residuals)
kpss.test(fitweight2$residuals)



#FIT 3 Regular 

fitweight3 = Arima(Weightlbsts,order=c(2, 0, 1))
fitweight3
coeftest(fitweight3)

adf.test(fitweight3$residuals)
kpss.test(fitweight3$residuals)


Box.test(fitweight3$residuals, type="Ljung")

#FIT 4
fitweight4 = Arima(Weightlbsts,order=c(2, 1, 1))
fitweight4
coeftest(fitweight4)

adf.test(fitweight4$residuals)
kpss.test(fitweight4$residuals)

Box.test(fitweight4$residuals, type="Ljung")


#FIT 5 

fitweight5 = Arima(Weightlbsts,order=c(1, 1, 0))
fitweight5
coeftest(fitweight5)

adf.test(fitweight5$residuals)
kpss.test(fitweight5$residuals)



#auto arima 
AutoWeight = auto.arima(Weightlbsts)
coeftest(AutoWeight)

adf.test(AutoWeight$residuals)
kpss.test(AutoWeight$residuals)

Box.test(AutoWeight$residuals, type="Ljung")


fitAutoWeightBIC = auto.arima(Weightlbsts, ic="bic")
coeftest(fitAutoWeightBIC)
Box.test(fitAutoWeightBIC$residuals, type="Ljung")

#forecast 

fit1forecast = forecast(fitweight1, h=20)
autoplot(fit1forecast)
acf(fit1forecast)

Acf(Weightlbsts, lag.max = 20)
pacf(Weightlbsts, lag.max = 20)
eacf(Weightlbsts)


#residual analysis 
Box.test(fitweight1$residuals, lag=20, type='Ljung')  # Still a significant amount of autocorrelation
autoplot(ts(fitweight1$residuals))                   # So, we're not capturing everything
acf(fitweight1$residuals, na.action= na.pass)



#backtesting 
backtest(fitweight1, Weightlbsts, orig-k, h=1)


source("backtest.R")
back1 = Arima(Weightlbsts, order=c(1,0,1))

back2 = Arima(Weightlbsts, order=c(3,0,0))
pm1 = backtest(back1, Weightlbsts, 20, 1)
pm2 = backtest(back2, Weightlbsts, 20, 1)
