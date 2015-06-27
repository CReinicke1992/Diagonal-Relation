
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PURPOSE
% * Quantify the incoherency of a blending matrix based on the diagonals of
%   GGH 

% INPUT
%   * g2d:    2d blending matrix
%   * Nt:     Number of time samples

% OUTPUT
%   * Incoherency value between 0 and 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function in = incoherency_dia(g2d,Nt)

%% Generate Gamma matrices for each frequency component

[Ns,Ne] = size(g2d);
g3 = zeros(Ns,Ne,Nt);

for src = 1:Ns
    for exp = 1:Ne
        if g2d(src,exp) ~= 0
            ind = g2d(src,exp);
            g3(src,exp,ind) = 1;
        end
    end
end

G3 = fft(g3,[],3);

%% Compute GGH, sum along diagonals, and sum over all frequency components

% Initialize matrix to save the sums along diagonals for each frequency
% component separately
diagsum = zeros(2*Ns-1,Nt);

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
    
end

%% Compute incoherency

% Sum over all frequency components
% Ideally the output is the autocorrelation with respect to source lag
autocorr = sum(diagsum,2);

% Quantifiy incoherency
in = autocorr(Ns,1)^2 / sum(autocorr.^2);
