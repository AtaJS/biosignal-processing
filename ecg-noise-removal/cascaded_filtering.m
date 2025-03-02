%% Part6: Cascaded filtering ----------------------------------------------
% Cascading time invariante digital filters in a series creates a new joint 
% filter. The transfer function of the resulting filter is equal to the 
% multiplication of the transfer functions of the individual filters, and 
% the order of the filters in the series (and multiplication) does not 
% matter. And since multiplication in the frequency domain is equal to 
% convolution in the time domain, the response of the joint filter can be 
% obtained as the convolution of the individual filter coefficients.
%
% Task
% Construct the filter coefficient of the joint filter that combines all 
% the filters in the previous problems, i.e. the moving average filter, 
% derivative based filter, and the comb filter. Then, use the filter on 
% both the ECG data as previously. 
% The ecg data is in the vectors called 'ecg1' and 'ecg2'. 
%--------------------------------------------------------------------------

% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load('ecg_signal_1.dat');

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load('ecg_signal_2.dat');

% Create cascaded filter coefficients a and b using convolution
b_MA = (1/10)*ones(1,10);
a_MA = 1;

b_Dir = FS * [1,-1];
a_Dir = [1,-0.995];
b_Dir = b_Dir/real(max(freqz(b_Dir,a_Dir)));

b_com = [0.6310 -0.2149 0.1512 -0.1288 0.1227 -0.1288 0.1512 -0.2149 0.6310] ;
a_com = 1 ;

b = conv(conv(b_MA, b_Dir), b_com);
a = conv(conv(a_MA, a_Dir), a_com);
    
% Do the filtering using a, b, and ecg1
% For ecg1
ecg1_filtered = filter(b, a, ecg1);
% ...and ecg2
ecg2_filtered = filter(b, a, ecg2);

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