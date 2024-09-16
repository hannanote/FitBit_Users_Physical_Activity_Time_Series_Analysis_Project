## FitBit Users Physical Activity Analysis
FitBit Fitness Tracker Data contains personal fitness trackers from FitBit users. 
The goal is to provide an analysis how users are using the FitBit.

This analysis uses time sereis data from FitBit users, focusing on their hourly step, hourly calories, and weight data to identify patterns of physical behavior such as steps take at night versus the day, and calorie burning patterns. 

The data: steps, calories burned, weight
- movement behavior over 30 days from Mar 2016 - May 2016

### Weight Analysis

![image](https://github.com/user-attachments/assets/c83446a1-3eca-4b07-a922-0bfa45db3c35)

![image](https://github.com/user-attachments/assets/b2f2a7ef-f201-425c-b59f-78222fa6aee7)


### Calories Analysis
- This data is calories consumed each hour of day.
- very strong seasonality
- Daily patterns about calories consumed. 
Next step
- There is not engough data. It is difficult to check trends or seasonality more deeply.

![image](https://github.com/user-attachments/assets/a4614945-d7d7-43c4-8342-ade8cfbc4629)
<img src='https://github.com/user-attachments/assets/a4614945-d7d7-43c4-8342-ade8cfbc4629' width='600px' height='500px'>

<img src='https://github.com/user-attachments/assets/2344b22b-7776-4815-9344-381832ce11df' width='400px' height='300px'>
<img src='https://github.com/user-attachments/assets/9ca16f58-c5d1-44c0-bdfa-effefe8467d2' width='400px' height='300px'>


### Steps Analysis
1. Seasonality & Trends:
   - The hourly step data displays clear 24-hour seasonality, which aligns with people's natural activity patterns. There is also a potential secondary seasonality (12hours) indicated by the autocorrelation function (ACF).
   - The trend could be further smoothed to capture long-term patterns more clearly.

![image](https://github.com/user-attachments/assets/5cd0dcac-3458-43b6-b778-ec27472dc31a)

<img src='https://github.com/user-attachments/assets/9f245d8d-def6-4c5a-a992-fe4cd2dde7e8' width='400px' height='300px'>
<img src='https://github.com/user-attachments/assets/08c343f2-a70d-41f3-9218-04a9d0e49526' width='400px' height='300px'>

2. Model Development:
   - Various SARIMA models were tested, including models like ARIMA(2,0,2)(1,1,1) and ARIMA(1,0,0)(0,1,1). While some models like (2,0,2)(1,1,1) could not confirm coefficient significance, simpler models like (1,0,0)(0,1,1) performed well without autocorrelation issues in the residuals.
   - The AIC and BIC criteria were used to choose models, and surprisingly, the BIC model had higher AIC and BIC values compared to simpler models. The auto ARIMA model created with the BIC criterion also had significant parameters, but performed poorly compared to manual models.

![image](https://github.com/user-attachments/assets/c09eaa65-d29d-46e1-8bba-8b1cea22006f)
  
3. Residual Analysis:
   - For the model ARIMA(1,0,0)(0,1,1), the residuals showed no significant autocorrelation, passing the Box-Ljung test, which indicated that it was a good fit.
   - In contrast, the BIC model, while simpler, showed significant autocorrelation issues at lag 48, limiting its forecasting power beyond 48 hours.

4. Harmonic Regression:
   - Harmonic regression was attempted to capture the seasonality, but it performed worse than SARIMA models, especially due to the lack of significant parameters.

5. Backtesting & Forecasting:
   - Backtesting revealed that the ARIMA(1,0,0)(0,1,1) model performed better than the BIC model in terms of forecasting accuracy.
   - A transformation of the data (logarithmic transformation) improved the model's performance further, reducing the Mean Absolute Percentage Error (MAPE) to 13%, though at the cost of increased model complexity (six parameters vs two or three in simpler models).
   - Forecasts indicated that the logged series model best captured the step data's cyclical behavior, but with lower peak values in the forecast compared to historical data.
  
![image](https://github.com/user-attachments/assets/29e411d6-9f19-4282-9e17-af9478452566)

![image](https://github.com/user-attachments/assets/406ab691-5ff2-4377-9616-49f0fc914db1)
  
6. Conclusion:
   - SARIMA modeling of the steps data proved to be effective in capturing both the 24-hour seasonality and underlying trends.
   - The simplest model ARIMA(1,0,0)(0,1,1) provided a balance between simplicity and performance. For more precise forecasting, using the log transformation with a more complex model provided improved accuracy.




