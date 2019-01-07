function [ FVC ] = FxSpiro_FVC_Image( Data, DataSet, Breath_index, ROI_L_xcorr, C )

set(figure(1), 'Position', [550 300 250*size(Breath_index,2) 200]);
for B_index = 1:size(Breath_index,2)
    ref_index = DataSet.Breath(Breath_index(B_index)-1).index(end);
    ref = mean(DataSet.EIT_L(:,ref_index-2:ref_index+2),2);
    data1 = DataSet.EIT_L(:,DataSet.Breath(Breath_index(B_index)).inhale);
    data2 = DataSet.EIT_L(:,DataSet.Breath(Breath_index(B_index)).index(end));
    sigma1 = -Data.inv_Sense_weighted_avg*Data.Proj_Mat*((data1-ref));
    sigma2 = -Data.inv_Sense_weighted_avg*Data.Proj_Mat*((data2-ref));
    sigma(:,B_index) = sigma1 - sigma2;
    subplot(1,size(Breath_index,2),B_index); 
    patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,sigma(:,B_index),'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
    axis equal; caxis([-2 10]); axis off; colormap(C);

end
colorbar;
[FVC.Image] = FxEIT_Tri2Grid(Data.Element,Data.Node,sigma,256);

IMG = FxEIT_Tri2Grid(Data.Element,Data.Node,ROI_L_xcorr,256);
[ KHU_ROI_contour_outside ] = FxKHU_ROI_contour_outside( IMG, 1, C );
[ KHU_ROI_contour ] = FxKHU_ROI_contour2( IMG, 30, 1, C );

set(figure(2), 'Position', [550 300 250*size(Breath_index,2) 200]);
imagesc(FVC.Image(:,:)); set(gca,'YDir','normal'); set(gca,'xdir','normal'); 
set(gca,'xtick',[], 'ytick',[]); set(gca,'Position',[0 0 1 1]); axis image; colorbar;
caxis([-2 10]); colormap(C); hold on; 
for i = 1:size(FVC.Image,3)
    plot(KHU_ROI_contour_outside.ROI_IMG(:,2)+(i-1)*256,KHU_ROI_contour_outside.ROI_IMG(:,1),'w','LineWidth',2);
    plot(KHU_ROI_contour.left_ROI_IMG(:,2)+(i-1)*256,KHU_ROI_contour.left_ROI_IMG(:,1),'w','LineWidth',2);
    plot(KHU_ROI_contour.right_ROI_IMG(:,2)+size(KHU_ROI_contour.IMG_mask,1)/2+(i-1)*256,KHU_ROI_contour.right_ROI_IMG(:,1),'w','LineWidth',2);
end
end

