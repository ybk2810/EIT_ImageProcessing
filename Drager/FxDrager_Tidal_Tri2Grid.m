function [Image] = FxDrager_Tidal_Tri2Grid(Element,Node,Sigma,nPixel,j)
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

ti = -meshsize:(2*meshsize)/(nPixel-1):meshsize;

[qx,qy] = meshgrid(ti,ti);

if length(Element) ~= size(Sigma,1)
    Sigma = Sigma';
end

    F = TriScatteredInterp(xy(:,1),xy(:,2),Sigma(:,1));
%     F = scatteredInterpolant(xy(:,1),xy(:,2),Sigma(:,i)); % higher v.
    Image(:,:,j) = F(qx,qy);
    disp([num2str(j) ' / ' num2str(size(Sigma,2))]);
end