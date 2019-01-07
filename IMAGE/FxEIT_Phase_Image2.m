% if not have PV data, you can use this function.
% point(PEEP,Breath)

function [ Phase_Image ] = FxEIT_Phase_Image2( Data, EIT_ref, DataSet, sigma_f, point )
meshsize = max(max(abs(Data.Node)))*1.05; % depend on original Image
pixel_num = 256;
for j = 1:size(Data.Element,1)
    xy(j,:) = mean(Data.Node(Data.Element(j,1:3),:));
end
ti = -meshsize:(2*meshsize)/(pixel_num-1):meshsize;
[qx,qy] = meshgrid(ti,ti);

% reference
Temp_ref = Data.Proj_Mat * mean(DataSet.EIT_filt_L(:,EIT_ref(1):EIT_ref(2)),2); % boundary artifact remover

% Phase Image
% interpolation & mov avg for phase image
int_num = 3;

for cntPEEP = 1:size(point,1) % PEEP
    for cntBreath = 1:size(point,1) % Breath        
        a = point(cntPEEP,cntBreath);
        Temp = Data.Proj_Mat * DataSet.EIT_filt_L(:,a-40:a+40); % one breath % boundary artifact remover
        
%         figure; plotyy(1:150,sum(DataSet.EIT_filt_L(:,a-50:a+99)),1:150,Temp_PV); title('EIT voltage data in one breath'); xlabel('scan'); %ylabel('Impedance');
        
        sigma = Data.inv_Sense_weighted_avg * (Temp - repmat(Temp_ref,1,size(Temp,2))); % Sensitivity matrix(weighted method)
        sigma(sigma_f~=1,:) = 0; % masking
%         patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,sigma(:,120),'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
%         axis equal; caxis([-80 80]); axis off;
        
        for cntTri = 1:size(sigma,1)
            sigma2(cntTri,:) = interp1(1:size(sigma,2),sigma(cntTri,:),1:1/(int_num):size(sigma,2),'spline');
        end
        
%         figure; plot(sigma2(3035,:)','DisplayName','sigma2'); title('interpolated sigma in one breath');
%         figure; plotyy(1:150,sigma,1:150,Temp_PV); title('sigma in one breath'); xlabel('scan'); %ylabel('Impedance');
        
        [~, avg_peak] = min(mean(sigma2));
        
        for sigma_Tri = 1:size(sigma2,1)
            [~, sigma_peak(1,sigma_Tri)] = min(sigma2(sigma_Tri,1:size(sigma2,2)/2)'); % min peak in each Tri(-)
        end

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
        sigma_peak3(:,cntBreath) = sigma_peak2(:,:);
        
        disp(num2str(cntBreath))
    end
    sigma_peak4 = mean(sigma_peak3,2);
    
    F = TriScatteredInterp(xy(:,1),xy(:,2),sigma_peak4);
    Phase_Image(:,:,cntPEEP) = F(qx,qy);
    
    disp(num2str(cntPEEP))
end
end



