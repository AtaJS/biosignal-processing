%% Evaluate model performances --------------------------------------------
% Evaluate the adequacy of the predicted respiratory airflow signals with 
% two methods:
%   1. Compute correlation coefficients (formula below)
%   2. Compute RMSE values (formula below)
% Which model gives the best results?

% Correlation Coefficient
% To obtain a measure of fit, the correlation coefficient (r) can be 
% computed with the formula:
% !! Formula is in the file: 'Script3 Formulae.pdf'!!
%    
% where N is the number of samples of x or y, x represents the predicted 
% respiratory airflow signal and y represents the spirometer airflow signal. 
% Also,  is the mean of x and  is the mean of y. 
% 
% Root Mean Square Error (RMSE)
% The formula of mean squared error (MSE) is:
% !! Formula is in the file: 'Script3 Formulae.pdf'!!
%
% where SS_err/n is called the residual sum of squares. It is a measure of 
% the variability in y (spirometer signal) remaining after regressor x has 
% been considered. It's formula is
% !! Formula is in the file: 'Script3 Formulae.pdf'!!

% where f_i is the predicted respiratory airflow signal. 
% The root mean square error (RMSE) is a square root of MSE. It indicates 
% the absolute fit of the model to the data, how close the observed data 
% points are to the model's predicted values. 
%--------------------------------------------------------------------------

% Load the data from the file problem3.mat
load("problem3.mat");

% Nx1 vectors flow1, flow2, and flow3 contain the model predictions
% Nx1 vector spiro_resampled contains the resampled reference spirometer data

% Compute the correlation coefficient for the model 1, between flow1 and spiro_resampled
corr1 = sqrt((sum(flow1.*spiro_resampled) - length(flow1)*mean(flow1)*mean(spiro_resampled))^2/((sum(flow1.^2)-length(flow1)*mean(flow1)^2)*(sum(spiro_resampled.^2)-length(spiro_resampled)*mean(spiro_resampled)^2)));

% Compute the correlation coefficient for the model 2, between flow2 and spiro_resampled
corr2 = sqrt((sum(flow2.*spiro_resampled) - length(flow2)*mean(flow2)*mean(spiro_resampled))^2/((sum(flow2.^2)-length(flow2)*mean(flow2)^2)*(sum(spiro_resampled.^2)-length(spiro_resampled)*mean(spiro_resampled)^2)));

% Compute the correlation coefficient for the model 3, between flow3 and spiro_resampled
corr3 = sqrt((sum(flow3.*spiro_resampled) - length(flow3)*mean(flow3)*mean(spiro_resampled))^2/((sum(flow3.^2)-length(flow3)*mean(flow3)^2)*(sum(spiro_resampled.^2)-length(spiro_resampled)*mean(spiro_resampled)^2))); 

% Compute the RMSE for the model 1, between flow1 and spiro_resampled
rmse1 = sqrt(sum((spiro_resampled-flow1).^2)/length(flow1)) ;

% Compute the RMSE for the model 2, between flow2 and spiro_resampled
rmse2 = sqrt(sum((spiro_resampled-flow2).^2)/length(flow2)) ;

% Compute the RMSE for the model 3, between flow3 and spiro_resampled
rmse3 = sqrt(sum((spiro_resampled-flow3).^2)/length(flow3)) ;