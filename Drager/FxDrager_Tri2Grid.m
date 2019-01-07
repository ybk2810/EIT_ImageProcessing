function [Image] = FxDrager_Tri2Grid(Element,Node,Sigma,nPixel)
% input
%   Element : FEM Face
%   Node    : FEM Node
%   Sigma   : FEM Face value
% output
%   Image   : Grid Image

if nargin < 4
    nPixel = 256;
end

meshsize = max(max(abs(Node)))*1.05; % depend on original Image
for i = 1:size(Element,1)
    xy(i,:) = mean(Node(Element(i,1:3),:));
end

% ti = -meshsize:(2*meshsize)/(nPixel-1):meshsize;

max_x = max(Node(:,1));
max_y = max(Node(:,2));
Pixel_size = max_x*2/nPixel;
ti_x = -max_x:Pixel_size:max_x;
ti_y = -(ceil(max_y/Pixel_size)*Pixel_size):Pixel_size:(round(max_y/Pixel_size)*Pixel_size);
[qx,qy] = meshgrid(ti_x,ti_y);

if length(Element) ~= size(Sigma,1)
    Sigma = Sigma';
end

for i = 1:size(Sigma,2)
    F = TriScatteredInterp(xy(:,1),xy(:,2),Sigma(:,i));
%     F = scatteredInterpolant(xy(:,1),xy(:,2),Sigma(:,i)); % higher v.
    Image(:,:,i) = F(qx,qy);
    disp([num2str(i) ' / ' num2str(size(Sigma,2))]);
end
end