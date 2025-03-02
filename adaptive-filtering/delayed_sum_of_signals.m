%% PART2: Delayed sum of signals ------------------------------------------
% Task
% Load data from 'problem2.mat' file, and use the variables 'abd_sig1' and 
% 'mhb_ahead'. The former vector contains an artificial mixture of maternal 
% and fetal ECGs summed together in the abdomen measurement. The latter 
% vector contains only the maternal ECG as measured from the chest.
% First, fix the time delay by shifting the maternal ECG in the 'mhb_ahead' 
% vector accordingly storing the value in the vector 'mhb'. Padd the missing 
% samples with the nearest existing value.
% Then, as in the previous task, calculate the fetal ECG by cancelling out 
% the mother's ECG.
%
% Note
% Padding with the nearest value means that you need to use the first or 
% last value of the signal to replace the empty samples that appear depenging 
% on the direction of the time shifting.
% -------------------------------------------------------------------------

% Load problem2.mat to have access to variables abd_sig1 and mhb_ahead

load('problem2.mat')
% The sampling rates are 1000 Hz
FS = 1000;

% Calculate sample timing vector in seconds starting from 0
t = [0:1:length(abd_sig1)-1].*(1/FS);

% Estimate the time lag using cross correlation
% (Calculate cross correlation using the xcorr function and then
% use the max function to find the lag giving maximal correlation)
[r, lags] = xcorr(abd_sig1, mhb_ahead);
[dummy,index] = max(r) ;
d = lags(index) ;
% --- My NOTE: d is in samples not in seconds! ---

% Shift the chest ECG mhb_ahead back in time d samples padding with nearest value
mhb = cat(1, mhb_ahead(1)*ones(d, 1), mhb_ahead(1:end-d));

% Estimate c2 from abd_sig1 and mhb
c2 = mhb \ abd_sig1;

% Calculate the fetal ECG by cancelling out the scaled mother's ECG using
% projection based estimation coefficient 
fetus = abd_sig1 - c2*mhb;


% Plotting:
figure

subplot(311)
plot( t, abd_sig1, 'b' )
hold on
plot( t, mhb, 'r--' )
legend('abd\_sig1 (x = x_1 + c_2 x_2)','mhb (y = x_2)')
xlabel('t [s]')
ylabel('amplitude [a.u.]')
ylim([-2 4]);

subplot(312)
plot( t, c2 * mhb )
legend('scaled mhb (c_2 x_2)')
xlabel('t [s]')
ylabel('amplitude [a.u.]')
ylim([-2 4]);

subplot(313)
plot( t, fetus, 'b' )
hold on
plot( t, fhb, 'r--' )
legend('fetus (x - y = x - c_2 x_2)', 'true fetus')
xlabel('t [s]')
ylabel('amplitude [a.u.]')
ylim([-2 4]);

