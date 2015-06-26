% Locarion: /Users/christianreinicke/Dropbox/MasterSemester/SyntheticData/Deblending/Functions
% It is assumed that this function is called from the folder 'Deblending'
% The function loads data, fkmask and parameters automatically
% The input variables should allow to use different blending designs

% INPUT



function debl = blend_deblend(g,path)

%% 1 Load data

% For simplicity load only a small part of the data
% Load the bandlimited data in Delphi format
fileID  = 'Data/Data_red_Delphi_Bandlimited.mat';
my_data = load(fileID); clear fileID
data    = my_data.data_fil3d; clear my_data

%% 2.1 Load general parameters

% Load the paramteres which belong to the loaded data, in this case it is
% the reduced data
fileID = '../Parameters_red.mat';
Parameters_red = load(fileID); clear fileID


Nt   = Parameters_red.Nt;    % Number of time samples
Nri  = Parameters_red.Nri;   % Number of inline receivers
Nsi  = Parameters_red.Nsi;   % Number of inline sources
Nr   = Parameters_red.Nr;    % Number of receivers
Ns   = Parameters_red.Ns;    % Number of sources

%% 2.2 Load Blending Parameters

fileID    = 'Data/Blending_parameters.mat';
blend_par = load(fileID); clear fileID
pattern   = blend_par.pattern;  % Blending pattern
b         = blend_par.b;        % Blending factor
clear blend_par

% Set a default path according to blending pattern
if nargin < 2
    if pattern == 0;
        path = '/3Time/';
    elseif pattern == 1;
        path = '/4Space-Time-Experiment/';
    elseif pattern == 2;
        path = '/5Space-Time-Crossline/';
    elseif pattern == 3;
        path = '/2Space-Crossline/';
    elseif pattern == 4;
        path = '/1None/';
    elseif pattern == 5;
        path = '/6Space-Time-Fully/';
    end
end

%% 3 Load the FK mask

% Load the fkmask which is in Cartesian format
fileID = 'Data/FK/fkmask_red.mat';
FKmask = load(fileID); clear fileID
fkmask = FKmask.mask; clear Fkmask

%% 4 Pad data with zeros to avoid wrap arounds in time

% Maximum time shift
pad = max(g(:)); 

% As inititally the function deblend.m expected an even t_g, I use an even
% pad number to avoid stupid errors.
if mod(pad,2) ~= 0
    pad = pad + 1;
end

% Update Nt
NT = Nt + pad;

% Append zeros to the data
p_new           = zeros(NT,Nr,Ns,'single');
p_new(1:Nt,:,:) = data;
data            = p_new; clear p_new;


%% 5 BLENDING

% Blend
data_bl = blend(data,g); 
save(strcat('Data',path,'Blended.mat'),'data_bl');

%% 6 DEBLENING

%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREPARATION

% Step 1: Pseudo deblend
data_ps = blend(data_bl,-g',1/b); clear data_bl

% Throw away data which cannot be correct
data_ps(Nt+1:end,:,:) = 0;
save(strcat('Data',path,'Pseudo-Deblended.mat'),'data_ps');

% First estimate of the deblended data p
p = data_ps;

% Maximum value for thresholding
max_val = max(abs( p(:) )); 
%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%
% ITERATIONS

% Number of iterations
Niter = 100; 

for iter = 1:Niter
    
    %disp([' iteration: ',num2str(iter)]);
    
    % Step 2: fk filter in the receiver domain
    p(1:Nt,:,:) = fk3d_mod(p(1:Nt,:,:),fkmask,Nri,Nsi);
    
    % Step 3: Threshold, the treshold goes down to zero after all iterations
    % threshold = max_val - max_val/Niter * iter; 
    threshold = max_val * 0.9^(iter);
    p(abs(p)<threshold) = 0;
    
    % Throw away data which cannot be correct
    p(Nt+1:end,:,:) = 0;
    
    % Step 4: estimate noise
    n = blend(blend(p,g),-g',1/b) - p;
    
    % Step 5: subtract noise from pseudo deblended result
    p = data_ps - n;
    
    % Throw away data which cannot be correct
    p(Nt+1:end,:,:) = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_ps n g

% Output the deblended data
debl = p(1:Nt,:,:); clear p
save(strcat('Data',path,'Deblended.mat'),'debl')

% Absolute error of the deblended data
misfit = data(1:Nt,:,:) - debl;
save(strcat('Data',path,'Misfit_data-debl.mat'),'misfit'); clear misfit

% Quantify the performance of the deblending based on Ibrahim
Q = quality_factor(data(1:Nt,:,:),debl);
save(strcat('Data',path,'QualityFactor.mat'),'Q');

