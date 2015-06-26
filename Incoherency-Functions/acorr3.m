%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE
% * Compute 3d auto-correltation

% INPUT
% * A:      3d array

% OUTPUT
% * corr:   3d auto-correlation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function corr = acorr3(a)

% acorr3 performs 3d auto-correlation, thus it expects 3d input array
if ndims(a) ~= 3
   error('acorr3.m expects 3d input arrays.'); 
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






