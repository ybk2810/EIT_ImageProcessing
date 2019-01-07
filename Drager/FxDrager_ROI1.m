function [ IMG2 ] = FxDrager_ROI1( Drager_DynamicIMG, Drager_ROI_mask, imgscale, Cmap )
IMG2.first = sum(sum(Drager_DynamicIMG.Dynamic_IMG_NaN(Drager_ROI_mask.ROI_Y_size/2/2*3+1:Drager_ROI_mask.ROI_Y_size,:,:)));
IMG2.second = sum(sum(Drager_DynamicIMG.Dynamic_IMG_NaN(Drager_ROI_mask.ROI_Y_size/2+1:Drager_ROI_mask.ROI_Y_size/2/2*3,:,:)));
IMG2.third = sum(sum(Drager_DynamicIMG.Dynamic_IMG_NaN(Drager_ROI_mask.ROI_Y_size/2/2+1:Drager_ROI_mask.ROI_Y_size/2,:,:)));
IMG2.fourth = sum(sum(Drager_DynamicIMG.Dynamic_IMG_NaN(1:Drager_ROI_mask.ROI_Y_size/2/2,:,:)));

if size(IMG2.first,3)>2
    IMG2.first = reshape(IMG2.first,1,size(IMG2.first,3));
    IMG2.second = reshape(IMG2.second,1,size(IMG2.second,3));
    IMG2.third = reshape(IMG2.third,1,size(IMG2.third,3));
    IMG2.fourth = reshape(IMG2.fourth,1,size(IMG2.fourth,3));
end

figure; imagesc(Drager_ROI_mask.Image(:,:)); axis image; 
caxis([-abs(imgscale) abs(imgscale)]);  colormap(Cmap); colorbar('westoutside','fontsize',15);
set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
hold on; plot(Drager_ROI_mask.plot_x,'r','LineWidth',2); 
plot(Drager_ROI_mask.plot_x+round(Drager_ROI_mask.ROI_Y_size/2/2),'r','LineWidth',2); 
plot(Drager_ROI_mask.plot_x-round(Drager_ROI_mask.ROI_Y_size/2/2),'r','LineWidth',2);

    
end

