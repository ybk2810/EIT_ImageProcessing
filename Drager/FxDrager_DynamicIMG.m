function [ Drager_DynamicIMG ] = FxDrager_DynamicIMG( Drager_ChangeRef, Data )
Drager.Dynamic_sigma = Drager_ChangeRef.EIT_2_sigma;
% figure; patch('Faces',Data.Element,'Vertices',Data.Node,'FaceVertexCData',Drager4.sigma,'FaceColor','flat','EdgeColor','None');
% axis equal; caxis([-abs(imgscale) abs(imgscale)]); axis off; colormap(Cmap);

x_max = max(Data.Node(:,1)); x_min = min(Data.Node(:,1)); % x
y_max = max(Data.Node(:,2)); y_min = min(Data.Node(:,2)); % y
x_mean = (x_max+x_min)/2; y_mean = (y_max+y_min)/2;
Data.Node2(:,1) = Data.Node(:,1) - x_mean;
Data.Node2(:,2) = Data.Node(:,2) - y_mean;

Drager.Dynamic_IMG = FxDrager_Tri2Grid(Data.Element, Data.Node2, Drager.Dynamic_sigma, 256);
% figure; imagesc(Drager4.Image(:,:)); axis image; caxis([-abs(imgscale) abs(imgscale)]); colormap(Cmap);
% set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);

Drager.Dynamic_IMG_NaN = Drager.Dynamic_IMG;
Drager.Dynamic_IMG_NaN(isnan(Drager.Dynamic_IMG_NaN)) = 0;

Drager_DynamicIMG = Drager;
end

