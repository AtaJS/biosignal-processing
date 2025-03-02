%% Implement Pan-Tompkins filters
% Task
% Fill in the missing parts of the script to perform various filtering 
% procedures that compose the Pan-Tompkins algorithm. Use the filter 
% function for each step of signal processing; see Section 4.3.2 of the 
% course book about details of the algorithm. Note:Yes, you need to read 
% the chapter from the book at this point.
% All the transfer functions of the filters are given in the course book. 
% Before applying them with filter command, put them in the following 
% format to get the coefficients a and b:
%    Y(z) = (b(1)+b(2)*z^-1+...+b(m+1)*z^-m)/(1+a(2)*z^-1+...+a(n+1)*z^-n)     (1)
% The amplitude of an ECG signal may start with a value other than zero. 
% Consequently, the differentiator in the Pan-Tompkins algorithm will 
% amplify the initial step, possibly resulting in an erroneous beat 
% detection. In order to prevent this problem, we will subtract the value 
% of its first sample from the entire ECG signal prior to processing by the 
% Pan-Tompkins algorithm.
%
% You will need to accomplish the following steps:
%   1. Load the data and calculate the sample time
%   2. Subtract the value of the first sample of the ECG signal from the entire ECG
%   3. Low pass filter, equation 4.7
%   4. High pass filter, equation 4.11
%   5. Derivative filter (Notice: Formula 4.14 in the course book 
%      (2015, formula 4.13 2002) is incorrect! Correct formula: 
%      y(n)=(1/8)*( x(n) + 2x(n-1) - 2x(n-3) - x(n-4) ) .)
%   6. Squaring and integration, formula 4.15 (2015, formula 4.14 2002), N = 30
%   7. Detecting the QRS complexes using the provided findQRS blackbox function. 
%      Use blanking interval of 250 ms, and the detection thresholds given in 
%      the code template
%   8. Calculate the combined filtering delay
%
% The findQRS function call syntax is as follows: 
% [QRSStart, QRSEnd] = findQRS(data,blankingInterval,treshold1,treshold2) 
% where Inputs:
%   data: P-T output from which you want to detect the QRS complexes 
%   (point 6. above).
%   blankingInterval: number of samples not processed after a QRS complex 
%   found, i.e. new start of QRS is not allowed within this distance from 
%   previous hit.
%   treshold1: Q-wave begins here
%   treshold2: S-wave
%
% Outputs:
%    QRSStart: beginning points of QRS complexes
%    QRSEnd: ending points of QRS complexes

% -------------------------------------------------------------------------

% The sampling rate is 200 Hz 
FS = 200;

% Calculate the sample interval from FS
T = 1/FS;

% Load the ECG from the file 'ECG.txt'
ECG = load('ECG.txt');

% Substract the first sample value to prevent P-T to amplify inital step
ECG = ECG - ECG(1);

% Lowpass filter The ECG
b_lowpass = (1/32)*[1,0,0,0,0,0,-2,0,0,0,0,0,1];
a_lowpass = [1,-2,1];
ECG_filtered1 = filter(b_lowpass,a_lowpass, ECG);

% Highpass filter the lowpass filtered ECG
b_highpass = zeros(1,33);
b_highpass(1) = -1/32;
b_highpass(17) = 1;
b_highpass(18) = -1;
b_highpass(33) = 1/32;
a_highpass = [1, -1];
ECG_filtered2 = filter(b_highpass, a_highpass, ECG_filtered1);

% Differential filter the high- and lowpass filtered ECG
b_diff = [1/8,2/8,0,-2/8,-1/8];
a_diff = 1; 
ECG_filtered3 = filter(b_diff, a_diff, ECG_filtered2);

% Square the derivative filtered signal
ECG_filtered4 = ECG_filtered3 .^ 2 ;

% Moving window integrator filter the squared signal
% Window size
N = 30;
b_integ = (1/N)*ones(1,N);
a_integ = 1 ;
ECG_filtered5 = filter(b_integ,a_integ,ECG_filtered4) ;

% Set the blanking interval to 250 ms, but convert it to samples for the findQRS function
blankingInterval = (250/1000) * FS;

% The amplitude threshold for QRS detection are set to these
treshold1 = 500; 
treshold2 = 2650; 

% Call the findQRS function 
[QRSStart_ECG, QRSEnd_ECG] = findQRS(ECG_filtered5,blankingInterval,treshold1,treshold2);

% Calculate the cumulative filter delays (in samples)
delays = 5 + 16 ;


% Plotting:

subplot(6,1,1);
plot((1:length(ECG))*T,ECG);
xlabel('Time (s)');
ylabel('A.U.');
title('Original');

subplot(6,1,2);
plot((1:length(ECG_filtered1))*T,ECG_filtered1);
xlabel('Time (s)');
ylabel('A.U.');
title('Lowpass filtered');

subplot(6,1,3);
plot((1:length(ECG_filtered2))*T,ECG_filtered2);
xlabel('Time (s)');
ylabel('A.U.');
title('Highpass filtered');

subplot(6,1,4);
plot((1:length(ECG_filtered3))*T,ECG_filtered3);
xlabel('Time (s)');
ylabel('A.U.');
title('Derivative filtered');

subplot(6,1,5);
plot((1:length(ECG_filtered5))*T,ECG_filtered5);
xlabel('Time (s)');
ylabel('A.U.');
title('Moving-window integrator output');


time_axis = (1:length(ECG))*T;
hold on; % Output of P-T
plot(time_axis(QRSStart_ECG),ECG_filtered5(QRSStart_ECG),'r*');
plot(time_axis(QRSEnd_ECG),ECG_filtered5(QRSEnd_ECG),'ro');

delays = round(delays); % to make plotting more robust in case rounding errors added up
subplot(6,1,6);hold on; % ECG-channel
plot((1:length(ECG))*T,ECG);
plot(time_axis((QRSStart_ECG-delays)),ECG((QRSStart_ECG-delays)),'r*');
plot(time_axis((QRSEnd_ECG-delays)),ECG((QRSEnd_ECG-delays)),'ro');
xlabel('Time (s)');
ylabel('A.U.');
title('Original marked');


% **Computation of parameters************************************
beats = length(QRSStart_ECG);
disp(['# beats: ', num2str(beats)]);
averageRRinterval = mean(QRSStart_ECG(2:length(QRSStart_ECG))-QRSStart_ECG(1:(length(QRSStart_ECG)-1)))*T*1000;
disp(['avg R-R: ', num2str(averageRRinterval)]);
stdRRinterval = std(QRSStart_ECG(2:length(QRSStart_ECG))-QRSStart_ECG(1:(length(QRSStart_ECG)-1)))*T*1000;
disp(['std R-R: ', num2str(stdRRinterval)]);
heartRate = 60*1000/averageRRinterval;
disp(['HR bpm : ', num2str(heartRate)]);