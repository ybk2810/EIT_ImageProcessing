function [cmap] = FxImage_Cmap(option)
    if(nargin == 0)
        option = 4;
    end
    cname = strcat('Cmap',num2str(option));
    cmap = load(cname);
%     eval(strcat('colormap(',cname,')'));
end