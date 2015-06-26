%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Tailored version of the 4d cross correltation.
% * Compute special 4d cross correltation
% * This function is designed to compute the 3d cross correlation of 4d input
%   array g. This is done by 'skipping' the cross correlation of the 3rd
%   dimension. 
% * For a general 4d cross correltation use 'xcorr4.m'

% INPUT
% * g:      4d array, which is the blending matrix of a 3d acquisition set
%           up.

% OUTPUT
% * out:    3d auto correlation of the input array g.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function out = xcorr4_mod(g)


% xcorr4_mod performs 4d cross correlation, thus is expects 4d input arrays
if ndims(g) ~= 4
    error('xcorr4_mod.m expects a 4d input array.'); 
end

% Dimension g
[Nsx,Nsi,~,Nt] = size(g);

% Squeeze the 3rd dimension 
g3 = sum(g,3); % this is only valid if each source is fired only once!!
g3 = reshape(g3(:,:,1,:),Nsx,Nsi,Nt);

% Flip the array g3 manually, this enables us to use the Matlab function
% convn which computes n dimensional concolutions
g3_rev = g3(end:-1:1, end:-1:1, end:-1:1);

% I think I can simply take the complex conjugated to complete the
% cross-correlation. However, I am not sure if this is mathematically
% correct.
g3_rev = conj(g3_rev);

% Compute 3d cross correlation
out = convn(g3,g3_rev,'same');






