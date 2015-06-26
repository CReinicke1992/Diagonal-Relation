%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE 
% * Transform 3d blending matrix to 2d blending matrix

% INPUT
% * g3d:    3d blending matrix: Soure x Experiment x Time, 
%           each element is 1 or 0

% OUTPUT
% * g2d:    2d blending matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function g2d = g3dto2d(g3d)

[Ns,Ne,~] = size(g3d);

g2d = zeros(Ns,Ne);

for src = 1:Ns
    for exp = 1:Ne
        ind = find( g3d(src,exp,:) == 1 );
        if isempty(ind) == 1
            g2d(src,exp) = 0;
        else
            g2d(src,exp) = ind;
        end
        clear ind
    end 
end

