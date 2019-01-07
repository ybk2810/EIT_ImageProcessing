function [ Drager_ChangeRef ] = FxDrager_ChangeRef( DataSet, Data, section )
% Impedance waveform
% 0 origin
% 1 change ref
% 2 change ref using avg

count = 1;
breath_index = section(1):section(2);
ref_0(:,1) = DataSet.EIT_filt_L(:,DataSet.Breath(section(1)).index(end));
for i = breath_index
    Drager.EIT_0(:,DataSet.Breath(i).index(1)-DataSet.Breath(breath_index(1)).index(1)+1:DataSet.Breath(i).index(end)-DataSet.Breath(breath_index(1)).index(1)+1) ...
        = DataSet.EIT_filt_L(:,DataSet.Breath(i).index(1):DataSet.Breath(i).index(end)) - repmat(ref_0(:,1),1,size(DataSet.Breath(i).index,2));
    Drager.EIT_1(:,DataSet.Breath(i).index(1)-DataSet.Breath(breath_index(1)).index(1)+1:DataSet.Breath(i).index(end)-DataSet.Breath(breath_index(1)).index(1)+1) ...
        = DataSet.EIT_filt_L(:,DataSet.Breath(i).index(1):DataSet.Breath(i).index(end))-repmat(DataSet.EIT_filt_L(:,DataSet.Breath(i-1).index(end)),1,size(DataSet.Breath(i).index,2));
    ref(:,count) = DataSet.EIT_filt_L(:,DataSet.Breath(i-1).index(end));
    if count < 10
        Drager.EIT_2(:,DataSet.Breath(i).index(1)-DataSet.Breath(breath_index(1)).index(1)+1:DataSet.Breath(i).index(end) - DataSet.Breath(breath_index(1)).index(1)+1) ...
            = DataSet.EIT_filt_L(:,DataSet.Breath(i).index(1):DataSet.Breath(i).index(end)) - repmat(ref(:,count),1,size(DataSet.Breath(i).index,2));
    else
        ref(:,count) = mean(ref(:,count-9:count),2);
        Drager.EIT_2(:,DataSet.Breath(i).index(1)-DataSet.Breath(breath_index(1)).index(1)+1:DataSet.Breath(i).index(end) - DataSet.Breath(breath_index(1)).index(1)+1) ...
            = DataSet.EIT_filt_L(:,DataSet.Breath(i).index(1):DataSet.Breath(i).index(end)) - repmat(ref(:,count),1,size(DataSet.Breath(i).index,2));
    end
    
    Drager.PV_raw(DataSet.Breath(i).index(1)-DataSet.Breath(breath_index(1)).index(1)+1:DataSet.Breath(i).index(end)-DataSet.Breath(breath_index(1)).index(1)+1,:) ...
        = DataSet.PV_raw(DataSet.Breath(i).index(1):DataSet.Breath(i).index(end),:);
    Drager.time(:,DataSet.Breath(i).index(1)-DataSet.Breath(breath_index(1)).index(1)+1:DataSet.Breath(i).index(end)-DataSet.Breath(breath_index(1)).index(1)+1) ...
        = DataSet.time(:,DataSet.Breath(i).index(1):DataSet.Breath(i).index(end));
    
    count = count+1;
end
clear count i ref avg_ref;

EIT_proj = Data.Proj_Mat * Drager.EIT_0;
Drager.EIT_0_sigma = -Data.inv_Sense_weighted_avg * EIT_proj; clear EIT_proj;
Drager.EIT_0_waveform = sum(Drager.EIT_0_sigma);

EIT_proj = Data.Proj_Mat * Drager.EIT_1;
Drager.EIT_1_sigma = -Data.inv_Sense_weighted_avg * EIT_proj; clear EIT_proj;
Drager.EIT_1_waveform = sum(Drager.EIT_1_sigma);

EIT_proj = Data.Proj_Mat * Drager.EIT_2;
Drager.EIT_2_sigma = -Data.inv_Sense_weighted_avg * EIT_proj; clear EIT_proj;
Drager.EIT_2_waveform = sum(Drager.EIT_2_sigma);

FxEIT_timeplot_ChangeRef(Drager, 1, length(Drager.EIT_0_waveform) )

Drager_ChangeRef = Drager;
end

