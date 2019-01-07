function [ ROI_Lung, Lung_std, ROI_contour_outside, ROI_contour, IMG_mask2 ] = FxEIT_MakeROI( data, ref, start, finish, Data, threshold, C )
%UNTITLED 이 함수의 요약 설명 위치
%   자세한 설명 위치
inv_Sense = Data.inv_Sense_weighted_avg*Data.Proj_Mat;

data2 = data(:,start:finish);
Lung_data = inv_Sense*(repmat(ref,1,size(data2,2))-data2);
Lung_std = std(Lung_data')';
ROI_Lung = Lung_std;
th = max(ROI_Lung)*threshold*0.01;
ROI_Lung(ROI_Lung<=th) = 0; ROI_Lung(ROI_Lung>th) = 1;

imgscale = max(Lung_std);
set(figure, 'Position', [0 0 800 400]); subplot(1,2,1); 
patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,Lung_std,'FaceColor' ,'flat' ,'EdgeColor' ,'None' ); 
axis equal; caxis([-imgscale/5 imgscale]); colormap(C.Cmap2); axis off;
subplot(1,2,2); 
patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,ROI_Lung,'FaceColor' ,'flat' ,'EdgeColor' ,'None' ); 
axis equal; caxis([0 1]); colormap(C.Cmap2); axis off;

%% plotting material
IMG_mask = FxEIT_Tri2Grid(Data.Element,Data.Node,Lung_std,256);
imgscale = reshape(max(max(max(IMG_mask))),1,1);

% boundary contour
[ ROI_contour_outside ] = FxKHU_ROI_contour_outside( IMG_mask, imgscale, C.Cmap2 );

% ROI contour
try
    [ ROI_contour,IMG_mask2 ] = FxKHU_ROI_contour2( IMG_mask, threshold, imgscale, C.Cmap2 );
catch
    [ ROI_contour,IMG_mask2 ] = FxKHU_ROI_contour( IMG_mask, threshold, imgscale, C.Cmap2 );
end

end

