function [ TV_Image,sigma ] = FxEIT_TV_Image( Data, DataSet, Breath, inhale )
% Tidal Volume image
Temp = Data.Proj_Mat * (DataSet.EIT_L(:,inhale)-mean(DataSet.EIT_L(:,Breath(end-10:end)),2)); % boundary artifact remover
sigma(:,1) = -Data.inv_Sense_weighted_avg*Temp; % Sensitivity matrix(weighted method)
[TV_Image(:,:)] = FxEIT_Tri2Grid(Data.Element,Data.Node,sigma,256);

end

