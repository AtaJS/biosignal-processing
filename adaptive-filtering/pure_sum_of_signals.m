%% PART1: Pure sum of signals ---------------------------------------------
% Complete descriptions and formulae are in the file: 
% "Assignment3_Implement.pdf"
% Load data from 'problem1.mat' file, and use the variables 'abd_sig1' and 
% 'mhb'. The former vector contains an artificial mixture of maternal and 
% fetal ECGs summed together in the abdomen measurement. The latter vector 
% contains only the maternal ECG as measured from the chest.
% Implement the scalar projection formula (4) to calculate the mixing 
% coefficient  directly. Then use the 'pinv' function in MATLAB as an 
% alternative way to calculate the coefficient. Finally, also use the 
% backslash operator (\) to solve (6).
% -------------------------------------------------------------------------

% Load problem1.mat to have access to variables abd_sig1 and mhb
load("problem1.mat")
% The sampling rates are 1000 Hz
FS = 1000;

% Calculate sample timing vector in seconds starting from 0
t = [0:1:length(abd_sig1)-1].*(1/FS);

% Estimate c2 from abd_sig1 and mhb using the scalar projection formula (4)
c2_projection = (abd_sig1'*mhb)/(mhb'*mhb) ;

% Estimate c2 from abd_sig1 and mhb using the pseudoinverse function (pinv)
c2_pinv = pinv(mhb) * abd_sig1 ;

% Estimate c2 from abd_sig1 and mhb using the backslash operator (\)
c2_operator = mhb \ abd_sig1;

% Calculate the fetal ECG by cancelling out the scaled mother's ECG using
% projection based estimation coefficient, Formula (5)
fetus = abd_sig1 - c2_operator*mhb ; 



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
plot( t, c2_projection * mhb, 'b'  )
legend('scaled mhb (c_2 x_2)')
xlabel('t [s]')
ylabel('amplitude [a.u.]')
ylim([-2 4]);

subplot(313)
plot( t, fetus, 'b' )
hold on
plot( t, fhb, 'r--' );
legend('estimated fetus (x - y = x - c_2 x_2)', 'true fetus')
xlabel('t [s]')
ylabel('amplitude [a.u.]')
ylim([-2 4]);
