%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE 
% * Compute the norm of a 4d array

% INPUT
% * array4d:    4d array

% OUTPUT
% * out:        Norm of the input array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function out = norm4(array4d)

if ndims(array4d) ~= 4
    error('norm4.m expects a 4d array as input.')
end

out = sqrt( sum(sum(sum(sum(  abs(array4d).^2  )))) );