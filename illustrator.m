% Make functions available
addpath('Incoherency-Functions');


%% Create a 2d blending matrix

% Parameters
Ns  = 105;      % Number of sources
b   = 5;        % Blending factor
dt  = 0.002;    % Sampling rate: Seconds per sample
tg  = 100;      % Maximum time delay in time samples
Nt  = 201;      % Number of time samples
pattern = 2;    % Blending pattern (Time + Space)

[G3,g3] = crane(Ns,Nt,b,tg,pattern);

%% Compute incoherency

[in,auto] = incoherency3d(g3);