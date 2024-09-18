## FitBit Users Physical Activity Analysis

### Introduction
The FitBit Fitness Tracker Data offers valuable insights into users' daily physical activities and habits by capturing detailed movement and calorie consumption patterns. This dataset includes time series data collected from FitBit users over a 30-day period, spanning from March 12, 2016, to May 16, 2016. It contains information on two key metrics: hourly step counts and calories burned.

The primary goal of this analysis is to explore how users engage with their fitness trackers and uncover behavioral trends in their daily activity. Specifically, the analysis aims to identify patterns such as variations in step counts during different times of the day (e.g., nighttime versus daytime activity) and cyclical calorie-burning patterns. Understanding these trends can offer insights into users' fitness behaviors, help in creating personalized fitness plans, and support the development of targeted interventions to improve physical health.

This analysis employs time series models to capture seasonality and trends in users' physical activity. By analyzing these patterns, we aim to provide a deeper understanding of the relationship between daily routines and physical output, such as step counts and calorie expenditure. The ultimate objective is to gain actionable insights that could contribute to enhancing user experience and promoting healthier lifestyles through personalized feedback based on activity patterns.



<br>

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



<br>

### Calories Analysis
1. Exploratory Data Analysis:
   The hourly calorie consumption data exhibits clear seasonality, with patterns repeating over a 24-hour period. The ACF (Autocorrelation Function) graph shows a strong correlation at 12 hours, while the differenced ACF confirms a 24-hour seasonality. The EACF plot also supports this, with clear seasonal behavior observed at lag 23. This led to the selection of SARIMA models for further analysis.


<img src='https://github.com/user-attachments/assets/a4614945-d7d7-43c4-8342-ade8cfbc4629' width='600px' height='400px'>
<br>
<img src='https://github.com/user-attachments/assets/2344b22b-7776-4815-9344-381832ce11df' width='400px' height='300px'>
<img src='https://github.com/user-attachments/assets/9ca16f58-c5d1-44c0-bdfa-effefe8467d2' width='400px' height='300px'>

2. Model Building and Residual Analysis:
   Three different models were initially built: Arima(2,0,2)(0,1,1), Arima(1,0,0)(2,1,0), and Arima(1,0,2)(0,1,1). After testing, Arima(1,0,0)(2,1,0) was chosen as the final model due to better performance. The ACF and PACF plots of the residuals showed that the values were not significantly different from zero, suggesting that the residuals were stationary. Additionally, the Ljung-Box test returned a p-value less than 0.05, allowing the rejection of the null hypothesis, and confirming that the residuals resembled white noise.



<br>

![image](https://github.com/user-attachments/assets/e4ca4ff1-b797-4ecb-b04c-35d0c700ccb2)

<img src='https://github.com/user-attachments/assets/3a6cd947-a726-433b-8c80-eb90865abba4' width='300px' height='100px'>
<img src='https://github.com/user-attachments/assets/e4ca4ff1-b797-4ecb-b04c-35d0c700ccb2' width='400px' height='350px'>
<img src='https://github.com/user-attachments/assets/488b5dbd-7ae9-44b8-bf9c-e57618f566cd' width='300px' height='100px'>



![image](https://github.com/user-attachments/assets/3a6cd947-a726-433b-8c80-eb90865abba4)

![image](https://github.com/user-attachments/assets/e4ca4ff1-b797-4ecb-b04c-35d0c700ccb2)

![image](https://github.com/user-attachments/assets/488b5dbd-7ae9-44b8-bf9c-e57618f566cd)



4. Forecasting and Backtesting:
   
The forecast from the chosen Arima model shows a cyclical pattern, with the highest peak values slightly lower than previous cycles, which is consistent with the natural fluctuation of the data. For backtesting, the model used 80% of the data as a training set. The RMSE (Root Mean Square Error) was 10.16, and the mean absolute percentage error (MAPE) was 7%, both of which indicate good model performance with low deviation in forecasted values.
<br>
![image](https://github.com/user-attachments/assets/a21aad9e-67eb-4dc6-8f4f-cd4f7a57cb15)

<img src='https://github.com/user-attachments/assets/a21aad9e-67eb-4dc6-8f4f-cd4f7a57cb15' width='400px' height='300px'>
<img src='https://github.com/user-attachments/assets/61f008a7-7a14-4d95-9db4-1ce9421397aa' width='400px' height='100px'>


6. GARCH Effect:
   
The analysis of the GARCH (Generalized Autoregressive Conditional Heteroskedasticity) effect revealed that the residuals’ Ljung-Box test led to the rejection of the null hypothesis, meaning the residuals showed some correlation. However, when examining the squared returns, the Ljung-Box test failed to reject the null hypothesis, indicating no significant correlation in squared residuals.

![image](https://github.com/user-attachments/assets/8ded14f2-5ef0-437d-9624-6ce9141ad327)


7. Conclusion:
   
The calorie consumption data shows clear seasonality with a repeating 24-hour pattern. The Arima(1,0,0)(2,1,0) model was chosen as the most suitable for forecasting due to its strong performance in residual analysis and backtesting. The model captured the cyclical nature of calorie consumption, though there was a slight drop in the highest peak values. The residuals were found to resemble white noise, and the Ljung-Box test confirmed that the model was adequate for forecasting. The GARCH effect analysis suggested some autocorrelation in residuals but no significant correlation in squared returns. Overall, the analysis provides a reliable model for predicting calorie consumption over short-term periods, though more complexity may be needed for long-term forecasting.



<br>

### Conclusion
Both the step count and calorie consumption analyses reveal strong seasonality in daily activity, with distinct 24-hour patterns. The ARIMA models successfully captured these patterns, although further complexity was necessary for more accurate and reliable long-term forecasts, as observed in both datasets. The residual analysis shows that the models used for both datasets were appropriate for short-term forecasting, as the residuals resembled white noise, and performance metrics such as RMSE and MAPE were low.

<br>

### Next Actions
1. Data Segmentation:
Analyze data by specific user groups (age, gender, fitness level) to uncover unique behavior patterns in physical activity and calorie consumption. This could lead to more personalized and precise models.

2. Incorporate More Features:
Use additional data such as weight, sleep patterns, or environmental factors (temperature, time of year) to improve the accuracy of the models and provide deeper insights into behavior.

3. Anomaly Detection:
Implement anomaly detection to flag unusual activity patterns, such as sudden increases or drops in calorie consumption or step counts, which may indicate changes in user habits or health conditions.




