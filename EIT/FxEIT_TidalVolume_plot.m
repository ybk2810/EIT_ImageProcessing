function [ a ] = FxEIT_TidalVolume_plot( section, remove, Data, DataSet )

EIT_TV_ref = [DataSet.Breath(section(1)).index(end)-40 DataSet.Breath(section(1)).index(end)];

% fEIT(Tidal Volume) image RIO masking Image
a = DataSet.Breath(DataSet.PEEP(1).index(2)).index(1); % start
b = DataSet.Breath(DataSet.PEEP(1).index(end-1)).index(end); % finish
Temp_f = Data.Proj_Mat * DataSet.EIT_filt_L(:,a:b); % boundary artifact remover
sigma_f = Data.inv_Sense_weighted_avg*Temp_f; % Sensitivity matrix(weighted method)
sigma_f = std(sigma_f');
sigma_f = sigma_f';

threshold = 30;
th = max(max(sigma_f(:,:)))*threshold*0.01;
sigma_f(sigma_f<=th) = 0; sigma_f(sigma_f>=th) = 1; clear threshold th;
% patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,sigma_f(:,:),'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
% axis equal; caxis([-1 1]); axis off;

% ref
Temp = Data.Proj_Mat * mean(DataSet.EIT_filt_L(:,EIT_TV_ref(1):EIT_TV_ref(2)),2); % boundary artifact remover
sigma_ref = Data.inv_Sense_weighted_avg*Temp; % sensitivity matrix

figure;
for i=section(1):section(end)
    if i ~= remove(:)
    a = DataSet.Breath(i).index(1); % section start
    b = DataSet.Breath(i).index(end); % section finish
    
    TidalVolume_P = Data.Proj_Mat * DataSet.EIT_filt_L(:,a:b); % boundary artifact remover
    TidalVolume_Sigma = Data.inv_Sense_weighted_avg*TidalVolume_P; % Sensitivity matrix(weighted method)
    TidalVolume_Sigma = TidalVolume_Sigma - repmat(sigma_ref,1,size(TidalVolume_Sigma,2));
    TidalVolume_Sigma(sigma_f~=1,:) = 0; % masking

    Cmap2 = jet(size(DataSet.Breath(section(1):section(end)),2));

    plot(DataSet.PV_raw(a:b,4),-sum(TidalVolume_Sigma),'Color',Cmap2(i-section(1)+1,:));hold on;
    pause(0.01);
    end
end
xlabel('Volume');
ylabel('Impedance');

end

