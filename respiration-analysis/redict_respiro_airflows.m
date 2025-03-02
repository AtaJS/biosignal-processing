%% Predict respiratory airflows -------------------------------------------
% Predict the respiratory airflows using the following three models:
% F_est1 = beta1 * s_ch + beta2 * s_ab
% F_est2 = beta1 * s_ch + beta2 * s_ab + beta3 * s_ch^2 + beta4 * s_ab^2
% F_est3 = beta1 * s_ch + beta2 * s_ab + beta3 * s_ch * s_ab
%
% where s_ch is the chest belt signal, s_ab is the abdomen belt signal, and
% betas are the model coefficients. The models have been trained already, 
% and you are given the coefficients representing them.
% Hint: make Google search "element-wise multiplication"
% The belt data is a Nx2 matrix called 'belt', the resampled spirometer 
% data is a Nx1 vector, and the coefficients for the models 1-3 are in the 
% vectors 'coeff1', 'coeff2', and 'coeff3', respectively.
% -------------------------------------------------------------------------

% Load the belt data into Nx2 matrix from the file beltsignals.txt
belt = load("beltsignals.txt");

% Load the resampled spirometer data into Nx1 vector from the file spiro_resampled.mat
spiro_resampled = load("spiro_resampled.mat");

% Load the regression coefficients vector for the model 1 from the file regressioncoefficients1.txt
coeff1 = load("regressioncoefficients1.txt");

% Load the regression coefficients vector for the model 2 from the file regressioncoefficients2.txt
coeff2 = load("regressioncoefficients2.txt");

% Load the regression coefficients vector for the model 3 from the file regressioncoefficients3.txt
coeff3 = load("regressioncoefficients3.txt");

% Predict the airflow using the model 1, that is with coeff1
flow1 = coeff1(1)*belt(:,1) + coeff1(2)*belt(:,2);

% Predict the airflow using t   he model 2, that is with coeff2
flow2 = coeff2(1)*belt(:,1) + coeff2(2)*belt(:,2) + coeff2(3)*belt(:,1).^2 + coeff2(4)*belt(:,2).^2;

% Predict the airflow using the model 3,  that is with coeff3
flow3 = coeff3(1)*belt(:,1) + coeff3(2)*belt(:,2) + coeff3(3)*belt(:,1).*belt(:,2);