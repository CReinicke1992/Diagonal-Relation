%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
% * unbl:   Unblended data in Delphi (3D) or Cartesian (5D) format
% * debl:   Deblended data in Delphi (3D) or Cartesian (5D) format

% OUTPUT
% Q:        Qualtiy factor to quantify the deblending performance
%           Q is computed based on 'Ibraim - Simultaneous source separation
%           using a robust Radon transform'
%           If the input data is acquired with multiple sources AND
%           multiple receivers, Q is a vector where each enty
%           corresponds to one CRG (for Nr<=Ns) or to one CSG (for Nr>Ns) 

% The computation is based on the equation
% Q = 10 *log10( norm(unbl)^2 / norm(unbl-debl)^2 );



function Q = quality_factor(unbl,debl)

%% STABILITY CHECKS & PREPARATION FOR THE CALCULATION OF Q

% Dimension Check
if (ndims(unbl) ~= 5 && ndims(unbl) ~= 3) ...
        || (ndims(debl) ~= 5 && ndims(debl) ~= 3)
    m1 = 'quality_factor.m expects the input unblended and blended data ';
    m2 = ' to be in Delphi (3D) or Cartesian (5D) format. ';
    m3 = ' Delphi format: (t x Nrx*Nri x Nsx*Nsi). ';
    m4 = ' Cartrsian format: (t x Nrx x Nri x Nsx x Nsi).';
    message = strcat(m1,m2,m3,m4);
    error(message);
end

% Check if the function 'trans_5D_3D' is available
if exist('trans_5D_3D.m','file') ~= 2
    m1 = 'quality_factor.m requires the function trans_5D_3D. It is ';
    m2 = ' needed to transform the data from Cartesian (D) to Delphi (3D) ';
    m3 = ' format for the computation of the quality factor';
    message = strcat(m1,m2,m3);
    error(message);
end

% Make sure the blended and unblended data is in Delphi format (3D)
if ndims(unbl) == 5
    unbl = trans_5D_3D(unbl);
end

if ndims(debl) == 5
    debl = trans_5D_3D(debl);
end

% Deblended and unblended must have the same dimensions
if size(debl) ~= size (unbl)
    m1 = 'quality_factor.m expects unblended and deblended input data ';
    m2 = ' of the same dimension.';
    message = strcat(m1,m2);
    error(message);
end


%% Compute the quality factor

[Nt,Nr,Ns] = size(unbl);


if Nr<=Ns
    % Iterate over all CRGs
    Q = zeros(Nr,1);
    for rec = 1:Nr
        unbl_crg = reshape(unbl(:,rec,:),Nt,Ns);
        debl_crg = reshape(debl(:,rec,:),Nt,Ns);
        
        Q(rec,1) = 10 *log10( norm(unbl_crg)^2 / norm(unbl_crg-debl_crg)^2  );
    end
    
elseif Ns<Nr
    
    % Iterate over all CSGs
    Q = zeros(Ns,1);
    for sh = 1:Ns
        unbl_csg = reshape(unbl(:,:,sh),Nt,Nr);
        debl_csg = reshape(debl(:,:,sh),Nt,Nr);
        
        Q(sh,1) = 10 *log10( norm(unbl_csg)^2 / norm(unbl_csg-debl_csg)^2  );
    end
    
end