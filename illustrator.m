

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

in1_240 = zeros(20,1);
in1_250 = zeros(20,1);
in2_240 = zeros(20,1);
in2_250 = zeros(20,1);

for iter = 1:1
for tg = [240,250]
    

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
        
    inco(1,w) = Ns / sum(diagsum(:,w));
   
end

% Sum over all frequency components
% Ideally the output is the autocorrelation with respect to source lag
autocorr = sum(diagsum,2);

figure(1); plot( autocorr(:,1) ); title('autocorrelation for summed frequencies');
figure(2); plot( diagsum(:,3) ); title('autocorrelation of w = 3');
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

nominator = autocorr(Ns,1);
autocorr(Ns,1) = 0;
denominator = sum( autocorr.^2 );
in2 = nominator/denominator; 
in1 = 1/in2;

if tg == 240
    in1_240(iter,1) = in1;
end

if tg == 250
    in1_250(iter,1) = in1;
end

if tg == 240
    in2_240(iter,1) = in2;
end

if tg == 250
    in2_250(iter,1) = in2;
end

end
end

[mean(in1_240), mean(in1_250)]
[mean(in2_240), mean(in2_250)]