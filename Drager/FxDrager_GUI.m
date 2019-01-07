function [ Drager4 ] = FxDrager_GUI( sigma, imgscale, Data, Cmap )
Drager4.imgscale = imgscale;
Drager4.sigma = sigma;

% figure; 
% patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,Drager4.sigma,'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
% axis equal; caxis([-abs(Drager4.imgscale) abs(Drager4.imgscale)]); axis off; colormap(Cmap);

Drager4.x_max = max(Data.Node(:,1)); Drager4.x_min = min(Data.Node(:,1)); % x
Drager4.y_max = max(Data.Node(:,2)); Drager4.y_min = min(Data.Node(:,2)); % y

Drager4.x_mean = (Drager4.x_max+Drager4.x_min)/2;
Drager4.y_mean = (Drager4.y_max+Drager4.y_min)/2;

Data.Node2(:,1) = Data.Node(:,1) - Drager4.x_mean;
Data.Node2(:,2) = Data.Node(:,2) - Drager4.y_mean;

Drager4.Image = FxDrager_Tri2Grid(Data.Element, Data.Node2, Drager4.sigma, 256);
% figure;
% imagesc(Drager4.Image(:,:)); axis image; caxis([-abs(Drager4.imgscale) abs(Drager4.imgscale)]);  colormap(Cmap);
% set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);

Drager4.Image_NaN = Drager4.Image;
Drager4.Image_NaN(isnan(Drager4.Image_NaN)) = 0;

%% ROI setting1
ROI_X_size = size(Drager4.Image,2);
ROI_Y_size = size(Drager4.Image,1);
Drager4.ROI1.first = sum(sum(Drager4.Image_NaN(ROI_Y_size/2/2*3+1:ROI_Y_size,:)));
Drager4.ROI1.second = sum(sum(Drager4.Image_NaN(ROI_Y_size/2+1:ROI_Y_size/2/2*3,:)));
Drager4.ROI1.third = sum(sum(Drager4.Image_NaN(ROI_Y_size/2/2+1:ROI_Y_size/2,:)));
Drager4.ROI1.fourth = sum(sum(Drager4.Image_NaN(1:ROI_Y_size/2/2,:)));

Drager4.plot_x = ones(1,size(Drager4.Image,2)); Drager4.plot_x = Drager4.plot_x*ROI_Y_size/2;
Drager4.plot_y = ones(1,size(Drager4.Image,2)); Drager4.plot_y = Drager4.plot_y*ROI_X_size/2;

% subplot(6,6,13)
% imagesc(Drager4.Image(:,:)); axis image; caxis([-abs(Drager4.imgscale) abs(Drager4.imgscale)]);  colormap(Cmap);
% set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
% hold on; plot(Drager4.plot_x,'r','LineWidth',2); 
% plot(Drager4.plot_x+round(ROI_Y_size/2/2),'r','LineWidth',2); 
% plot(Drager4.plot_x-round(ROI_Y_size/2/2),'r','LineWidth',2);

%% ROI setting2
Drager4.ROI2.first = sum(sum(Drager4.Image_NaN(ROI_Y_size/2+1:ROI_Y_size,1:round(ROI_X_size/2))));
Drager4.ROI2.second = sum(sum(Drager4.Image_NaN(ROI_Y_size/2+1:ROI_Y_size,round(ROI_X_size/2+1):round(ROI_X_size))));
Drager4.ROI2.third = sum(sum(Drager4.Image_NaN(1:ROI_Y_size/2,1:round(ROI_X_size/2))));
Drager4.ROI2.fourth = sum(sum(Drager4.Image_NaN(1:ROI_Y_size/2,round(ROI_X_size/2+1):round(ROI_X_size))));

% subplot(6,6,13)
% imagesc(Drager4.Image(:,:)); axis image; caxis([-abs(Drager4.imgscale) abs(Drager4.imgscale)]);  colormap(Cmap);
% set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
% hold on; plot(Drager4.plot_x,'r','LineWidth',2); stem(round(ROI_X_size/2),ROI_Y_size,'r','LineWidth',2);

