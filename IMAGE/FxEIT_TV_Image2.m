function [ TV_Image ] = FxEIT_TV_Image2( Data, DataSet, cntBreath )
% Tidal Volume image
a = DataSet.Breath(cntBreath).inhale;% maximum inspiratory moment in each breath
b = DataSet.Breath(cntBreath).exhale;
Temp = Data.Proj_Mat * (DataSet.EIT_L(:,a)-DataSet.EIT_L(:,b)); % boundary artifact remover
sigma(:,1) = -Data.inv_Sense_weighted_avg*Temp; % Sensitivity matrix(weighted method)
[TV_Image(:,:)] = FxEIT_Tri2Grid(Data.Element,Data.Node,sigma,256);


% for cnt = 1:length(DataSet.PEEP) % PEEP
%     for i = 1:length(DataSet.PEEP(cnt).index) % maximum inspiratory moment in each breath
%         a = DataSet.Breath(DataSet.PEEP(cnt).index(i)).inhale;
%         b = DataSet.Breath(DataSet.PEEP(cnt).index(i)).index;
%         Temp = Data.Proj_Mat * (DataSet.EIT_L(:,a)-mean(DataSet.EIT_L(:,b(end-1):b(end)),2)); % boundary artifact remover
%         sigma(:,i) = -Data.inv_Sense_weighted_avg*Temp; % Sensitivity matrix(weighted method)
%         disp(num2str(i))
%     end
%     sigma = mean(sigma,2);
%     [TV_Image(:,:,cnt)] = FxEIT_Tri2Grid(Data.Element,Data.Node,sigma,256);
% 
%     disp(num2str(cnt))
% end
end

