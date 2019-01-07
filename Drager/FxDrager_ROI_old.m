function [ Drager_ROI ] = FxDrager_ROI_old( Dynamic_sigma, Tidal_sigma, imgscale, Data, Cmap )
% [ ROI ] = FsDrager_ROI( Dynamic_sigma, Tidal_sigma, recount, imgscale, Data, Cmap )

%% Dynamic sigma
Drager.imgscale = imgscale;
Drager.Dynamic_sigma = Dynamic_sigma;
% figure; 
% patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,Drager4.sigma,'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
% axis equal; caxis([-abs(Drager4.imgscale) abs(Drager4.imgscale)]); axis off; colormap(Cmap);

x_max = max(Data.Node(:,1)); x_min = min(Data.Node(:,1)); % x
y_max = max(Data.Node(:,2)); y_min = min(Data.Node(:,2)); % y

x_mean = (x_max+x_min)/2;
y_mean = (y_max+y_min)/2;

Data.Node2(:,1) = Data.Node(:,1) - x_mean;
Data.Node2(:,2) = Data.Node(:,2) - y_mean;

Drager.Image = FxDrager_Tri2Grid(Data.Element, Data.Node2, Drager.Dynamic_sigma, 256);
% figure;
% imagesc(Drager4.Image(:,:)); axis image; caxis([-abs(Drager4.imgscale) abs(Drager4.imgscale)]);  colormap(Cmap);
% set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);

Drager.Image_NaN = Drager.Image;
Drager.Image_NaN(isnan(Drager.Image_NaN)) = 0;

