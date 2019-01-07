function [ Drager_StatusIMG, imgscale ] = FxDrager_StatusIMG( DataSet, Data, section, Cmap )
[ Drager_ChangeRef ] = FxDrager_ChangeRef( DataSet, Data, section );
Drager.waveform = Drager_ChangeRef.EIT_2_waveform;
close all;

x_max = max(Data.Node(:,1)); x_min = min(Data.Node(:,1)); % x
y_max = max(Data.Node(:,2)); y_min = min(Data.Node(:,2)); % y
x_mean = (x_max+x_min)/2; y_mean = (y_max+y_min)/2;
Data.Node2(:,1) = Data.Node(:,1) - x_mean;
Data.Node2(:,2) = Data.Node(:,2) - y_mean;

count = 1;
breath_index = section(1):section(2);
for i = breath_index
    Drager.EIT(:,count) = DataSet.EIT_filt_L(:,DataSet.Breath(i).inhale) - DataSet.EIT_filt_L(:,DataSet.start_breath(i));
    EIT_proj = Data.Proj_Mat * Drager.EIT(:,count);
    Drager.IMG_sigma(:,count) = -Data.inv_Sense_weighted_avg * EIT_proj;
    Drager.IMG(:,:,count) = FxDrager_Tri2Grid(Data.Element,Data.Node2,Drager.IMG_sigma(:,count),256);
    Drager.IMG_NaN(:,:,count) = Drager.IMG(:,:,count);

    Drager.index(count) = i;
    Drager.count(:,DataSet.Breath(i).index(1)-DataSet.Breath(breath_index(1)).index(1)+1:DataSet.Breath(i).index(end)-DataSet.Breath(breath_index(1)).index(1)+1) = i;
    
    Drager.time(:,DataSet.Breath(i).index(1)-DataSet.Breath(breath_index(1)).index(1)+1:DataSet.Breath(i).index(end)-DataSet.Breath(breath_index(1)).index(1)+1) ...
        = DataSet.time(:,DataSet.Breath(i).index(1):DataSet.Breath(i).index(end));
    count = count+1;
end
clear count i EIT_proj;
Drager.IMG_NaN(isnan(Drager.IMG_NaN))=0;

FxEIT_timeplot_StatusIMG(Drager, 1, size(Drager.waveform,2) )

Drager.imgscale = max(max(max(Drager.IMG(:,:,:))));
for i=1:20
    subplot(3,20,20+i)
    imagesc(Drager.IMG(:,:,i+(size(Drager.EIT,2)-20))); axis image; 
    caxis([-abs(Drager.imgscale) abs(Drager.imgscale)]); colormap(Cmap);
    set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);
%     patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData', sigma, 'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
%     axis equal; caxis([-abs(a) abs(a)]); axis off; colormap(Cmap);
    pause(0.000001)
end

Drager.RR = Drager.count(end)-Drager.count(end-50*60)+1;

Drager.Minute_IMG = mean(Drager.IMG(:,:,end-Drager.RR+1:end),3);
subplot(3,20,[41 42])
imagesc(Drager.Minute_IMG(:,:)); axis image; 
caxis([-abs(Drager.imgscale) abs(Drager.imgscale)]); colormap(Cmap);
set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]);

imgscale = Drager.imgscale;
Drager_StatusIMG = Drager;
end

