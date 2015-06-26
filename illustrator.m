

% Make functions available
addpath('Incoherency-Functions');


%% Create a 2d blending matrix

% Parameters
Ns  = 105;      % Number of sources
b   = 5;        % Blending factor
dt  = 0.002;    % Sampling rate: Seconds per sample
tg  = 100;      % Maximum time delay in time samples
Nt  = 201;      % Number of time samples
pattern = 0;    % Blending pattern (Time + Space)

% Patterns:
% 0     Time
% 1     Time Space Experiment
% 2     Time Space 
% 3     Space
% 4     None

[G3,g3] = crane(Ns,Nt,b,tg,pattern);

%% Compute incoherency & autocorrelation

[in,auto] = incoherency3d(g3);
[in_mod,auto_mod] = incoherency3d_mod(g3);



%% Compute GGH, sum along diagonals, and sum over all frequency components

% Initialize matrix to save the sums along diagonals for each frequency
% component separately
diagsum = zeros(Ns,Nt);

% Iterate over all frequency components
for w = 1:size(G3,3)
    
    % Compute G*Gh
    G = squeeze( G3(:,:,w) );
    Gh = G';
    GGH = G*Gh;
    
    % Sum along diagonals
    % Save the result in diagsum
    for dia = 1:Ns
        diagsum(dia,w) = sum(diag(GGH,dia-1));
    end
   
end

% Sum over all frequency components
% Ideally the output is the autocorrelation with respect to source lag
autocorr = sum(diagsum,2);

figure(1); plot(real( autocorr(1:53,1)/norm(autocorr(1:53,1)) ));

%% Extract the autocorrelation with respect to source lag from the 3d autocorrelation matrix


[~,t] = max(max(max(auto)));
[~,exp]     = max(max(auto(:,:,t)));

auto_src = squeeze( auto(1:53,exp,t) );
figure(2); plot(real( auto_src/norm(auto_src) ));

%% Extract the autocorrelation with respect to source lag from the modified 3d autocorrelation matrix


[~,t] = max(max(max(auto_mod)));
[~,exp]     = max(max(auto_mod(:,:,t)));

auto_src = squeeze( auto_mod(53:end,exp,t) );
figure(3); plot(real( auto_src/norm(auto_src) ));

%% Difference: Diagonal autocorrelation - modified autocorrelation

figure(4); plot( (real( auto_src/norm(auto_src) ) - real( autocorr(1:53,1)/norm(autocorr(1:53,1)) )) / real( auto_src/norm(auto_src) ) );