%% Tidal sigma
if size(Tidal_sigma,2) == 1 
    Drager.Tidal_sigma = Tidal_sigma(:,1);
    Drager.Tidal_Image = FxDrager_Tri2Grid(Data.Element, Data.Node2, Drager.Tidal_sigma, 256);
    
    % mask
    threshold = 30;
    th = min(min(Drager.Tidal_Image(:,:)))*threshold*0.01; 
    Drager.Image_mask = Drager.Tidal_Image;
    Drager.Image_mask(Drager.Tidal_Image<=th) = 1; 
    Drager.Image_mask(Drager.Tidal_Image>=th) = 0;  clear threshold th;
    % imagesc(Drager4.Image_mask(:,:)); axis image; caxis([-1 1]);  colormap(Cmap);
    % set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);

    Drager.Image_mask(isnan(Drager.Image_mask)) = 0;

    Drager.Image_mask2=flip(Drager.Image_mask);
    [~,Drager.Indicater_max]=max(max(Drager.Image_mask2'));
    Drager.Indicater_max = size(Drager.Image_mask,1) - Drager.Indicater_max;

    [~,Drager.Indicater_min]=max(max(Drager.Image_mask'));

    Drager.Center = round((Drager.Indicater_max + Drager.Indicater_min)/2);

    Drager.plot_x_ROI3_top = ones(1,size(Drager.Image,2)); Drager.plot_x_ROI3_top = Drager.plot_x_ROI3_top*Drager.Indicater_max;
    Drager.plot_x_ROI3_toptocenter = ones(1,size(Drager.Image,2)); Drager.plot_x_ROI3_toptocenter = Drager.plot_x_ROI3_toptocenter*(Drager.Indicater_max+Drager.Center)/2;
    Drager.plot_x_ROI3_center = ones(1,size(Drager.Image,2)); Drager.plot_x_ROI3_center = Drager.plot_x_ROI3_center*Drager.Center;
    Drager.plot_x_ROI3_centertobuttom = ones(1,size(Drager.Image,2)); Drager.plot_x_ROI3_centertobuttom = Drager.plot_x_ROI3_centertobuttom*(Drager.Center+Drager.Indicater_min)/2;
    Drager.plot_x_ROI3_bottom = ones(1,size(Drager.Image,2)); Drager.plot_x_ROI3_bottom = Drager.plot_x_ROI3_bottom*Drager.Indicater_min;

    Drager.Image2 = Drager.Tidal_Image.*Drager.Image_mask;
    Drager.Image2_NaN = Drager.Image2;
    Drager.Image2_NaN(isnan(Drager.Image2_NaN)) = 0;
    
    ROI_X_size = size(Drager.Image,2);
    ROI_Y_size = size(Drager.Image,1);
    Drager.plot_x = ones(1,size(Drager.Image,2)); Drager.plot_x = Drager.plot_x*ROI_Y_size/2;
    Drager.plot_y = ones(1,size(Drager.Image,2)); Drager.plot_y = Drager.plot_y*ROI_X_size/2;
end

%% ROI setting1
% Drager4.ROI1.first(recount) = sum(sum(Drager4.Image_NaN(ROI_Y_size/2/2*3+1:ROI_Y_size,:)));
% Drager4.ROI1.second(recount) = sum(sum(Drager4.Image_NaN(ROI_Y_size/2+1:ROI_Y_size/2/2*3,:)));
% Drager4.ROI1.third(recount) = sum(sum(Drager4.Image_NaN(ROI_Y_size/2/2+1:ROI_Y_size/2,:)));
% Drager4.ROI1.fourth(recount) = sum(sum(Drager4.Image_NaN(1:ROI_Y_size/2/2,:)));

% subplot(6,6,13)
% imagesc(Drager4.Image(:,:)); axis image; caxis([-abs(Drager4.imgscale) abs(Drager4.imgscale)]);  colormap(Cmap);
% set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
% hold on; plot(Drager4.plot_x,'r','LineWidth',2); 
% plot(Drager4.plot_x+round(ROI_Y_size/2/2),'r','LineWidth',2); 
% plot(Drager4.plot_x-round(ROI_Y_size/2/2),'r','LineWidth',2);

%% ROI setting2
% Drager4.ROI2.first(recount) = sum(sum(Drager4.Image_NaN(ROI_Y_size/2+1:ROI_Y_size,1:round(ROI_X_size/2))));
% Drager4.ROI2.second(recount) = sum(sum(Drager4.Image_NaN(ROI_Y_size/2+1:ROI_Y_size,round(ROI_X_size/2+1):round(ROI_X_size))));
% Drager4.ROI2.third(recount) = sum(sum(Drager4.Image_NaN(1:ROI_Y_size/2,1:round(ROI_X_size/2))));
% Drager4.ROI2.fourth(recount) = sum(sum(Drager4.Image_NaN(1:ROI_Y_size/2,round(ROI_X_size/2+1):round(ROI_X_size))));

% subplot(6,6,13)
% imagesc(Drager4.Image(:,:)); axis image; caxis([-abs(Drager4.imgscale) abs(Drager4.imgscale)]);  colormap(Cmap);
% set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
% hold on; plot(Drager4.plot_x,'r','LineWidth',2); stem(round(ROI_X_size/2),ROI_Y_size,'r','LineWidth',2);

%% mask
% % % % % threshold = 30;
% % % % % th = min(min(Drager4.Image(:,:)))*threshold*0.01; Drager4.Image_mask = Drager4.Image;
% % % % % Drager4.Image_mask(Drager4.Image<=th) = 1; Drager4.Image_mask(Drager4.Image>=th) = 0;  clear threshold th;
% % % % % % imagesc(Drager4.Image_mask(:,:)); axis image; caxis([-1 1]);  colormap(Cmap);
% % % % % % set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
% % % % % Drager4.Image2 = Drager4.Image.*Drager4.Image_mask;
% % % % % 
% % % % % Drager4.Image_mask(isnan(Drager4.Image_mask)) = 0;
% % % % % 
% % % % % Drager4.Image_mask2=flip(Drager4.Image_mask);
% % % % % [~,Drager4.Indicater_max]=max(max(Drager4.Image_mask2'));
% % % % % Drager4.Indicater_max = size(Drager4.Image_mask,1) - Drager4.Indicater_max;
% % % % % 
% % % % % [~,Drager4.Indicater_min]=max(max(Drager4.Image_mask'));
% % % % % 
% % % % % Center = round((Drager4.Indicater_max + Drager4.Indicater_min)/2);
% % % % % 
% % % % % Drager4.plot_x_ROI3_top = ones(1,size(Drager4.Image,2)); Drager4.plot_x_ROI3_top = Drager4.plot_x_ROI3_top*Drager4.Indicater_max;
% % % % % Drager4.plot_x_ROI3_toptocenter = ones(1,size(Drager4.Image,2)); Drager4.plot_x_ROI3_toptocenter = Drager4.plot_x_ROI3_toptocenter*(Drager4.Indicater_max+Center)/2;
% % % % % Drager4.plot_x_ROI3_center = ones(1,size(Drager4.Image,2)); Drager4.plot_x_ROI3 = Drager4.plot_x_ROI3*Center;
% % % % % Drager4.plot_x_ROI3_centertobuttom = ones(1,size(Drager4.Image,2)); Drager4.plot_x_ROI3_centertobuttom = Drager4.plot_x_ROI3_centertobuttom*(Center+Drager4.Indicater_min)/2;
% % % % % Drager4.plot_x_ROI3_bottom = ones(1,size(Drager4.Image,2)); Drager4.plot_x_ROI3_bottom = Drager4.plot_x_ROI3_bottom*Drager4.Indicater_min;
% % % % % 
% % % % % Drager4.Image2_NaN = Drager4.Image2;
% % % % % Drager4.Image2_NaN(isnan(Drager4.Image2_NaN)) = 0;

%% ROI setting3
% subplot(6,6,19)
imagesc(Drager.Image(:,:)); axis image; caxis([-abs(Drager.imgscale) abs(Drager.imgscale)]); colormap(Cmap);
set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
hold on; plot(Drager.plot_x_ROI3_center,'r','LineWidth',2); 
plot(Drager.plot_x_ROI3_top,'r','LineWidth',2); plot(Drager.plot_x_ROI3_toptocenter,'r','LineWidth',2); 
plot(Drager.plot_x_ROI3_bottom,'r','LineWidth',2); plot(Drager.plot_x_ROI3_centertobuttom,'r','LineWidth',2); 

%% ROI setting4
% Drager4.ROI4.first(recount) = sum(sum(Drager4.Image2_NaN(Center+1:Drager4.Indicater_max,1:round(ROI_X_size/2))));
% Drager4.ROI4.second(recount) = sum(sum(Drager4.Image2_NaN(Center+1:Drager4.Indicater_max,round(ROI_X_size/2+1):round(ROI_X_size))));
% Drager4.ROI4.third(recount) = sum(sum(Drager4.Image2_NaN(Drager4.Indicater_min:Center,1:round(ROI_X_size/2))));
% Drager4.ROI4.fourth(recount) = sum(sum(Drager4.Image2_NaN(Drager4.Indicater_min:Center,round(ROI_X_size/2+1):round(ROI_X_size))));

% subplot(6,6,13)
% imagesc(Drager4.Image2(:,:)); axis image; caxis([-abs(Drager4.imgscale) abs(Drager4.imgscale)]);  colormap(Cmap);
% set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
% hold on; plot(Drager4.plot_x_ROI3_center,'r','LineWidth',2); stem(round(ROI_X_size/2),ROI_Y_size,'r','LineWidth',2);

Drager_ROI = Drager;

end

