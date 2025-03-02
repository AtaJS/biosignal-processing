%% Part5: Comb filtering --------------------------------------------------
% As noted in the moving average filtering problem, the general form of a 
% MA filter is
% y(n) = sum(b_k * x(n-k))   (1)
% In this problem, we are using a comb filter that has the coefficients 
% b = [0.6310 -0.2149 0.1512 -0.1288 0.1227 -0.1288 0.1512 -0.2149 0.6310] 
% and a = 1.
% 
% Task
% Construct the comb filter to remove 60Hz power line interference, and use 
% it to filter the data. The data is in the vectors called 'ecg1' and 'ecg2'. 
% -------------------------------------------------------------------------

% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load('ecg_signal_1.dat');

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load('ecg_signal_2.dat');

% Create comb filter coefficients a and b:
b = [0.6310 -0.2149 0.1512 -0.1288 0.1227 -0.1288 0.1512 -0.2149 0.6310] ;
a = 1 ;
    
% Do the filtering using a, b, and ecg1
% For ecg1
ecg1_filtered = filter(b,a, ecg1);
% ...and ecg2
ecg2_filtered = filter(b,a, ecg2);

% Plotting
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

