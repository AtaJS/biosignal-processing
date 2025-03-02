%% PART4: Full adaptive filtering -----------------------------------------
%
% Task
% Your task is to find the best parameter combination for LMS filtering. 
% To accomplish that, complete the given function template by writing your 
% own code that. 
% 1. Goes through all the possible combinations of filter lengths in m_list 
% and learning rate fractions in c_list.
% 2. Does the classic LMS filtering using doLMSFiltering() nested function 
% (to be completed by you) for each combination of the parameters.
% Compares the LMS filter output with each combination to the known fetalECG 
% by computing the mean squared error by evaluateResult() nested function 
% (to be completed by you).
% Selects the best parameter combination giving the lowest MSE
% Returns the best parameters, the filter coefficients of the best filter, 
% and the lowest MSE.
% 
% Hence, you have to complete:
% The first nested function doLMSFiltering() to create the dsp.LMSFilter 
% object based on the parameters given to that function, and to then use it 
% on the data given in the said parameters.
% The second nested function evaluateResult() that you will use to evaluate 
% how closely each LMS filter output corresponds to the known fetal ECG.
% The main body of the findBestFilterParameters() function calling 
% doLMSFiltering() and evaluateResult() functions suitably on all the 
% parameter combinations to be tested.
% The data for this problem is stored in the filer 'problem4.mat' in the 
% variables 'abd_sig1' and 'mhb_ahead_PI', and 'fhb'.  The variable 'abd_sig1'  
% an artificial mixture of maternal and fetal ECGs summed together in the 
% abdomen measurement. The variable 'mhb_ahead_PI' only the maternal ECG as 
% measured from the chest including time delay and power line interference. 
% The variable 'fhb' contains the known true fetal ECG that usually cannot 
% be measured directly.
%
% Note
% Please take into account that the mathematical variable namings have some 
% differences between this and the previous three problems!
% -------------------------------------------------------------------------


load('problem4.mat');

MU_MAX = 0.05;
FILTER_LENGHTS = [1 5 11 15 21 31 51 101]';
ADAPTATION_RATES = (0.1:0.1:1)';

[best_m, best_c, best_w, best_mse] = findBestFilterParameters(mhb_ahead_PI, abd_sig1, fhb, FILTER_LENGHTS, ADAPTATION_RATES, MU_MAX)



function [best_m, best_c, best_w, best_mse] = findBestFilterParameters(chestECG, abdomenECG, fetalECG, m_list, c_list, mu_max)
% This function finds the best LMS filter parameter combination from the
% given lists using two inner functions.
% To be completed by you!
%
% INPUTS:
%   chestECG    ECG from the chest, maternal ECG only, reference input, Nx1
%   abdomenECG  ECG from the abdomen, fetal and maternal mixed, primary input, Nx1
%   fetalECG    ECG from the fetus alone, signal of interest, Nx1 (cannot be measured directly, but is given for evaluation here)
%   m_list      list of filter lengths/orders to test, Mx1
%   c_list      list of step size fractions to test, Cx1 (each >0 & <1)
%   mu_max      maximum step size, scalar
%
% OUTPUTS:
%   best_m      the best filter length (from the m_list), scalar
%   best_c      the best fraction of mu_max (from the m_list), scalar
%   best_w      the best filter coefficients, best_m x 1 vector
%   best_mse    the lowest mean squared error obtained with the best parameters, scalar

% When evaluating the results in evaluateResult(), skip this many samples from the beginning to avoid initial adaptation transient
INITIAL_REJECTION = 2000;
best_mse = inf;  
best_m = NaN;    
best_c = NaN;    
best_w = []; 

% Here you go through all the possible combinations of filter lengths in m_list and learning rate fractions in c_list selecting the best performing one
% << INSERT YOUR CODE HERE >>
for i=1:length(m_list)
    for j=1:length(c_list)
        step = (2*c_list(j)*mu_max)/(m_list(i));
        [y,e,w] = doLMSFiltering(m_list(i), step, chestECG, abdomenECG);
        mse = evaluateResult(e);
        
        if mse < best_mse
            best_mse = mse;
            best_m = m_list(i);
            best_c = c_list(j);
            best_w = w;
        end
        
    end
end


    function [y,e,w] = doLMSFiltering(m,step,r,x)
    % Does the actual LMS filtering.
    % To be completed by you!
    %
    % INPUTS:
    %   m       filter length
    %   step    LMS learning rule step size
    %   r       reference input (to be filtered)
    %   x       primary observed signal
    %
    % OUTPUTS:
    %   y       filtered signal r
    %   e       filter output, estimate of the signal of interest v

    % Create the dsp.LMSFilter object and use it to filter the input data
    lmsFilter = dsp.LMSFilter('Length', m, 'StepSize', step);

    % y is the output (filtered signal), e is the error signal
    [y, e, w] = lmsFilter(r, x);   
    
    end

    function mse = evaluateResult(v)
    % Calculates the mean squared error between the filtered signal v and
    % the known fetal ECG.
    %
    % NOTE1:    Skip INITIAL_REJECTION number of samples in the beginning of both signals to not include initial adaptation transient
    % 
    % NOTE2:    This nested function can access the desired output value in fetalECG directly!
    %
    % INPUTS:
    %   v       estimate of the signal of interest 
    %
    % OUTPUTS:
    %   mse     mean squared error between v and fetalECG    

    % You can call the 'immse' function for the signals without the initial rejection parts
    % << INSERT YOUR CODE HERE >>
    v_rejected = v(INITIAL_REJECTION+1:end);
    fetalECG_rejected = fetalECG(INITIAL_REJECTION+1:end);
    mse = immse(v_rejected, fetalECG_rejected); % MSE between the filtered signal and fetal ECG
    
    end

end


