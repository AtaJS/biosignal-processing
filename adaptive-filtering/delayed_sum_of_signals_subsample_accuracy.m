%% PART3: Delayed sum of signals - subsample accuracy ---------------------
% Task
% Load data from 'problem3.mat' file, and use the variables 'abd_sig1' and 
% 'mhb_ahead'. The former vector contains an artificial mixture of maternal 
% and fetal ECGs summed together in the abdomen measurement. The latter 
% vector contains only the maternal ECG as measured from the chest.
% First, fix the time delay by shiftng the maternal ECG in the 'mhb_ahead' 
% vector accordingly storing the value in the vector 'mhb'. Padd the missing 
% samples with the linear extrapolation value.
% Note that to handle the non-integer delay, we interpolate the output of the 
c% ross correlation computed from sampled signals into a continuous curve 
% using splines, and then find the non-integer lag giving the highest 
% correlation from this continuous curve using function minimization. Also, 
% consider limiting the range of cross-correlation lags you compute and use 
% for the spline fitting to get nice fit for the spline and to be able to 
% find the correct local minimum (hint: plot the cross-correlation to see why).
% Note
% Please consult the MATLAB help on spline and fnmin.
% -------------------------------------------------------------------------

% Load problem3.mat to have access to variables abd_sig1 and mhb_ahead

load('problem3.mat')
% The sampling rates are 1000 Hz
FS = 1000;

% Calculate sample timing vector in seconds starting from 0
t = [0:1:length(abd_sig1)-1].*(1/FS);

% Estimate the time lag using cross correlation with the 'xcorr' function
% Fit a spline to the cross correlation using 'spline' function, and then find the delay with maximum correlation using 'fnmin'
% NOTE: to use minimization function for maximization, please invert the objective function!
[r, lags] = xcorr(abd_sig1, mhb_ahead);
p = spline(lags, -r) ;
[val, index] = fnmin(p); 
d = index ;

% Shift the chest ECG mhb_ahead back in time d samples
% Use linear interpolation with extrapolation with the function 'interp1'
mhb = interp1((1:length(mhb_ahead)), mhb_ahead, 1-d:length(mhb_ahead)-d,  'linear', 'extrap')';

% Estimate c2 from abd_sig1 and mhb
c2 = mhb \ abd_sig1;

% Calculate the fetal ECG by cancelling out the scaled mother's ECG using projection based estimation coefficient
fetus = abd_sig1 - c2*mhb;


% Plotting
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
