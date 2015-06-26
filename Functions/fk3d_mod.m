%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT PARAMETERS
% * data:       3D or 5D data matrix in space-time
% * mask:       3D or 5D fk mask
% * Nri:        Number of receivers per inline = Number of crosslines
% * Nsi:        Number of sources per inline   = Number of crosslines

% OUTPUT
% * FK filtered data, the dimensions (3D or 5D) of the output data are
%   equal to the dimensions of the input data

% ANNOTATIONS
% * The fk mask should be designed in the same way as it is done by the
%   function 'fkmask5d.m'
% * The format of the input data must be either in the 'Delphi' or in the
%   'Cartesian' format
%%%%%%%%%%%%%%%%%%%%%%%%%%%

function filtered = fk3d_mod(data,mask,Nri,Nsi)

if     ( (ndims(data) ~= 3) && (ndims(data) ~= 5)  ) || ...
       ( (ndims(mask) ~= 3) && (ndims(mask) ~= 5)  )

    error('The input data and mask must be 3D or 5D objects.');
end


% Check if trans_5D_3D.m is available
if exist('trans_5D_3D.m','file') ~= 2
   error('fk3d_mod.m requires the function trans_5D_3D.m'); 
end

% FK filter the data in cartesian domain (5D) and bring it back to its
% input format 
if (ndims(data) == 5) && (ndims(mask) == 5)
    Data = fftn(data); clear data
    filtered = mask .* Data;
    filtered = real( ifftn(filtered) );
    
elseif (ndims(data) == 3) && (ndims(mask) == 5)
    data = trans_5D_3D(data,Nri,Nsi);
    Data = fftn(data); clear data
    filtered = mask .* Data;
    filtered = real( ifftn(filtered) );
    
    % Go back to Delphi format (3D)
    filtered = trans_5D_3D(filtered);
    
elseif (ndims(data) == 5) && (ndims(mask) == 3)
    mask = trans_5D_3D(mask,Nri,Nsi);
    Data = fftn(data); clear data
    filtered = mask .* Data;
    filtered = real( ifftn(filtered) );
    
else
    data = trans_5D_3D(data,Nri,Nsi);
    mask = trans_5D_3D(mask,Nri,Nsi);
    Data = fftn(data); clear data
    filtered = mask .* Data;
    filtered = real( ifftn(filtered) );
    
    % Go back to Delphi format (3D)
    filtered = trans_5D_3D(filtered);
end
    










