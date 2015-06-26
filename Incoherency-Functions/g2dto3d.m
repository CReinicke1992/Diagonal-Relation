%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE 
% * Transform 2d gamma matrix to 3d gamma matrix

% INPUT
% * g2d:    2d gamma matrix: Soure x Experiment
% * t_g:    Shooting window

% OUTPUT
% * g3d:    3d gamma matrix: Soure x Experiment x Time Ns x Ne x t_g
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




function g3d = g2dto3d(g2d,t_g)

[Ns,Ne] = size(g2d);

if norm(round(g2d) - g2d) ~= 0
    error('g2dto3d.m expects a blending matrix g2d with integer entries.');
end


g3d = zeros(Ns,Ne,t_g);

for src = 1:Ns
    for exp = 1:Ne
        ind = g2d(src,exp);
        if ind ~= 0
            g3d(src,exp,ind) = 1;
        end 
    end
end

