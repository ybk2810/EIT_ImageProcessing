function [ ROI_mask_Image ] = FxEIT_ROI( EELV_Image, threshold )
th = max(max(EELV_Image))*threshold*0.01;
temp = EELV_Image;
temp(temp<=th) = 0; temp(temp>=th) = 1;
ROI_mask_Image(:,:) = temp;
clear temp

figure(4);
imagesc(ROI_mask_Image(:,:)); set(gca,'YDir','normal'); set(gca,'xdir','normal');
set(gca,'xtick',[], 'ytick',[]); axis square;
caxis([-1 1]);

end

