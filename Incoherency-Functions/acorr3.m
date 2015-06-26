%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE
% * Compute 4d auto-correltation

% INPUT
% * A:      4d array

% OUTPUT
% * corr:   4d auto-correlation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function corr = acorr4(a)

% acorr4 performs 4d auto-correlation, thus it expects 4d input array
if ndims(a) ~= 4
   error('acorr4.m expects 4d input arrays.'); 
end

a = single(a);
dim = size(a);

pad = 2*dim - 1;
A = fftn(a,pad); clear a pad
Corr = A .* conj(A); clear A
corr = ifftn(Corr,dim); clear Corr dim 

% Alternatively one can use corr = ifftn(Corr)
% In that case the incoherency values are slightly different. They spread
% over a larger range but the computation requires more effort.
% Thus, I suggest to use corr = ifftn(Corr,dim);






