function [ Drager_ROI_mask ] = FxDrager_ROI_mask( Drager_StatusIMG, Drager_Cursor2, Cmap, threshold )
Drager.Image = Drager_StatusIMG.IMG(:,:,Drager_Cursor2.breath==Drager_StatusIMG.index);

if nargin<4
    threshold = 30;
end
th = max(max(Drager.Image(:,:)))*threshold*0.01; 
Drager.Image_mask = Drager.Image;
Drager.Image_mask(Drager.Image<=th) = 0; 
Drager.Image_mask(Drager.Image>=th) = 1;  clear threshold th;
imagesc(Drager.Image_mask(:,:)); axis image; caxis([-1 1]);  colormap(Cmap);
set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);

Drager.Image_mask(isnan(Drager.Image_mask)) = 0;

[~,Drager.Indicater_max]=max(max(flip(Drager.Image_mask)'));
Drager.Indicater_max = size(Drager.Image_mask,1) - Drager.Indicater_max;

[~,Drager.Indicater_min]=max(max(Drager.Image_mask'));

Drager.Center = round((Drager.Indicater_max + Drager.Indicater_min)/2);

Drager.plot_x_ROI3_top = ones(1,size(Drager.Image,2)); 
Drager.plot_x_ROI3_top = Drager.plot_x_ROI3_top*Drager.Indicater_max;
Drager.plot_x_ROI3_toptocenter = ones(1,size(Drager.Image,2)); 
Drager.plot_x_ROI3_toptocenter = Drager.plot_x_ROI3_toptocenter*(Drager.Indicater_max+Drager.Center)/2;
Drager.plot_x_ROI3_center = ones(1,size(Drager.Image,2)); 
Drager.plot_x_ROI3_center = Drager.plot_x_ROI3_center*Drager.Center;
Drager.plot_x_ROI3_centertobuttom = ones(1,size(Drager.Image,2)); 
Drager.plot_x_ROI3_centertobuttom = Drager.plot_x_ROI3_centertobuttom*(Drager.Center+Drager.Indicater_min)/2;
Drager.plot_x_ROI3_bottom = ones(1,size(Drager.Image,2)); 
Drager.plot_x_ROI3_bottom = Drager.plot_x_ROI3_bottom*Drager.Indicater_min;

Drager.Image2 = Drager.Image.*Drager.Image_mask;
Drager.Image2_NaN = Drager.Image2;
Drager.Image2_NaN(isnan(Drager.Image2_NaN)) = 0;

Drager.ROI_X_size = size(Drager.Image,2);
Drager.ROI_Y_size = size(Drager.Image,1);
Drager.plot_x = ones(1,size(Drager.Image,2)); Drager.plot_x = Drager.plot_x*Drager.ROI_Y_size/2;
Drager.plot_y = ones(1,size(Drager.Image,2)); Drager.plot_y = Drager.plot_y*Drager.ROI_X_size/2;

Drager_ROI_mask = Drager;
end

