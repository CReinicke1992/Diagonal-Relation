% ISSUE
% * This script only blends sources of a 3D source grid. It only blends
%   them within crosslines.


%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT PARAMETERS
% * t_g   Blending window. 
% * Ns    Total number of sources (crossline + inline)
% * Nsx   Number of crossline sources
% * b     Number of blended sources per experiment


% OUTPUT
% * Blending matrix with the following properties:
%       -> b sources are blended
%       -> The elements of g are integers
%%%%%%%%%%%%%%%%%%%%%%%%%%

function g = gxin(t_g,Ns,Nsx,b,pattern)

% This check used to be in the deblending function. I am not sure why t_g
% is supposed to be en even number. To avoid stupid errors I just copied
% this check
if mod(t_g,2) ~= 0; 
    error('This program expects an even number for the time window t_g.'); 
end

% Number of experiments, Number of inline sources , initialize g
Ne = round(Ns/b);       Nsi = round(Ns/Nsx);    g = zeros(Ns,Ne);   

% Dimesnsion check
if Ns ~= Nsx*Nsi
    error('The total number of sources Ns should be equal to Nsx*Nsi.');
end

% Due to the sailing direction of the boat, each experiment should be
% carried out within a single crossline.
if mod(Nsx,b) ~= 0
   m1 = 'gxin.m blends sources within a crossline. Thus, the ';
   m2 = ' blending factor should be a divisor of the number of ';
   m3 = ' crossline sources.';
   message = strcat(m1,m2,m3); clear m1 m2 m3
   error(message);
end

% Set default blending pattern
if nargin < 5
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
    
% Pattern 2: b randomly picked sources within a crossline are blended with random time delays    
elseif pattern == 2
    
    for exp = 1:Ne
        g( 1+(exp-1)*b : exp*b,exp ) = [1 ; t_g*rand(b-1,1) ];
    end
    
    % Randomly shuffle the sources within a crossline
    for in = 1:Nsi
        ind = (in-1)*Nsx + randperm(Nsx);
        g(1+(in-1)*Nsx : in*Nsx ,:) = g(ind,:);
    end
    
% Pattern 3: b randomly picked sources within a crossline are blended with no time delay
elseif pattern == 3
    
    for exp = 1:Ne
        g( 1+(exp-1)*b : exp*b,exp ) = ones(b,1);
    end
    
    % Randomly shuffle the sources within a crossline
    for in = 1:Nsi
        ind = (in-1)*Nsx + randperm(Nsx);
        g(1+(in-1)*Nsx : in*Nsx ,:) = g(ind,:);
    end
    
% Pattern 4: b adjacent sources are blended with no time delay in
% order, eg from the left to the right
elseif pattern == 4
    
    for exp = 1:Ne
        g( 1+(exp-1)*b : exp*b,exp ) = ones(b,1);
    end
   
% Pattern 5: b randomly picked sources are blended with random time delays
elseif pattern == 5
    
    for exp = 1:Ne
        g( 1+(exp-1)*b : exp*b,exp ) = [1 ; t_g*rand(b-1,1) ];
    end
    
    % Randomly shuffle the sources within a crossline
    ind = randperm(Ns);
    g(ind,:) = g;
    

% Pattern 6: b randomly picked sources are blended with no time delay
elseif pattern == 6
    
    for exp = 1:Ne
        g( 1+(exp-1)*b : exp*b,exp ) = ones(b,1);
    end
    
    % Randomly shuffle the sources
    ind = randperm(Ns);
    g(ind ,:) = g;
end

% Make sure that g contains only integers.
g = ceil(g);

save('Data/Blending_parameters.mat','g','t_g','Ne','b','pattern');