%% mask
threshold = 30;
th = min(min(Drager4.Image(:,:)))*threshold*0.01; Drager4.Image_mask = Drager4.Image;
Drager4.Image_mask(Drager4.Image<=th) = 1; Drager4.Image_mask(Drager4.Image>=th) = 0;  clear threshold th;
% imagesc(Drager4.Image_mask(:,:)); axis image; caxis([-1 1]);  colormap(Cmap);
% set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
Drager4.Image2 = Drager4.Image.*Drager4.Image_mask;

Drager4.Image_mask(isnan(Drager4.Image_mask)) = 0;

Drager4.Image_mask2=flip(Drager4.Image_mask);
[~,Indicater_max]=max(max(Drager4.Image_mask2'));
Indicater_max = size(Drager4.Image_mask,1) - Indicater_max;

[~,Indicater_min]=max(max(Drager4.Image_mask'));

Center = round((Indicater_max + Indicater_min)/2);

Drager4.plot_x_ROI3_top = ones(1,size(Drager4.Image,2)); Drager4.plot_x_ROI3_top = Drager4.plot_x_ROI3_top*Indicater_max;
Drager4.plot_x_ROI3_toptocenter = ones(1,size(Drager4.Image,2)); Drager4.plot_x_ROI3_toptocenter = Drager4.plot_x_ROI3_toptocenter*(Indicater_max+Center)/2;
Drager4.plot_x_ROI3_center = ones(1,size(Drager4.Image,2)); Drager4.plot_x_ROI3 = Drager4.plot_x_ROI3*Center;
Drager4.plot_x_ROI3_centertobuttom = ones(1,size(Drager4.Image,2)); Drager4.plot_x_ROI3_centertobuttom = Drager4.plot_x_ROI3_centertobuttom*(Center+Indicater_min)/2;
Drager4.plot_x_ROI3_bottom = ones(1,size(Drager4.Image,2)); Drager4.plot_x_ROI3_bottom = Drager4.plot_x_ROI3_bottom*Indicater_min;

Drager4.Image2_NaN = Drager4.Image2;
Drager4.Image2_NaN(isnan(Drager4.Image2_NaN)) = 0;

%% ROI setting3
Drager4.ROI3.first = sum(sum(Drager4.Image2_NaN((Center+Indicater_max)/2+1:Indicater_max,:)));
Drager4.ROI3.second = sum(sum(Drager4.Image2_NaN(Center+1:(Center+Indicater_max)/2,:)));
Drager4.ROI3.third = sum(sum(Drager4.Image2_NaN((Indicater_min+Center)/2+1:Center,:)));
Drager4.ROI3.fourth = sum(sum(Drager4.Image2_NaN(Indicater_min:(Indicater_min+Center)/2,:)));

subplot(6,6,19)
imagesc(Drager4.Image2(:,:)); axis image; caxis([-abs(Drager4.imgscale) abs(Drager4.imgscale)]); colormap(Cmap);
set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
hold on; plot(Drager4.plot_x_ROI3_center,'r','LineWidth',2); 
plot(Drager4.plot_x_ROI3_top,'r','LineWidth',2); plot(Drager4.plot_x_ROI3_toptocenter,'r','LineWidth',2); 
plot(Drager4.plot_x_ROI3_bottom,'r','LineWidth',2); plot(Drager4.plot_x_ROI3_centertobuttom,'r','LineWidth',2); 

%% ROI setting4
Drager4.ROI4.first = sum(sum(Drager4.Image2_NaN(Center+1:Indicater_max,1:round(ROI_X_size/2))));
Drager4.ROI4.second = sum(sum(Drager4.Image2_NaN(Center+1:Indicater_max,round(ROI_X_size/2+1):round(ROI_X_size))));
Drager4.ROI4.third = sum(sum(Drager4.Image2_NaN(Indicater_min:Center,1:round(ROI_X_size/2))));
Drager4.ROI4.fourth = sum(sum(Drager4.Image2_NaN(Indicater_min:Center,round(ROI_X_size/2+1):round(ROI_X_size))));

% subplot(6,6,13)
% imagesc(Drager4.Image2(:,:)); axis image; caxis([-abs(Drager4.imgscale) abs(Drager4.imgscale)]);  colormap(Cmap);
% set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
% hold on; plot(Drager4.plot_x_ROI3_center,'r','LineWidth',2); stem(round(ROI_X_size/2),ROI_Y_size,'r','LineWidth',2);


end

