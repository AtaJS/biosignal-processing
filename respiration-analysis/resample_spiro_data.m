%% Part1: Resample spirometer data ----------------------------------------
% Resample the spirometer signal from 100 Hz into 50 Hz. The data is already 
% in the 2Nx1 vector called 'spiro'.
% Store the result into the variable called 'spiro_resampled' already given 
% in the solution template!
% -------------------------------------------------------------------------

% Load the data/variables from the file named spirometer.txt
spiro = load('spirometer.txt');

% The spirometer data 'spiro' is a 2Nx1 vector
% Resample the spirometer data into 50 Hz
spiro_resampled = resample(spiro, 50, 100);