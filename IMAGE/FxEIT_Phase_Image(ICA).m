function [ Phase_Image ] = FxEIT_Phase_Image( Data, EIT_ref, DataSet, a, b )
meshsize = max(max(abs(Data.Node)))*1.05; % depend on original Image
pixel_num = 256;
for j = 1:size(Data.Element,1)
    xy(j,:) = mean(Data.Node(Data.Element(j,1:3),:));
end
ti = -meshsize:(2*meshsize)/(pixel_num-1):meshsize;
[qx,qy] = meshgrid(ti,ti);

% reference
Temp_ref = Data.Proj_Mat * mean(DataSet.EIT_filt_L(:,EIT_ref(1):EIT_ref(2)),2); % boundary artifact remover

% fEIT(Tidal Volume) image RIO masking Image
a = DataSet.Breath(DataSet.PEEP(3).index(2)).index(1); % start
b = DataSet.Breath(DataSet.PEEP(3).index(end-1)).index(end); % finish
Temp_f = Data.Proj_Mat * DataSet.EIT_filt_L(:,a:b); % boundary artifact remover
sigma_f = Data.inv_Sense_weighted_avg*Temp_f; % Sensitivity matrix(weighted method)
sigma_f = std(sigma_f');
sigma_f = sigma_f';

threshold = 30;
th = max(max(sigma_f(:,:)))*threshold*0.01;
sigma_f(sigma_f<=th) = 0; sigma_f(sigma_f>=th) = 1; clear threshold th;
% patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,sigma_f(:,:),'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
% axis equal; caxis([-1 1]); axis off;


% Phase Image
% interpolation & mov avg for phase image
int_num = 3;
w = 60; % window size 
k = ones(1, w) / w;

for cntPEEP = 1:length(DataSet.PEEP) % PEEP
    for cntBreath = 2:length(DataSet.PEEP(cntPEEP).index)-1 % Breath        
        a = DataSet.Breath(DataSet.PEEP(cntPEEP).index(cntBreath)).inhale;
        Temp = Data.Proj_Mat * DataSet.EIT_filt_L(:,a-50:a+99); % one breath % boundary artifact remover
        
%         Temp_PV = DataSet.PV_raw(a-50:a+99,2)';
%         figure; plotyy(1:150,sum(DataSet.EIT_filt_L(:,a-50:a+99)),1:150,Temp_PV); title('EIT voltage data in one breath'); xlabel('scan'); %ylabel('Impedance');
        
        sigma = Data.inv_Sense_weighted_avg * (Temp - repmat(Temp_ref,1,size(Temp,2))); % Sensitivity matrix(weighted method)
        sigma(sigma_f~=1,:) = 0; % masking
%         patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,sigma(:,120),'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
%         axis equal; caxis([-80 80]); axis off;
        
%         Temp_PV2 = interp1(1:size(sigma,2),Temp_PV,1:1/(int_num):size(Temp_PV,2),'spline');
%         Temp_PV2 = sum(Temp_PV2);
        for cntTri = 1:size(sigma,1)
            sigma2(cntTri,:) = interp1(1:size(sigma,2),sigma(cntTri,:),1:1/(int_num):size(sigma,2),'spline'); % spline ³»»ð(º¸°£¹ý)
            sigma2(cntTri,:) = conv(sigma2(cntTri,:),ones(1,w)/w,'same');
        end
        
%         figure; plot(sigma2(3035,:)','DisplayName','sigma2'); title('interpolated sigma in one breath');
%         figure; plotyy(1:150,sigma,1:150,Temp_PV); title('sigma in one breath'); xlabel('scan'); %ylabel('Impedance');
        
        [~, avg_peak] = min(mean(sigma2));
        
        for sigma_Tri = 1:size(sigma2,1)
%             if sigma2(sigma_Tri,avg_peak) < 0
                [~, sigma_peak(1,sigma_Tri)] = min(sigma2(sigma_Tri,w/2+1:size(sigma2,2)/2)'); % min peak in each Tri(-)
%                 [~, sigma_peak(1,sigma_Tri)] = min(sigma2(sigma_Tri,1:size(sigma2,2)/2)'); % min peak in each Tri(-)
% %                 [~, sigma_peak11(1,sigma_Tri)] = min(sigma2(sigma_Tri,:)');% min peak in each Tri(-)
%             else
%                 [~, sigma_peak(1,sigma_Tri)] = max(sigma2(sigma_Tri,w/2+1:size(sigma2,2)/2)'); % max peak in each Tri(+)
% %                 [~, sigma_peak11(1,sigma_Tri)] = max(sigma2(sigma_Tri,:)');% max peak in each Tri(+)
%             end
            sigma_peak(1,sigma_Tri) = sigma_peak(1,sigma_Tri)+w/2;
% %             if sigma_peak(1,sigma_Tri)~=sigma_peak11(1,sigma_Tri)
% %                 plot(sigma2(sigma_Tri,:))
% %                 disp(num2str(sigma_Tri))
% %                 pause(1) 
% %             end
        end

%         sigma_peak2 = sigma_peak - Temp_PV2;
        sigma_peak2 = sigma_peak - avg_peak;
        sigma_peak2(sigma_peak2==-avg_peak+1)=0;
        
        sigma_peak2(sigma_peak2>=50)=0;
        sigma_peak2(sigma_peak2<=-50)=0;
        
%         roc=1;
%         for i=1:length(mask)
%             if mask(i)==1
%                 sigma3(roc,:) = sigma2(i,:);
%                 roc=roc+1;
%                 plot(sigma2(i,:));
%                 pause(0.001);
%                 disp(num2str(i))
%             end
%         end
%         
%         figure; plot(sigma3','DisplayName','sigma3');
%         figure; plot(mean(sigma2)); title('avg sigma');
%         for i=1:10
%             set(figure(i), 'Position', [100 100 300 150]);
%             plot(sigma2(i+1000,:)'); set(gca,'xlim',([1 size(sigma2,2)]));
%         end
%         
%         figure;
%         for i=1:size(sigma3,1)
%                     figure(1)
%             plot(sigma3(i,:))
%             disp(num2str(i))
% %             pause(0.1) 
% %             ginput(1)
%             a = min(sigma3(i,1:size(sigma2,2)/2)');
%             b = min(sigma3(i,:)');
%             if a~=b
%                 ginput(1)
%             end
%         end
%         
%         set(figure(1), 'Position', [100 100 300 150]); plot(sigma_peak); title('Phase'); set(gca,'xlim',([1 length(sigma_peak)]));xlabel('Tri'); ylabel('phase'); 
%         set(figure(1), 'Position', [100 100 400 200]); plot(sigma_peak2); title('Phase(offset)'); set(gca,'xlim',([1 length(sigma_peak)]));xlabel('Tri'); ylabel('phase'); 
%         set(figure(1), 'Position', [100 100 400 200]); plot(sigma_peak3); title('Phase(mask)'); set(gca,'xlim',([1 length(sigma_peak)]));xlabel('Tri'); ylabel('phase'); 

        sigma_peak2 = sigma_peak2';
        sigma_peak3(:,cntBreath-1) = sigma_peak2(:,:);
        
        disp(num2str(cntBreath))
    end
    sigma_peak4 = mean(sigma_peak3,2);
    
    F = TriScatteredInterp(xy(:,1),xy(:,2),sigma_peak4);
    Phase_Image(:,:,cntPEEP) = F(qx,qy);
    
    disp(num2str(cntPEEP))
end
end



