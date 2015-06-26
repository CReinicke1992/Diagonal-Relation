% ISSUE
% * Introduce some tuning paramter which allows to widen and tighten the fk
%   mask. This would be very helpful to adatp the fk mask to the data at
%   hand
% * This program could not handle too large source spacing.
%   Thus I introduced
% 
% if nkx > Nsx
%     nkx = Nsx;
% end
% 
% if nki > Nsi
%     nki = Nsi;
% end
%
% This seems to work but I am not entirely sure if it is doing the correct
% thing!


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
% * data: 3D or 5D data cube
% * dt:   Duration of a time sample in seconds
% * dx:   Source crossline spacing in metres
% * di:   Source inline spacing in metres
% * fcut: Cut off frequency in hertz
% * dim:  For a 2D fk filter (frequency & crossline) set dim to 2,
%         for a 3D fk filter (frequency, crossline & inline) set dim to 3
% * tune: A tuning factor allows to modify the minimum velocity by a factor
%         'tune' which in turn tightens or widens the fk signal cone
% * Nri:  If 3D data is input, the number of inline receivers must be
%         specified
% * Nsi:  If 3D data is input, the number of inline sources must be
%         specified
% * fmin: Low cut off frequency in Hz

% * This function uses the function 'trans_5D_3D.m', thus make sure the
%   functions are in the same folder


% OUTPUT
% * 3D or 5D Fk filter mask, the output dimension is chosen based on the 
%   dimension of the input data 

% ASSUMPTION
% * Minimum velocity is 1500m/s (water)
% * I changed th minimum velocity to 500 because otherwise the filter is
%   too severe for the data to which I applied it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function mask = fkmask5d(data,dt,dx,di,fcut,dim,tune,Nri,Nsi,fmin)


%% STABILITY CHECKS & PREPARATION FOR THE MASK 

% Set a control parameter, which is used for the output format of the mask
input = 5;

% If 3D data is input, fkmask5d transforms it to 5D builds a mask and
% transforms it back
if ndims(data) == 3
    
    input = 3;
    
    % The number of inline receivers and sourcs must be specified
    if nargin < 9
        m1 = 'If you input 3D data in fkmask5d you must specify the ';
        m2 = ' number inline receivers and sources. ';
        m3 = ' In addition you must specify a tuning factor which ';
        m4 = ' is multiplied with the minimum velocity to widen or ';
        m5 = ' tighten the fk signal cone. A tuning factor of 1 keeps the ';
        m6 = ' signal cone unchanged.';
        message = strcat(m1,m2,m3,m4,m5,m6);
        error(message);
    end
    
    % Check if the function 'trans_5D_3D' is available
    if exist('trans_5D_3D.m','file') ~= 2
        m1 = 'fkmask5d.m requires the function trans_5D_3D to build the ';
        m2 = ' fk filter for a 3D data cube.';
        message = strcat(m1,m2);
        error(message);
    end
    
    data = trans_5D_3D(data,Nri,Nsi);
end

% Dimension check
if ndims(data) ~= 5
    error('fkmask5d expects a 3D or 5D data cube.')
end

% Set a default fk mask: Frquency and crossline fk mask
if nargin < 6
   dim = 2; 
end

if (dim ~= 2) && (dim ~= 3)
   m1 = 'For a 2D fk mask (frequency and crossline) set dim to 2. For a ';
   m2 = ' 3D fk mask (frequency, crossline and inline) set dim to 3.';
   message = strcat(m1,m2); clear m1 m2
   error(message); 
end

% Set a default tuning factor
if nargin < 7
   tune = 1; 
end

% Set a default low cut frequency
if nargin < 10
    fmin = 0;
end

% Dimensions
[Nf,Nrx,Nri,Nsx,Nsi] = size(data);
mask = zeros(Nf,Nrx,Nri,Nsx,Nsi,'single');

% Parameters for the signal cone (in SI units):
% * Minimum velocity in the data
% * Frequency step size
% * Convert cut off frequency from hertz to samples
% * Wavenumber step size in cross- and inline direction
vmin = 1500*tune;   df = 1/(dt*Nf);             dkx = 2*pi/(dx*Nsx);
                    fcut = round(fcut/df);      dki = 2*pi/(di*Nsi);
                    fmin = 1 + round(fmin/df);

if fcut >= Nf/2
   m1 = 'The input cut off frequency is too large. Choose a cut off ';
   m2 = ' frequency, which fullfills the condition fcut * dt < 0.5.';
   error(strcat(m1,m2));
end


%% BUILD THE MASK

% Loop over all receivers to consider all CRGs
for rx = 1:Nrx
    for ri = 1:Nri
        % Loop over all frequency slices up to the cut off frequency
        for f = fmin:fcut
            
            kmax = f*df/vmin;       % Unit 1/m
            nkx  = round(kmax/dkx); % Sample number of cut off wavenumber
            nki  = round(kmax/dki);
            
            %%%%%%%%%%%%%%%%%%%%%
            if nkx > Nsx
                nkx = Nsx;
            end
            
            if nki > Nsi
                nki = Nsi;
            end
            %%%%%%%%%%%%%%%%%%%%%
            
            if dim == 2
                mask(f,rx,ri,1:nkx,:)         = 1;
                mask(f,rx,ri,end-nkx+1:end,:) = 1;
                mask(Nf-f+1,rx,ri,:,:) = mask(f,rx,ri,:,:);
            else
                
                % Filter k values larger than kmax
                [Ki,Kx]   = meshgrid( linspace(0,kmax,nki),linspace(0,kmax,nkx) );
                k         = sqrt(Ki.^2 + Kx.^2);
                k(1,1)    = 0.5*kmax; % Guarantee: 0 < k(1,1) < kmax
                k(k>kmax) = 0;
                k( k > 0) = 1;
                
                % Swap zeros and ones: Inside the signal cone zeros, outside of
                % the signal cone ones
                k = k + 1; k(k == 2) = 0;
                
                % Create a temporary mask masktmp which has zeros within the
                % signal cone and ones outside of the signal cone
                masktmp = ones(Nsx,Nsi,'single');
                masktmp(1:nkx, 1:nki)         = k;
                masktmp(1:nkx, Nsi-nki+1:end) = masktmp(1:nkx, Nsi-nki+1:end).*k(:,end:-1:1);
                masktmp(Nsx-nkx+1:end, 1:nki) = masktmp(Nsx-nkx+1:end, 1:nki).*k(end:-1:1,:);
                masktmp(Nsx-nkx+1:end, ...
                    Nsi-nki+1:end)        = masktmp(Nsx-nkx+1:end, Nsi-nki+1:end).*k(end:-1:1,end:-1:1);
                
                % Swap zeros and ones: Inside the signal cone ones, outside of
                % the signal cone zeros
                masktmp = masktmp + 1; masktmp(masktmp == 2) = 0;
                
                mask(f,rx,ri,:,:) = masktmp; clear masktmp
                mask(Nf-f+1,rx,ri,:,:) = mask(f,rx,ri,:,:);
            end
        end
    end
end

%% FORMAT THE OUTPUT MASK

% If a 3D data cube is input, fk5d outputs a 3D mask
if input == 3
    mask = trans_5D_3D(mask);
end



