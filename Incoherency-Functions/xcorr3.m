%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE
% * Compute 3d cross correltation

% INPUT
% * A,B:    One or two 3d arrays

% OUTPUT
% * out:    3d cross correlation if two arrays A and B are input 
%           3d autocorrelation if one array A is input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function out = xcorr3(A,B)

% If there is only one input array, xcorr3 performs an autocorrelation
if nargin < 2
   B = A; 
end

% xcorr3 performs 3d cross correlation, thus is expects 3d input arrays
if (ndims(A) ~= 3) || (ndims(B) ~= 3)
   error('xcorr3.m expects 3d input arrays.'); 
end

% Flip the array B manually, this enables us to use the Matlab function
% convn which computes n dimensional concolutions
Br = B(end:-1:1,end:-1:1,end:-1:1);

% I think I can simply take the complex conjugated to complete the
% cross-correlation. However, I am not sure if this is mathematically
% correct.
Br = conj(Br);

% Compute 3d cross correlation
out = convn(A,Br,'same');






