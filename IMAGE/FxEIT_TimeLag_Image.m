function [ TimeLag_Image ] = FxEIT_TimeLag_Image( Data, EIT_ref, DataSet, inhale, sigma_f )
% reference
Temp_ref = Data.Proj_Mat * mean(DataSet.EIT_L(:,EIT_ref(1):EIT_ref(2)),2); % boundary artifact remover

% Phase Image
% interpolation & mov avg for phase image
int_num = 4;
w = 90; % window size 
k = ones(1, w) / w;

Temp = Data.Proj_Mat * DataSet.EIT_L(:,inhale-50:inhale+50); % one breath % boundary artifact remover
sigma = -Data.inv_Sense_weighted_avg * (Temp - repmat(Temp_ref,1,size(Temp,2))); % Sensitivity matrix(weighted method)
% patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,sigma(:,120),'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
% axis equal; caxis([-80 80]); axis off;

for cntTri = 1:size(sigma,1)
    sigma2(cntTri,:) = interp1(1:size(sigma,2),sigma(cntTri,:),1:1/(int_num):size(sigma,2),'spline'); % spline ³»»ğ(º¸°£¹ı)
    sigma2(cntTri,:) = conv(sigma2(cntTri,:),ones(1,w)/w,'same');
end
sigma3 = sigma2;
sigma3(sigma_f~=1,:) = 0; % masking
% figure; plot(sigma2','DisplayName','sigma3')
% figure; plot(sigma3','DisplayName','sigma3')
% figure; plot(mean(sigma2),'DisplayName','sigma3')
% figure; plot(mean(sigma3),'DisplayName','sigma3')

[~, avg_peak] = max(mean(sigma3));
sigma_peak(1,1:size(sigma3,1))=0;
for sigma_Tri = 1:size(sigma3,1)
    [~, sigma_peak(1,sigma_Tri)] = max(sigma3(sigma_Tri,w/2+1:round(size(sigma3,2)))); % min peak in each Tri(-)
    sigma_peak(1,sigma_Tri) = sigma_peak(1,sigma_Tri)+w/2;
end

sigma_peak2 = sigma_peak - avg_peak ;
sigma_peak2(sigma_peak2==-avg_peak+w/2+1)=0;
sigma_peak2(sigma_peak2>=100)=0;
sigma_peak2(sigma_peak2<=-100)=0;
sigma_peak2 = sigma_peak2';
[TimeLag_Image(:,:)] = FxEIT_Tri2Grid(Data.Element,Data.Node,sigma_peak2,256);

end



