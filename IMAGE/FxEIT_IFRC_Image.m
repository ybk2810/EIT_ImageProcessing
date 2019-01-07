% Type 1:IFRCI_Img 2:fEIT_Img 3:Compliance_Img 4:Phase_Img

function [ IFRC_Image ] = FxEIT_IFRC_Image( Data, EIT_ref, DataSet, type )
meshsize = max(max(abs(Data.Node)))*1.05; % depend on original Image
pixel_num = 256;
for j = 1:size(Data.Element,1)
    xy(j,:) = mean(Data.Node(Data.Element(j,1:3),:));
end
ti = -meshsize:(2*meshsize)/(pixel_num-1):meshsize;
[qx,qy] = meshgrid(ti,ti);

%% reference
Temp = Data.Proj_Mat * DataSet.EIT_filt_L(:,EIT_ref(1):EIT_ref(2)); % boundary artifact remover
sigma_ref = Data.inv_Sense_weighted_avg*Temp; % sensitivity matrix
sigma_ref = mean(sigma_ref,2);


if type==1
    % Incremental Functional Residual Capacity image
    for cnt = 1:length(DataSet.PEEP) % PEEP
        for i = 2:length(DataSet.PEEP(cnt).index)-1 % maximum inspiratory moment in each breath
            Temp = Data.Proj_Mat * DataSet.EIT_filt_L(:,DataSet.Breath(DataSet.PEEP(cnt).index(i)).inhale); % boundary artifact remover
            sigma(:,i-1) = Data.inv_Sense_weighted_avg*Temp; % Sensitivity matrix(weighted method)
            sigma(:,i-1) = sigma(:,i-1) - sigma_ref;
        end
        sigma = mean(sigma,2);
        F = TriScatteredInterp(xy(:,1),xy(:,2),sigma);
        IFRC_Image(:,:,cnt) = F(qx,qy);

        disp(num2str(cnt))
    end
elseif type == 2
    % Incremental Functional Residual Capacity image
    for cnt = 1:length(DataSet.TidalVolume) % PEEP
        for i = 2:length(DataSet.TidalVolume(cnt).index)-1 % maximum inspiratory moment in each breath
            Temp = Data.Proj_Mat * DataSet.EIT_filt_L(:,DataSet.Breath(DataSet.TidalVolume(cnt).index(i)).inhale); % boundary artifact remover
            sigma(:,i-1) = Data.inv_Sense_weighted_avg*Temp; % Sensitivity matrix(weighted method)
            sigma(:,i-1) = sigma(:,i-1) - sigma_ref;
        end
        sigma = mean(sigma,2);
        F = TriScatteredInterp(xy(:,1),xy(:,2),sigma);
        IFRC_Image(:,:,cnt) = F(qx,qy);

        disp(num2str(cnt))
    end
end

end

