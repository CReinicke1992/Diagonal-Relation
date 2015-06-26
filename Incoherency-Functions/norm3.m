%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE 
% * Compute the norm of a 3d array

% INPUT
% * array3d:    3d array

% OUTPUT
% * out:        Norm of the input array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function out = norm3(array3d)

if ndims(array3d) ~= 3
    error('norm3.m expects a 3d array as input.')
end

out = sqrt( sum(sum(sum(array3d.^2))) );