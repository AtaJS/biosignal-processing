%% PART1: Load ECG data into MATLAB. --------------------------------------
% The data is stored in files named 'ecg_signal_1.dat', and 'ecg_signal_2.dat'.
% Select the part from 2 s to 3 s from the first signal, and create sample 
% time vector in seconds for that interval. Similarly, the interval from 
% 1s to 2s from the second signal creating the sample time vector in seconds.
%--------------------------------------------------------------------------

% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load('ecg_signal_1.dat');

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load('ecg_signal_2.dat'); 

% Select the interval [2 s, 3s] samples from ECG 1
ecg1_interval = ecg1(2*FS:3*FS);

% Sample times for the interval 1
ecg1_interval_t =  [2:(1/FS):3];

% Select the interval [1 s, 2s] samples from ECG 2
ecg2_interval =  ecg2(1*FS:2*FS);

% Sample times for the interval 2
ecg2_interval_t = [1:(1/FS):2];


% Plotting:

figure

subplot(2,2,1)
plot( (0:length(ecg1)-1)/FS, ecg1 )
ylabel('ECG amplitude [a.u.]')
xlabel('Time [s]')
title('ECG 1')
xlim([0 length(ecg1)/FS])
ylim([-2 3])

subplot(2,2,3)
plot(ecg1_interval_t, ecg1_interval)
ylabel('ECG amplitude [a.u.]')
xlabel('Time [s]')
title('ECG 1 (one cycle)')
set(gca,'ylim',[-2 3])

subplot(2,2,2)
plot( (0:length(ecg2)-1)/FS, ecg2 )
ylabel('ECG amplitude [a.u.]')
xlabel('Time [s]')
title('ECG 2')
xlim([0 length(ecg2)/FS])
ylim([-2 3])

subplot(2,2,4)
plot(ecg2_interval_t, ecg2_interval)
ylabel('ECG amplitude [a.u.]')
xlabel('Time [s]')
title('ECG 2 (one cycle)')
set(gca,'ylim',[-2 3])
