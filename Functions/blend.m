function [p_bl] = blend(p,g,scale)
% Blend or deblend the data

[Nt,Nr,~] = size(p);
[Ns,Ne]   = size(g);   % Ne number of blended shots

if min(g(:)) >= 0
    % blend
    p_bl = zeros(Nt,Nr,Ne);
    for iexp = 1:Ne
        for ishot = 1:Ns
            % Check all elements of the g matrix, 
            % if the element ~= 0 then 
            % add a shot
            if abs(g(ishot,iexp)) ~= 0
                
                it = g(ishot,iexp); % Delay time in terms of samples
                
                % Shift the data of by a certain number of time samples
                p_bl(:,:,iexp) = p_bl(:,:,iexp) + [ zeros(it-1,Nr);...
                                                    p(1:Nt-(it-1),:,ishot) ];
            end
        end
    end
    
else
    % If g has negative entries, the function blend will perform pseudo
    % deblending P'*g^H?
    % pseudo deblend
    p_bl = zeros(Nt,Nr,Ne);
    % As we input g' instead of g this Ne differs from the Ne in the if
    % condition
    for iexp = 1:Ne
        for ishot = 1:Ns
            % Check all elements of the g matrix, 
            % if the element ~= 0 then 
            % add a shot
            if max(abs(g(ishot,iexp))) ~= 0
                it = -g(ishot,iexp); % Compared to the if condition there is a minus sign in front of g
                p_bl(:,:,iexp) = p_bl(:,:,iexp) + ...
                    [p(it:Nt,:,ishot);zeros(it-1,Nr)];
            end
        end
    end    
end

% apply scaling to blending matrix
if nargin == 3
    p_bl = scale * p_bl;   
end
