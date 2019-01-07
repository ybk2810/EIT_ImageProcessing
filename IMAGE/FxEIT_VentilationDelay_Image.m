function [ VentilationDelay_Image ] = FxEIT_VentilationDelay_Image( Data, EIT_ref, DataSet, Breath, inhale )
Temp_ref = Data.Proj_Mat * mean(DataSet.EIT_L(:,EIT_ref(1):EIT_ref(2)),2); % boundary artifact remover

% Ventilation_delay_Image
% interpolation & mov avg for phase image
    
int_num = 4;
w = 90; % window size 

Temp = Data.Proj_Mat * DataSet.EIT_L(:,Breath); % one breath % boundary artifact remover

sigma = -Data.inv_Sense_weighted_avg * (Temp - repmat(Temp_ref,1,size(Temp,2))); % Sensitivity matrix(weighted method)
% sigma(sigma_f~=1,:) = 0; % masking
% patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,sigma(:,120),'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
% axis equal; caxis([-80 80]); axis off; colormap(Cmap1);

% tEI = sum(DataSet.PV_raw(DataSet.Breath(DataSet.PEEP(cntPEEP).index(cntBreath)).index,2));
tEI = inhale - Breath(1);
[ sigma2 ] = FxEIT_interp(sigma(:,1:tEI), int_num, w );
% sigma2 = sigma2(:,w/2+1:end);
sigma2_avg = mean(sigma2,1);

min_avg = sigma2_avg(1);
[max_avg, max_avg_x] = max(sigma2_avg);
standard_avg_dot = (max_avg-min_avg)*0.2+min_avg;

sigma2_avg(sigma2_avg>=standard_avg_dot) = 0;
sigma2_avg(sigma2_avg~=0) = 1;
standard_avg= sum(sigma2_avg);

standard_Tri=[];

min_Tri = sigma2(:,1);
max_Tri = max(sigma2')';
th_Tri = (max_Tri-min_Tri)*0.2+min_Tri;
for cntSigma = 1:size(sigma2,1)                
    temp_sigma = sigma2(cntSigma,:)';
    temp_sigma(temp_sigma>=th_Tri(cntSigma)) = 0;
    temp_sigma(temp_sigma~=0) = 1;
    standard_Tri(cntSigma,1)= sum(temp_sigma);

% for time = 1:max_Tri_x(cntSigma)
%     if sigma2(,time)<standard_Tri_dot
%         standard_Tri_x(1,time) = 1;
%     else
%         standard_Tri_x(1,time) = 0;
%     end
% end
% standard_Tri(cntSigma,1) = sum(standard_Tri_x(1,:));

    if standard_Tri(cntSigma,1) ~= 0
        standard_Tri(cntSigma,1) = standard_Tri(cntSigma,1)-standard_avg;
    end
end

[VentilationDelay_Image(:,:)] = FxEIT_Tri2Grid(Data.Element,Data.Node,standard_Tri,256);
end



