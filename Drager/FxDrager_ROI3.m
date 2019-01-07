function [ IMG2 ] = FxDrager_ROI3( Drager_DynamicIMG, Drager_ROI_mask, imgscale, Cmap )
IMG2.first = sum(sum(Drager_DynamicIMG.Dynamic_IMG_NaN(round((Drager_ROI_mask.Center+Drager_ROI_mask.Indicater_max)/2)+1:Drager_ROI_mask.Indicater_max,:,:)));
IMG2.second = sum(sum(Drager_DynamicIMG.Dynamic_IMG_NaN(Drager_ROI_mask.Center+1:(Drager_ROI_mask.Center+Drager_ROI_mask.Indicater_max)/2,:,:)));
IMG2.third = sum(sum(Drager_DynamicIMG.Dynamic_IMG_NaN(round((Drager_ROI_mask.Indicater_min+Drager_ROI_mask.Center)/2)+1:Drager_ROI_mask.Center,:,:)));
IMG2.fourth = sum(sum(Drager_DynamicIMG.Dynamic_IMG_NaN(Drager_ROI_mask.Indicater_min:round((Drager_ROI_mask.Indicater_min+Drager_ROI_mask.Center)/2),:,:)));

if size(IMG2.first,3)>2
    IMG2.first = reshape(IMG2.first,1,size(IMG2.first,3));
    IMG2.second = reshape(IMG2.second,1,size(IMG2.second,3));
    IMG2.third = reshape(IMG2.third,1,size(IMG2.third,3));
    IMG2.fourth = reshape(IMG2.fourth,1,size(IMG2.fourth,3));
end

figure; imagesc(Drager_ROI_mask.Image2(:,:)); 
axis image; caxis([-abs(imgscale)/5 abs(imgscale)]); colormap(Cmap); colorbar('westoutside');
set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
hold on; plot(Drager_ROI_mask.plot_x_ROI3_center,'r','LineWidth',2); 
plot(Drager_ROI_mask.plot_x_ROI3_top,'r','LineWidth',2); 
plot(Drager_ROI_mask.plot_x_ROI3_toptocenter,'r','LineWidth',2); 
plot(Drager_ROI_mask.plot_x_ROI3_bottom,'r','LineWidth',2); 
plot(Drager_ROI_mask.plot_x_ROI3_centertobuttom,'r','LineWidth',2); 

end

