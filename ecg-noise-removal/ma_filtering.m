%% Part3: Moving average filtering ----------------------------------------
% The general form of moving average (MA) filter is:
% y(n) = sum(b_k * x(n-k))    (1)
% Applying the z-transform, we get the transfer function H(z) of the filter as:
% H(z) = y(z)/X(z) = sum(b_k * z^(-k)) , b_k = 1/N   (2)
% Given the filter coefficient vectors a and b, you can use the 'filter' 
% function to apply the said filter to data in MATLAB.
% 
% My Note: For Moving Average filter:
% b = (1/M) *  ones(1,M)   , Where M is number of points
% a = 1
%
% Your task is to construct the 10-point moving average filter, i.e. to 
% specify the vectors a and b that are used with the 'filter' command 
% according to the eq. 1 and 2.
% The data is in the vectors called 'ecg1' and 'ecg2'. 
% NOTE: If you are testing your solution online before submitting it, you 
% must first load the data into the dependent variables first as in previous 
% problem(s). This is not required for submissions, as the system loads the 
% data for you.
% -------------------------------------------------------------------------

% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load('ecg_signal_1.dat');

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load('ecg_signal_2.dat');

% Create moving average filter coefficients a and b:
b = (1/10)*ones(1,10);
a = 1;
    
% Do the filtering using a, b, and ecg1
% For ecg1
ecg1_filtered = filter(b,a,ecg1);
% ...and ecg2
ecg2_filtered = filter(b,a,ecg2);

% Plotting:
figure

subplot(4,2,1)
plot( (0:length(ecg1)-1)/FS, ecg1 )
hold on
plot( (0:length(ecg1_filtered)-1)/FS, ecg1_filtered )
ylabel('Amplitude [a.u.]')
xlabel('Time [s]')
title('ECG 1')
xlim([0 length(ecg1)/FS])
ylim([-2 3])
legend('original','filtered');

subplot(4,2,2)
plot( (0:length(ecg2)-1)/FS, ecg2 )
hold on
plot( (0:length(ecg2_filtered)-1)/FS, ecg2_filtered )
ylabel('Amplitude [a.u.]')
xlabel('Time [s]')
title('ECG 2')
xlim([0 length(ecg2)/FS])
ylim([-2 3])
legend('original','filtered');

subplot(4,2,3)
plot( (0:length(ecg1)-1)/FS, ecg1 )
hold on
plot( (0:length(ecg1_filtered)-1)/FS, ecg1_filtered )
ylabel('Amplitude [a.u.]')
xlabel('Time [s]')
title('ECG 1')
xlim([2 3])
ylim([-2 3])
legend('original','filtered');

subplot(4,2,4)
plot( (0:length(ecg2)-1)/FS, ecg2 )
hold on
plot( (0:length(ecg2_filtered)-1)/FS, ecg2_filtered )
ylabel('Amplitude [a.u.]')
xlabel('Time [s]')
title('ECG 2')
xlim([1 2])
ylim([-2 3])
legend('original','filtered');

subplot(4,2,5)
periodogram(ecg1,[],[],FS)
title('Original PSD')
ylabel('Power [a.u.]')

subplot(4,2,6)
periodogram(ecg2,[],[],FS)
title('Original PSD')
ylabel('Power [a.u.]')

subplot(4,2,7)
periodogram(ecg1_filtered,[],[],FS)
title('Filtered PSD')
ylabel('Power [a.u.]')

subplot(4,2,8)
periodogram(ecg2_filtered,[],[],FS)
title('Filtered PSD')
ylabel('Power [a.u.]')

figure
freqz(b,a,[],FS); 
title('Frequency response of the MA filter');
