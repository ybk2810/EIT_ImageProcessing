function [ Drager_ComparisonIMG ] = FxDrager_ComparisonIMG( DataSet, Data, section, Cmap )

Drager.EIT_filt_L = DataSet.EIT_filt_L(:,DataSet.Breath(section).inhale+30:DataSet.Breath(section+2).inhale);
Drager.time = DataSet.time(:,DataSet.Breath(section).inhale+30:DataSet.Breath(section+2).inhale);
Drager.PV_raw = DataSet.PV_raw(DataSet.Breath(section).inhale:DataSet.Breath(section+2).inhale,:);
Drager.A = DataSet.EIT_filt_L(:,DataSet.Breath(section+1).index(1)-1);
Drager.B = DataSet.EIT_filt_L(:,DataSet.Breath(section+1).inhale);
Drager.C = DataSet.EIT_filt_L(:,DataSet.Breath(section+1).index(end));

Drager.A_point = DataSet.Breath(section+1).index(1) - 1 -(DataSet.Breath(section).inhale+30) + 1;
Drager.B_point = DataSet.Breath(section+1).inhale -(DataSet.Breath(section).inhale+30) + 1;
Drager.C_point = DataSet.Breath(section+1).index(end) -(DataSet.Breath(section).inhale+30) + 1;

Drager.B = Drager.B - Drager.A;
Drager.C = Drager.C - Drager.A;

Drager.EIT_filt_L = Drager.EIT_filt_L - repmat(Drager.A,1,size(Drager.EIT_filt_L,2));

EIT_proj = Data.Proj_Mat * Drager.A; Drager.A = Data.inv_Sense_weighted_avg * EIT_proj; Drager.A = -Drager.A; clear EIT_proj; % A
EIT_proj = Data.Proj_Mat * Drager.B; Drager.B = Data.inv_Sense_weighted_avg * EIT_proj; Drager.B = -Drager.B; clear EIT_proj; % B
EIT_proj = Data.Proj_Mat * Drager.C; Drager.C = Data.inv_Sense_weighted_avg * EIT_proj; Drager.C = -Drager.C; clear EIT_proj; % C


x_max = max(Data.Node(:,1)); x_min = min(Data.Node(:,1)); % x
y_max = max(Data.Node(:,2)); y_min = min(Data.Node(:,2)); % y
x_mean = (x_max+x_min)/2; y_mean = (y_max+y_min)/2;
Data.Node2(:,1) = Data.Node(:,1) - x_mean;
Data.Node2(:,2) = Data.Node(:,2) - y_mean;


[Drager.B ] = FxDrager_Tri2Grid(Data.Element, Data.Node2, Drager.B, 256);
[Drager.C ] = FxDrager_Tri2Grid(Data.Element, Data.Node2, Drager.C, 256);

% Drager.EIT_filt_L = 
FxDrager_timeplot_ComparisonIMG(Drager, 1, size(Drager.time,2));
hold on;
plot(1:length(Drager.EIT_filt_L),zeros(1,length(Drager.EIT_filt_L)),'k:', 'LineWidth',2);
plot(Drager.A_point,sum(Drager.EIT_filt_L(:,Drager.A_point)),'r*');
plot(Drager.B_point,sum(Drager.EIT_filt_L(:,Drager.B_point)),'r*');
plot(Drager.C_point,sum(Drager.EIT_filt_L(:,Drager.C_point)),'r*');
subplot(3,4,[6 7]);
imgscale = max(max(Drager.B));
imagesc(Drager.B(:,:)); axis image; caxis([-abs(imgscale)/5 abs(imgscale)]);  colormap(Cmap);
set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]); colorbar('westoutside');
subplot(3,4,[11 12]);
imagesc(Drager.C(:,:)); axis image; caxis([-abs(imgscale)/5 abs(imgscale)]);  colormap(Cmap);
set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]); colorbar('westoutside');

Drager_ComparisonIMG = Drager;
end

