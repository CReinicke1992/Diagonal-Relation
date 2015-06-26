%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
% * Data matrix either 5D or 3D
%
% OUTPUT
%       -> 5D matrix time x receiver crossline x receiver inline x source
%                    crossline x source inline
%          The matrix is transformed to a 3D matrix where each submatrix
%          corresponds to a constant inline value for source and receiver
%       -> 3D matric time x receiver inline x source inline
%          The matrix is transformed to a 5D matrix where the 5
%          dimesensions correspond to time, receiver crossline, receiver
%          inline, source crossline, source inline

% The data sorting is based on the article '1page_vanDedemThesisTUDelft.pdf'

function out = trans_5D_3D(p,Nri,Nsi)



% 5D to 3D
if ndims(p) == 5
   [Nt,Nrx,Nri,Nsx,Nsi] = size(p);
   out = reshape( p, Nt, Nrx*Nri, Nsx*Nsi );

% The commented code does the transformation without reshape(). It looks
% more complicated but it helps to understand how the sorting is performed. 
% The commented part is slightly slower than reshape().

%    out = zeros(Nt,Nrx*Nri,Nsx*Nsi,'single');
%    for si = 1:Nsi
%        for ri = 1:Nri
%            out(:,1+(ri-1)*Nrx : ri*Nrx, 1+(si-1)*Nsx : si*Nsx ) = ...
%                p(:,:,ri,:,si);
%        end
%    end
   

% 3D to 5D
elseif ndims(p) == 3
    [Nt,Nr,Ns] = size(p);
    
    % Ask for Nri and Nsi
    if nargin ~= 3
       m1 = 'In order transfer 3D data to 5D data the number of inline ';
       m2 = ' receivers Nri and sources Nsi must be specified.';
       message = strcat(m1,m2); clear m1 m2
       error(message);
    end
    
    % Dimension check
    if (mod(Nr,Nri) ~= 0) || (mod(Ns,Nsi) ~= 0)
        m1 = 'The input number of inline receivers / sources conflicts ';
        m2 = ' with the total number of receivers / sources. The ';
        m3 = ' number of inline receivers / sources must be a divider ';
        m4 = ' of the total number of receivers / sourcs.';
        message = strcat(m1,m2,m3,m4); clear m1 m2 m3 m4
        error(message)
    end
    
    Nrx = Nr/Nri;   Nsx = Ns/Nsi;
    out = reshape( p,Nt,Nrx,Nri,Nsx,Nsi );
    
% The commented code does the transformation without reshape(). It looks
% more complicated but it helps to understand how the sorting is performed. 

%     out = zeros(Nt,Nrx,Nri,Nsx,Nsi,'single');
    
%     for si = 1:Nsi
%        for ri = 1:Nri
%            out(:,:,ri,:,si) = ...
%                p(:,1+(ri-1)*Nrx : ri*Nrx, 1+(si-1)*Nsx : si*Nsx);
%        end
%     end
    
    
else
    % In case of incorrect input.
    m1 = 'The function trans_5D_3D only transfers 5D data matrices to 3D';
    m2 = ' data matrices and vice versa. Other dimensions cannot be';
    m3 = ' transformed.';
    message = strcat(m1,m2,m3); clear m1 m2 m3 
    error(message);
end
