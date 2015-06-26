%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
% * g:  3d blending matrix with entries equal to 1 or 0
%       Dimension Nsx x Ne x t_g

% OUTPUT
% * in:
%   * Incoherency estimation based on the 3d autocorreltion auto of g 
%   * The matrix 'g' is normed for a fair comparison between incoherencies
%   * Idea: Incoherency = ( Zero-Lag-Amlitude 
%                          / norm(All Amplitudes) )^2
% * auto: 3d auto-correlation (optional output)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [in,auto] = incoherency3d(g)

%% Checks & Preparation

if max(g(:)) <= 0
    m1 = 'incoherency3d.m expects a blending matrix g with at least one '; 
    m2 = ' positive entry per experiment (2nd dimension).';
    message = strcat(m1,m2);
    error(message);
end

if ndims(g) ~= 3
    error('incoherency3d.m expects a 3d gamma matrix g.')
end

% Normalize g
g = g./norm3(g);

% Compute 3d autocorrelation: auto is a 3d array!
auto = acorr3(g);

% Indices of the zero lag autocorrelation: The autocorrelation has a
% maximum at zero lag
[maxauto,t] = max(max(max(auto)));
[~,exp]     = max(max(auto(:,:,t)));
[~,sx]      = max(auto(:,exp,t));

% Set the zero lag amplitude to zero 
auto(sx,exp,t) = 0;


%% Stabilization factor

% * Introduce a stabilization factor 'stab' to avoid zero divisions
% * Use 1E-8 of the squared maximum value of the autocorrelation to avoid
%   numerical issues (1E-8 is machine precision for singles) 

if max(maxauto) > 0
  
    stab = 1E-8 * maxauto^2;      % I use the square because in the below 
                                   % formula stab is also related to the 
                                   % squared amplitudes of auto
                                   
else
    m1 = 'The autocorrelation values of the Gamma matrix should be larger';
    m2 = ' than 0.';
    message = strcat(m1,m2);
    error(message);
end

%% Incoherency computation

% * Divide the amplitude at zero lag by the norm of all amplitudes with non
%   zero lag
% * Square the results to relate the result to energy 
% * this is sort of signal to noise ratio
in = maxauto^2 / (norm3(auto)^2 + stab);

%% Fix the autocorrelation zero lag value for return
auto(sx,exp,t) = maxauto;

