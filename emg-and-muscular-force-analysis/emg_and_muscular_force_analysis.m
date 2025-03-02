%% PART5: EMG and Muscular Force Analysis ---------------------------------
% Task
% Your task is to:
% 1. Study the data by plotting it with respect to time. I.e. plot all the 
% segments of the already normalized force (in %MVC) in a subplot(2,1,1), 
% and the EMG signal (in mV) in a subplot(2,1,2) against their time 
% corresponding time axes. Your plot will be like Figure 1 above, with the 
% discarded signal parts (not belonging to any segment) missing from the 
% plot. Hint: you can plot the 5 segments with separate plot signals (using 
% hold on), and keep the segments in their default colors.
% 2. Calculate the average force exerted within each segment of the force 
% signal.
% 3. Compute the DR for each segment of the EMG signal. 
% 4. For each segment of the EMG signal, compute MS. Ensure that the MS 
% values are computed using the appropriate number of samples for each 
% segment. The MS value of a signal x over its duration of N samples is the 
% following: MS = (1/N)*sum(x^2(i)) % sum is from 0 to N-1
% 5. For each segment of the EMG signal, compute ZCR without using 
% dsp.ZeroCrossingDetector. Ensure that you normalize ZCR to zero crossings 
% per second by dividing the number of zero crossings by the time duration 
% of the corresponding segment. Do not remove the mean but assume the signal 
% is zero mean already.
% 6. For each segment of the EMG signal, compute TCR with the algorithm* 
% given below.
% 7. Using the polyfit and polyval functions in MATLAB, obtain a 
% straight-line (linear) fit to represent the variation of each EMG 
% parameter as a function of independent variable force. Superimpose the 
% obtained linear models (straight-line fits) on their corresponding 
% subplots of the preceding step.
% 8. Compute the correlation coefficients (r) for each parameter with corr 
% function.

% *) TCR algorithm
% To find the TCR, proceed as follows:
% Compute the derivative of the EMG signal (diff)
% Detect the points of change in its sign (defined as the MATLAB sign 
% function, taking values in {-1, 0, 1})
% A significant turn is found wherever the derivative signal changes sign, 
% and the original signal differs by at least 100 μV between current and 
% previous (significant or non-significant) turn points (not the previous 
% samples).
% TCR is the amount of significant turns divided by the time duration of 
% the corresponding segment
% Note 1: A sign change between two of the derivative samples implies that 
% there exists a zero crossing between them (as the derivative is considered 
% also to be a continuous signal). This vanishing of the derivative happens 
% at an extrema point (min/max) of the original signal.
% Note 2: If utilizing the MATLAB sign command, please also consider that 
% it evaluates to 0 at 0.
%
% -------------------------------------------------------------------------

% The sampling rate is 2000 Hz 
FS = 2000;

% Load the signals from data.mat into the struct 'data'
load('data.mat', 'data');

% Number of segments
N = numel(data);  

% Calculate average force of each segment (1xN vector)
AF = cellfun(@average_force, {data.force});

% Calculate EMG dynamic range in each segment (1xN vector)
DR = cellfun(@dynamic_range, {data.EMG});

% Calculate EMG mean squared value in each segment (1xN vector)
MS = cellfun(@mean_squared, {data.EMG});

% Calculate EMG zero crossing rate in each segment (1xN vector)
ZCR = cellfun(@zero_crossing_rate, {data.EMG}, num2cell([data.length]), num2cell(FS * ones(1, N)));

% Calculate EMG turns rate in each segment (1xN vector)
TCR = cellfun(@turns_count_rate, {data.EMG}, num2cell([data.length]), num2cell(FS * ones(1, N)));
%TCR = cellfun(@(emg, len) turns_count_rate(emg, len, FS), {data.EMG}, num2cell([data.length]));

% Calculate the linear model coefficients for each parameter
% The models are in the form: parameter(force) = constant + slope * force,
% and the coefficients are stored in a 1x2 vectors: p_<param> = [slope constant]
% For example, p_DR(1) is the slope and p_DR(2) is the constant of the linear model mapping the average force into the dynamic range
% You can use the 'polyfit' (or the 'regress') command(s) to find the model coefficients
p_DR = polyfit(AF, DR, 1);
p_MS = polyfit(AF, MS, 1);
p_ZCR = polyfit(AF, ZCR, 1);
p_TCR = polyfit(AF, TCR, 1);

% Calculate correlation coefficients between the average forces and each of the parameters using 'corr'
c_DR = corr(AF', DR');
c_MS = corr(AF', MS');
c_ZCR = corr(AF', ZCR');
c_TCR = corr(AF', TCR');

% ------------------------- Function Definitions -------------------------

function af = average_force(force)
    af = mean(force);
end

function dr = dynamic_range(emg)
    dr = max(emg) - min(emg);
end

function ms = mean_squared(emg)
    ms = mean(emg.^2);
end

function zcr = zero_crossing_rate(emg, len, fs)
    % Count zero crossings
    zc = sum(abs(diff(sign(emg)))) / 2;
    % Normalize by segment duration
    zcr = zc / (len / fs);
end

function tcr = turns_count_rate(emg, len, fs)
    m = diff(emg(1:end-1)) .* diff(emg(2:end)) ;
    idx = find(m <= 0) + 1 ;
    D = abs(diff(emg(idx))) >= 0.1 ;
    TC = sum(D) ;
    tcr = TC / (len / fs);
end

% Plotting ---------------------------------------------------------------

% Plot 1
% Plotting the EMG signal and turn points for inspection
emg = data(5).EMG;  % Example: Take the 5th segment's EMG signal
t = data(5).t;      % Time vector for the same segment

% Detect turn points
diff_emg = diff(emg);  % First derivative
turns = find(diff(sign(diff_emg)) ~= 0);  % Detect the turns

% Plot the EMG signal and turn points in red
figure; hold on;
plot(t, emg, 'b');        % Plot the EMG signal
plot(t(turns), emg(turns), 'r*');  % Plot turn points in red


% Plot 2
N = numel(data);  % number of segments

figure;

subplot(211);
hold on;
for i = 1:N
    plot(data(i).t, data(i).force);
end
axis tight;
xlabel('Time (seconds)');
ylabel('Force (%MVC)')

subplot(212);
hold on;
for i = 1:N
    plot(data(i).t, data(i).EMG);
end
axis tight;
xlabel('Time (seconds)');
ylabel('EMG amplitude (mV)');


% Plot 3
% Gathering data into arrays for looping
X = [DR; MS; ZCR; TCR];
MODELS = {p_DR, p_MS, p_ZCR, p_TCR};
LABELS = {'DR', 'MS', 'ZCR', 'TCR'};
CORRS = [c_DR, c_MS, c_ZCR, c_TCR ];

% Plotting linear models and raw data
figure;
for i = 1:4
    subplot(2,2,i);
    line = polyval(MODELS{i}, AF);  % line estimate
    plot(AF, line);
    hold on;
    plot(AF, X(i,:), 'o');
    xlabel('Force (%MVC)');
    ylabel([LABELS{i}, ' of EMG']);
    title(['Correlation ', num2str(CORRS(i))] );
end