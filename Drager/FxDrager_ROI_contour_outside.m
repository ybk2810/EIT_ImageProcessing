function [ Drager_ROI_contour_outside ] = FxDrager_ROI_contour_outside( IMG, imgscale, Cmap )
Drager.IMG = IMG;
figure(1); imagesc(Drager.IMG);
axis image; caxis([-abs(imgscale)/5 abs(imgscale)]); colormap(Cmap); colorbar('westoutside');
set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);

Drager.IMG_mask = Drager.IMG;
Drager.IMG_mask(Drager.IMG_mask(:,:) > -1000000000) = 1;
Drager.IMG_mask(isnan(Drager.IMG_mask)) = 0; 

Drager.temp=[];
[Drager.temp(1) Drager.temp(2)] = find(Drager.IMG_mask,1);
Drager.ROI_IMG = bwtraceboundary(Drager.IMG_mask,Drager.temp,'W',8,Inf,'counterclockwise');

% plot(Drager.ROI_IMG(:,2),Drager.ROI_IMG(:,1),'w','LineWidth',2);

Drager_ROI_contour_outside = Drager;
end

