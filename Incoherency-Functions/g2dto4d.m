%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE 
% * Transform 2d gamma matrix to 4d gamma matrix

% INPUT
% * g2d:    2d gamma matrix: Soure x Experiment (for 3d data in Delphi format)
% * t_g:    Shooting window

% OUTPUT
% * g4d:    3d gamma matrix: Crossline Soure x Inline Source x Experiment x Time 
%                            Nsx x Nsi x Ne x t_g
% * If there is a source at a specific element of g4d, then the element is
%   1, otherwise 0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




function g4d = g2dto4d(g2d,t_g)


%% 2.1 Load general parameters

% Load the paramteres which belong to the loaded data, in this case it is
% the reduced data
fileID = '../Parameters_red.mat';
Parameters_red = load(fileID); clear fileID

Nsx  = Parameters_red.Nsx;   % Number of crossline sources
Nsi  = Parameters_red.Nsi;   % Number of inline sources


[~,Ne] = size(g2d);

%% Stability check

% g2d should only contain integers
if norm(round(g2d) - g2d) ~= 0
    error('g2dto4d.m expects a blending matrix g2d with integer entries.');
end

%% Build 4d gamma matrix

g4d = zeros(Nsx,Nsi,Ne,t_g);

for insrc = 1:Nsi
    for xsrc = 1:Nsx
        for exp = 1:Ne
            ind = g2d(   (insrc-1)*Nsx + xsrc    ,exp);
            if ind ~= 0
                g4d(xsrc,insrc,exp,ind) = 1;
            end
        end
    end
end

