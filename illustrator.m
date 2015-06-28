

% Make functions available
addpath('Incoherency-Functions');


%% Create a 2d blending matrix

% Parameters
Ns  =105;      % Number of sources
b   = 5;        % Blending factor
dt  = 0.002;    % Sampling rate: Seconds per sample
tg  = 100;      % Maximum time delay in time samples
Nt  = 201;      % Number of time samples
pattern = 2;    % Blending pattern (Time + Space)

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
diagsum = zeros(2*Ns-1,Nt);
inco = zeros(1,Nt);

% Iterate over all frequency components
for w = 1:size(G3,3)
    
    % Compute G*Gh
    G = squeeze( G3(:,:,w) );
    Gh = G';
    GGH = G*Gh;
    
    % Sum along diagonals
    % Save the result in diagsum
    for dia = 1-Ns:Ns-1
        diagsum(dia+Ns,w) =  abs( sum(diag(GGH,dia)) );
    end
        
    inco(1,w) = b / sum(diagsum(:,w));
   
end

% Sum over all frequency components
% Ideally the output is the autocorrelation with respect to source lag
autocorr = sum(diagsum,2);

figure(1); plot( autocorr(:,1) ); title('autocorrelation for summed frequencies');
figure(2); plot( diagsum(:,30) ); title('autocorrelation of w = 30');
figure(3); plot( inco); xlabel('Frequency')

in = autocorr(Ns,1)^2 / sum(autocorr.^2);

autocorr_tmp = [autocorr(1:Ns-1);0; autocorr(Ns+1:end,1) ];

weight = (2:Ns)';
denominator =  sum( autocorr(1:Ns-1,1).^2 ./ flip(weight) ) + autocorr(Ns,1)^2 + sum( autocorr(1:Ns-1,1).^2 ./ weight );
nominator = autocorr(Ns,1)^2;
    
in_new = nominator / denominator  ;
%in = 10*log10( autocorr(1,1)^2 / sum(autocorr.^2) );
in_mod = mean(inco);

weight = [(Ns:-1:2)';1;(2:Ns)'];
in_may = autocorr(Ns) / sum( autocorr./weight );
%autocorr(Ns)
%sum(autocorr)