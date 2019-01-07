function [ SDfEIT_Image ] = FxEIT_SDfEIT_Image( Data, DataSet, Breath )
a = Breath(1); % start
b = Breath(end); % finish

Temp = Data.Proj_Mat * DataSet.EIT_L(:,a:b); % boundary artifact remover
sigma = Data.inv_Sense_weighted_avg*Temp; % Sensitivity matrix(weighted method)
sigma = std(sigma');
sigma = sigma';

[SDfEIT_Image(:,:)] = FxEIT_Tri2Grid(Data.Element,Data.Node,sigma,256);

end

