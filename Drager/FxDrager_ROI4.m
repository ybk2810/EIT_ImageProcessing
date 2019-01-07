function [ IMG2 ] = FxDrager_ROI4( Drager_DynamicIMG, Drager_ROI_mask, imgscale, Cmap )
% IMG(isnan(IMG))=0;
IMG2.first = sum(sum(Drager_DynamicIMG.Dynamic_IMG_NaN(Drager_ROI_mask.Center+1:Drager_ROI_mask.Indicater_max,1:round(Drager_ROI_mask.ROI_X_size/2),:)));
IMG2.second = sum(sum(Drager_DynamicIMG.Dynamic_IMG_NaN(Drager_ROI_mask.Center+1:Drager_ROI_mask.Indicater_max,round(Drager_ROI_mask.ROI_X_size/2+1):round(Drager_ROI_mask.ROI_X_size),:)));
IMG2.third = sum(sum(Drager_DynamicIMG.Dynamic_IMG_NaN(Drager_ROI_mask.Indicater_min:Drager_ROI_mask.Center,1:round(Drager_ROI_mask.ROI_X_size/2),:)));
IMG2.fourth = sum(sum(Drager_DynamicIMG.Dynamic_IMG_NaN(Drager_ROI_mask.Indicater_min:Drager_ROI_mask.Center,round(Drager_ROI_mask.ROI_X_size/2+1):round(Drager_ROI_mask.ROI_X_size),:)));

if size(IMG2.first,3)>2
    IMG2.first = reshape(IMG2.first,1,size(IMG2.first,3));
    IMG2.second = reshape(IMG2.second,1,size(IMG2.second,3));
    IMG2.third = reshape(IMG2.third,1,size(IMG2.third,3));
    IMG2.fourth = reshape(IMG2.fourth,1,size(IMG2.fourth,3));
end

figure; imagesc(Drager_ROI_mask.Image2(:,:)); hold on; 
plot(Drager_ROI_mask.plot_x_ROI3_center,'r','LineWidth',2); 
stem(round(Drager_ROI_mask.ROI_X_size/2),Drager_ROI_mask.ROI_Y_size+10,'r','LineWidth',2);
axis image; caxis([-abs(imgscale) abs(imgscale)]);  colormap(Cmap); colorbar('westoutside');
set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
axis([1,257,1,300]);%set(gca,'xlim',([0 21]),'ylim',([-10 10])); 

end

