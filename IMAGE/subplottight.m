function h = subplottight(n,m,i,op)
if nargin < 4
    [c,r] = ind2sub([m n], i);
    if length(i) > 1
        length_m = max(c)-min(c)+1;
        length_n = max(r)-min(r)+1;
        ax = subplot('Position', [(min(c)-1)/m, (1-(max(r))/n), length_m/m, length_n/n]);
    else
        ax = subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n]);
    end
    
    if(nargout > 0)
        h = ax;
    end
elseif op == 1
    [c,r] = ind2sub([m n], i);
    if length(i) > 1
        length_m = max(c)-min(c)+1;
        length_n = max(r)-min(r)+1;
        ax = subplot('Position', [(min(c)-1)/m*1.1, (1-(max(r))/n*0.9), length_m/m*0.9, length_n/n*0.8]);
    else
        ax = subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n]);
    end
    
    if(nargout > 0)
        h = ax;
    end
elseif op == 2
    [c,r] = ind2sub([m n], i);
    if length(i) > 1
        length_m = max(c)-min(c)+1;
        length_n = max(r)-min(r)+1;
        ax = subplot('Position', [(min(c)-1)/m+0.1, (1-(max(r))/n), length_m/m*1, length_n/n]);
    else
        ax = subplot('Position', [(c-1)/m+0.1, 1-(r)/n, 1/m, 1/n]);
    end
    
    if(nargout > 0)
        h = ax;
    end
end


% function h = subplottight(n,m,i)
% [c,r] = ind2sub([m n], i);
% if length(i) > 1
%     length_m = max(c)-min(c)+1
%     length_n = max(r)-min(r)+1
%     ax = subplot('Position', [(min(c)-1)/m*1.1, (1-(max(r))/n*0.9), length_m/m*0.9, length_n/n*0.8])
% else
%     ax = subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n])
% end
%
% if(nargout > 0)
%     h = ax;
% end