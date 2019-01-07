function [ EELV_Image ] = FxEIT_EELV_Image( Data, EIT_ref, DataSet, Breath )
% reference
Temp_ref = Data.Proj_Mat * DataSet.EIT_L(:,EIT_ref(1):EIT_ref(2)); % boundary artifact remover
Temp_ref = mean(Temp_ref,2);

% End Inspiratory Lung Volume image
Temp = Data.Proj_Mat * mean(DataSet.EIT_L(:,Breath(end-10:end)),2); % boundary artifact remover
Temp = Temp - Temp_ref;
sigma(:,1) = -Data.inv_Sense_weighted_avg*Temp; % Sensitivity matrix(weighted method)
[EELV_Image(:,:)] = FxEIT_Tri2Grid(Data.Element,Data.Node,sigma,256);

end
