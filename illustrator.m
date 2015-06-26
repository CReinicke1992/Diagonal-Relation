

% Make functions available
addpath('Incoherency-Functions');


%% Create a 2d blending matrix

% Parameters
Ns  = 105;      % Number of sources
b   = 5;        % Blending factor
dt  = 0.002;    % Sampling rate: Seconds per sample
tg  = 100;      % Maximum time delay in time samples
Nt  = 201;      % Number of time samples
pattern = 3;    % Blending pattern (Time + Space)

% Patterns:
% 0     Time
% 1     Time Space Experiment
% 2     Time Space 
% 3     Space
% 4     None

[G3,g3] = crane(Ns,Nt,b,tg,pattern);

%% Compute GGH, sum along diagonals, and sum over all frequency components

% Initialize matrix to save the sums along diagonals for each frequency
% component separately
diagsum = zeros(Ns,Nt);
inco = zeros(1,Nt);

% Iterate over all frequency components
for w = 1:size(G3,3)
    
    % Compute G*Gh
    G = squeeze( G3(:,:,w) );
    Gh = G';
    GGH = G*Gh;
    
    % Sum along diagonals
    % Save the result in diagsum
    for dia = 1:Ns
        diagsum(dia,w) =  abs( sum(diag(GGH,dia-1)) );
    end
    
    inco(1,w) = diagsum(1,w)^2 / sum(diagsum(:,w).^2);
   
end

% Sum over all frequency components
% Ideally the output is the autocorrelation with respect to source lag
autocorr = sum(diagsum,2);

figure(1); plot( autocorr(:,1) );
figure(2); plot( diagsum(:,30) );
figure(3); plot( inco);

in = autocorr(1,1)^2 / sum(autocorr.^2);
in_mod = mean(inco);