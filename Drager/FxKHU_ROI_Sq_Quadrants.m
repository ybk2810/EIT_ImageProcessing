function [ ROI_Q ] = FxKHU_ROI_Sq_Quadrants( ROI, Data,C )
% 20170611 2017EITÇÐÈ¸ heart ROI quadrants quad_mesh

[ROI2] = FxEIT_Tri2Grid(Data.Element,Data.Node,ROI,256);
% figure(1); imagesc(ROI2); set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]); axis image; caxis([0 1]); colormap(C.Cmap5); 

ROI2(isnan(ROI2))=0; ROI2(ROI2>0)=1;

% figure(2); imagesc(flip(ROI2')'); set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]); axis image; caxis([0 1]); colormap(C.Cmap5); 

[~,x_max]=max(max(flip(ROI2')')); x_max = size(ROI2,2) - x_max+1;
[~,y_max]=max(max(flip(ROI2)')); y_max = size(ROI2,1) - y_max;
[~,x_min]=max(max(ROI2));
[~,y_min]=max(max(ROI2'));

ROI_Q.ROI = ROI2;

ROI_Q.Center = [round((x_max + x_min)/2),round((y_max + y_min)/2)];

ROI_Q.ROI1 = ROI2;
ROI_Q.ROI1(:,ROI_Q.Center(1):end)=0;
ROI_Q.ROI1(1:ROI_Q.Center(2),:)=0;

ROI_Q.ROI2 = ROI2;
ROI_Q.ROI2(:,1:ROI_Q.Center(1))=0;
ROI_Q.ROI2(1:ROI_Q.Center(2),:)=0;

ROI_Q.ROI3 = ROI2;
ROI_Q.ROI3(:,ROI_Q.Center(1):end)=0;
ROI_Q.ROI3(ROI_Q.Center(2):end,:)=0;

ROI_Q.ROI4 = ROI2;
ROI_Q.ROI4(:,1:ROI_Q.Center(1))=0;
ROI_Q.ROI4(ROI_Q.Center(2):end,:)=0;

figure(1); subplot(2,2,1); imagesc(ROI_Q.ROI1); set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]); axis image; caxis([0 1]); colormap(C); 
subplot(2,2,2); imagesc(ROI_Q.ROI2); set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]); axis image; caxis([0 1]); colormap(C); 
subplot(2,2,3); imagesc(ROI_Q.ROI3); set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]); axis image; caxis([0 1]); colormap(C); 
subplot(2,2,4); imagesc(ROI_Q.ROI4); set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]); axis image; caxis([0 1]); colormap(C); 

ROI_Q.x_max = x_max;
ROI_Q.x_min = x_min;
ROI_Q.y_max = y_max;
ROI_Q.x_min = x_min;


end

