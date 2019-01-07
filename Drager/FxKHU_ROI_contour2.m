function [ Drager_ROI_contour,IMG_mask ] = FxKHU_ROI_contour2( IMG, threshold, imgscale, Cmap )
Drager.IMG = IMG;

th = max(max(Drager.IMG(:,:)))*threshold*0.01; 
Drager.IMG_mask = Drager.IMG;
Drager.IMG_mask(Drager.IMG<=th) = 0; 
Drager.IMG_mask(Drager.IMG>=th) = 1;  clear threshold th;

Drager.IMG_mask(isnan(Drager.IMG_mask)) = 0;

IMG_mask = Drager.IMG_mask;

Drager.temp=[];
Drager.left_IMG = Drager.IMG_mask(:,1:size(Drager.IMG_mask,1)/2);
Drager.right_IMG = Drager.IMG_mask(:,size(Drager.IMG_mask,1)/2+1:end);

[Drager.temp(1) Drager.temp(2)] = find(Drager.left_IMG,1);
[Drager.temp2(1) Drager.temp2(2)] = find(Drager.right_IMG,1);
Drager.left_ROI_IMG = bwtraceboundary(Drager.left_IMG,Drager.temp,'W',8,Inf,'counterclockwise');
Drager.right_ROI_IMG = bwtraceboundary(Drager.right_IMG,Drager.temp2,'W',8,Inf,'counterclockwise');

figure; imagesc(Drager.IMG); set(gca,'YDir','normal'); set(gca,'xdir','normal'); 
set(gca,'xtick',[], 'ytick',[]); axis image; colorbar('westoutside');
caxis([-1*abs(imgscale)/5 1*abs(imgscale)]); colormap(Cmap); hold on;
plot(Drager.left_ROI_IMG(:,2),Drager.left_ROI_IMG(:,1),'w','LineWidth',1.5);
plot(Drager.right_ROI_IMG(:,2)+size(Drager.IMG_mask,1)/2,Drager.right_ROI_IMG(:,1),'w','LineWidth',1.5);

Drager_ROI_contour = Drager;
end

