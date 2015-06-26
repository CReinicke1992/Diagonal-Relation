%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE
% * Create a 3d blending matrix
% * But the blending matrix is organized in a new way:
%   Soure x Experiment x Time, each element is 1 or 0

% INPUT PARAMETERS
% * t_g   Blending window.
% * b     Number of blended sources


% OUTPUT
% * Blending matrix with the following properties:
%       -> b sources are blended
%       -> Dimension: Source x Experiment x Time Ns x Ne x t_g
%       -> The elements of g are integers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [g,Ne] = g3d(t_g,b,Ns,pattern)

% Number of experiments, initialize g
Ne = Ns/b;   g = zeros(Ns,Ne,t_g);

% Ne must be an integer
if Ne ~= round(Ne)
    error('The number of sources Ns must be a multiple of the blending factor b.')
end

% Set default blending pattern
if nargin < 4
    pattern = 0;
end

% Pattern 0: Time
% b adjacent sources are blended with random time delays in
% order, eg from the left to the right
if pattern == 0
    
    for exp = 1:Ne
        times = [ 1 ; ceil( t_g * sort(rand(b-1,1)) ) ];
        for src = 1+(exp-1)*b : exp*b
            t = times( src - (exp-1)*b );
            g( src,exp, t ) = 1;
        end
    end
    
% Pattern 1: Time-Space-Experiment
% b adjacent sources are blended with random time delays in
% random order
elseif pattern == 1
    
    for exp = 1:Ne
        times = [ 1 ; ceil( t_g * rand(b-1,1) ) ];
        for src = 1+(exp-1)*b : exp*b
            t = times( src - (exp-1)*b );
            g( src,exp, t ) = 1;
        end
    end
    
% Pattern 2: Time Space
% b randomly picked sources are blended with random time delays    
elseif pattern == 2
        
    for exp = 1:Ne
        times = [ 1 ; ceil( t_g * rand(b-1,1) ) ];
        for src = 1+(exp-1)*b : exp*b
            t = times( src - (exp-1)*b );
            g( src,exp, t ) = 1;
        end
    end
    
    % Randomly shuffle the sources which are blended
    ind = randperm(Ns);
    g(ind,:,:) = g;
    
% Pattern 3: Space 
% b randomly picked sources are blended with no time delay
elseif pattern == 3
    
    for exp = 1:Ne
        times = ones(b,1);
        for src = 1+(exp-1)*b : exp*b
            t = times( src - (exp-1)*b );
            g( src,exp, t ) = 1;
        end
    end
    
    % Randomly shuffle the sources which are blended
    ind = randperm(Ns);
    g(ind,:,:) = g;
    
% Pattern 4: None 
% b adjacent sources are blended with no time delay in
% order, eg from the left to the right
elseif pattern == 4
    
    for exp = 1:Ne
        times = ones(b,1);
        for src = 1+(exp-1)*b : exp*b
            t = times( src - (exp-1)*b );
            g( src,exp, t ) = 1;
        end
    end
    
end
