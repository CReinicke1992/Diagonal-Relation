%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
% * Ns:      Number of sources
% * dt:      Time sampling duration in seconds
% * b:       Blending factor
% * t_g:     Shooting window in time samples
% * pattern: Chosse a number between 0 and 4 to select a blending pattern
%            See source_deblending_mod.m for the available patterns.

% OUTPUT
% * G3:     A blending matrix gamma formated according to Mahdad 2011
% *         Dimension: Sources x Experiments x Frequencies
%           Element format: exp(-jwt)?
%           t is the time delay of source in an experiment
% * g3:     Optionally the 3d gamma matrix can be output in time domain
% *         Dimension: Sources x Experiments x Time

% ANNOTATION
% * The time delays are determined with the function g3d.m and converted to
%   a 2d format with g3dto2d.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [G3,g3] = crane_mod(Ns,Nt,b,t_g,pattern)

%% Stability checks

% Check if the function 'g3d.m' is available
if exist('g3d.m','file') ~= 2
    m1 = 'crane.m requires the function g3d.m to build the ';
    m2 = ' compute the matrix gamma.';
    message = strcat(m1,m2);
    error(message);
end

% Check if the function 'g3dto2d.m' is available
if exist('g3dto2d.m','file') ~= 2
    m1 = 'crane.m requires the function g3dto2d.m to build the ';
    m2 = ' compute the matrix gamma.';
    message = strcat(m1,m2);
    error(message);
end

Ne = round(Ns/b);

%% Compute G

% g3: 3d Blending matrix gamma
% Ne: Number of experiments
% Soure x Experiment x Time, each element is 1 or 0
[g3,~] = g3d(t_g,b,Ns,pattern);

new = zeros(Ns,Ne,Nt);
new(:,:,1:t_g) = g3; 
g3 = new; clear new

G3 = fft(g3,[],3);









