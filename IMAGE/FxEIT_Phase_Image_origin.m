function [ Phase_Image ] = FxEIT_Phase_Image_origin( Data, EIT_ref, DataSet )
meshsize = max(max(abs(Data.Node)))*1.05; % depend on original Image
pixel_num = 256;
for j = 1:size(Data.Element,1)
    xy(j,:) = mean(Data.Node(Data.Element(j,1:3),:));
end
ti = -meshsize:(2*meshsize)/(pixel_num-1):meshsize;
[qx,qy] = meshgrid(ti,ti);

% reference
Temp_ref = Data.Proj_Mat * mean(DataSet.EIT_filt(:,EIT_ref(1):EIT_ref(2)),2); % boundary artifact remover

% Phase Image
% interpolation & mov avg for phase image
int_num = 2;
w = 30; %윈도우 사이즈 
k = ones(1, w) / w;



for cntPEEP = 1:length(DataSet.PEEP) % PEEP
    for cntBreath = 2:length(DataSet.PEEP(cntPEEP).index)-1 % Breath        
        a = DataSet.Breath(DataSet.PEEP(cntPEEP).index(cntBreath)).inhale;
        Temp = Data.Proj_Mat * DataSet.EIT_filt(:,a-30:a+109); % one breath % boundary artifact remover
        sigma = Data.inv_Sense_weighted_avg * (Temp - repmat(Temp_ref,1,size(Temp,2))); % Sensitivity matrix(weighted method)
   
        for cntTri = 1:size(sigma,1)
            sigma2(cntTri,:) = interp1(1:size(sigma,2),sigma(cntTri,:),1:1/(int_num):size(sigma,2),'spline'); % spline 내삽(보간법)
            sigma2(cntTri,:) = conv(sigma2(cntTri,:),ones(1,w)/w,'same');
        end
        [~, sigma_peak] = min(sigma2(:,1:60)');% max인 시간정보 in each Tri
        
        sigma_diff = max(sigma2') - min(sigma2'); % masking
        sigma_diff(sigma_diff < 0.2*max(max(sigma2))) = 0;
        sigma_diff(sigma_diff > 0) = 1;
        mask = sigma_diff;
        
        [~, avg_peak] = min(mean(sigma2));
        sigma_peak = sigma_peak .* mask;
        sigma_peak = sigma_peak - avg_peak;
        sigma_peak = sigma_peak';
        sigma_peak2(:,cntBreath-1) = sigma_peak(:,:);
        disp(num2str(cntBreath))
    end
    sigma_peak3 = mean(sigma_peak2,2);
    
    F = TriScatteredInterp(xy(:,1),xy(:,2),sigma_peak3);
    Phase_Image(:,:,cntPEEP) = F(qx,qy);

    disp(num2str(cntPEEP))
end

end



        % % 호흡의 최솟길이
% for cnt = 1:length(DataSet.PEEP(cntPEEP).index) % Breath
%     min_breath(cnt) = min(length(DataSet.Breath(DataSet.PEEP(cntPEEP).index(cnt)).index));
% end
% min_breath = min(min_breath);
        
        
%         Temp = Data.Proj_Mat * DataSet.EIT_filt(:,DataSet.Breath(DataSet.PEEP(cntPEEP).index(cntBreath)).index(1:min_breath));% one breath
%         DataSet.Breath(DataSet.PEEP(cntPEEP).index(cntBreath)).index(1:min_breath)
%         
% 
%         sigma = Data.inv_Sense_weighted_avg * (Temp - repmat(Temp_ref,1,size(Temp,2)));

