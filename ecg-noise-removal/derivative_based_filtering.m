%% Part4: Derivative based filtering --------------------------------------
% A derivative based filter has the following transfer function:
% H(z) = Y(z)/X(z) = (1/T) * ((1 - z^-1)/(1 - 0.995*z^-1))    (3).
% Where: T = 1/FS
%
% Task: 
% Construct the derivative based filter to remove low-frequency artifact 
% according to equation 3, and normalize the filter to have a maximal gain 
% of unity: divide the gain b by real(max(freq_response)). In other words, 
% specify and normalize the filter coefficients a and b, and use them with 
% the filter command.
% The data is in the vectors called 'ecg1' and 'ecg2'. 
% -------------------------------------------------------------------------

% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load('ecg_signal_1.dat');

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load('ecg_signal_2.dat');

% Create derivative based filter coefficients a and b:
b = FS * [1,-1]; 
a = [1,-0.995];
% Normalize the filter to have a maximal gain of unity:
[h,w] = freqz(b,a);
b = b/max(abs(h));
% or:
% b = b/real(max(freqz(b,a)));
    
% Do the filtering using a, b, and ecg1
% For ecg1
ecg1_filtered = filter(b,a,ecg1);
% ...and ecg2
ecg2_filtered = filter(b,a,ecg2);

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
