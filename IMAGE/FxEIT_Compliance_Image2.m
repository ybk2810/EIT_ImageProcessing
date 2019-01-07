function [ Compliance_Image ] = FxEIT_Compliance_Image2( Data, DataSet, Breath, inhale )
% if not have ventilation data, import values instead of PV data

% Compliance image
Temp = -Data.Proj_Mat * DataSet.EIT_L; % boundary artifact remover

temp_E_S1 = Breath(1); % EIT start1
temp_E_S2 = Breath(1)-1; % EIT start2
temp_E_S = (Temp(:,temp_E_S1)+Temp(:,temp_E_S2))/2; % EIT start avg

temp_E_F1 = inhale-1; % EIT finish1
temp_E_F2 = inhale; % EIT finish2
temp_E_F = (Temp(:,temp_E_F1)+Temp(:,temp_E_F2))/2; % EIT finish avg

% temp_P_S = (DataSet.PV_raw(temp_E_S1,3)+DataSet.PV_raw(temp_E_S2,3))/2; % PV start avg
% temp_P_F = (DataSet.PV_raw(temp_E_F1,3)+DataSet.PV_raw(temp_E_F2,3))/2; % PV finish avg

clear temp_E_S1 temp_E_S2 temp_E_F1 temp_E_F2
% Temp2 = (temp_E_F-temp_E_S)./(temp_P_F-temp_P_S);
Temp2 = (temp_E_F-temp_E_S)./5;
sigma = Data.inv_Sense_weighted_avg*Temp2; % Sensitivity matrix(weighted method)

[Compliance_Image(:,:)] = FxEIT_Tri2Grid(Data.Element,Data.Node,sigma,256);
end