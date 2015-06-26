%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE
% * This script only blends sources of a 2D source grid

% INPUT PARAMETERS
% * t_g   Blending window.
% * b     Number of blended sources


% OUTPUT
% * Blending matrix with the following properties:
%       -> b sources are blended
%       -> The blending time shifts are fully random
%       -> The elements of g are integers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [g,Ne] = g2d(t_g,b,Ns,pattern)


% Number of experiments, initialize g
Ne = round(Ns/b);   g = zeros(Ns,Ne);

% Set default blending pattern
if nargin < 4
    pattern = 1;
end

% Pattern 0: b ajacent sources are blended with random time delays in
% order, eg from the left to the right
if pattern == 0
    
    for exp = 1:Ne
        g( 1+(exp-1)*b : exp*b,exp ) = [1 ; t_g * sort( rand(b-1,1) ) ];
    end
    
% Pattern 1: b adjacent sources are blended with random time delays in
% random order
elseif pattern == 1
    
    for exp = 1:Ne
        g( 1+(exp-1)*b : exp*b,exp ) = [1 ; t_g*rand(b-1,1) ];
    end
    
% Pattern 2: b randomly picked sources are blended with random time delays    
elseif pattern == 2
    
    for exp = 1:Ne
        g( 1+(exp-1)*b : exp*b,exp ) = [1 ; t_g*rand(b-1,1) ];
    end
    
    % Randomly shuffle the sources which are blended
    ind = randperm(Ns);
    g(ind,:) = g;
    
% Pattern 3: b randomly picked sources are blended with no time delay
elseif pattern == 3
    
    for exp = 1:Ne
        g( 1+(exp-1)*b : exp*b,exp ) = ones(b,1);
    end
    
    % Randomly shuffle the sources which are blended
    ind = randperm(Ns);
    g(ind,:) = g;
    
% Pattern 4: b adjacent sources are blended with no time delay in
% order, eg from the left to the right
elseif pattern == 4
    
    for exp = 1:Ne
        g( 1+(exp-1)*b : exp*b,exp ) = ones(b,1);
    end
    
end

% Make sure that g contains only integers.
g = ceil(g);