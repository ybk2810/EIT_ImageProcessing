function [ TimeLag_Image ] = FxEIT_TimeLasssg_Image( Data, EIT_ref, DataSet )
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
    a = DataSet.Breath(DataSet.PEEP(1).index(2)).index(1); % start
    b = DataSet.Breath(DataSet.PEEP(1).index(end-1)).index(end); % finish
    Temp_f = Data.Proj_Mat * DataSet.EIT_filt_L(:,a:b); % boundary artifact remover
    sigma_f = -Data.inv_Sense_weighted_avg*Temp_f; % Sensitivity matrix(weighted method)
    sigma_f = mean(sigma_f,2);
%     sigma_f = sigma_f';

    threshold = 30;
    th = max(max(sigma_f(:,:)))*threshold*0.01;
    sigma_f(sigma_f<=th) = 0; sigma_f(sigma_f>=th) = 1; clear threshold th;
    patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,sigma_f(:,:),'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
    axis equal; caxis([-1 1]); axis off;

    % Phase Image
    % interpolation & mov avg for phase image
    int_num = 3;
    w = 90; % window size 
    k = ones(1, w) / w;

    for cntPEEP = 1:length(DataSet.PEEP) % PEEP
        for cntBreath = 2:length(DataSet.PEEP(cntPEEP).index)-1 % Breath        
            a = DataSet.Breath(DataSet.PEEP(cntPEEP).index(cntBreath)).inhale;
            Temp = Data.Proj_Mat * DataSet.EIT_filt_L(:,a-50:a+99); % one breath % boundary artifact remover

            sigma = Data.inv_Sense_weighted_avg * (Temp - repmat(Temp_ref,1,size(Temp,2))); % Sensitivity matrix(weighted method)
            sigma(sigma_f~=1,:) = 0; % masking
    %         patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,sigma(:,120),'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
    %         axis equal; caxis([-80 80]); axis off;

            for cntTri = 1:size(sigma,1)
                sigma2(cntTri,:) = interp1(1:size(sigma,2),sigma(cntTri,:),1:1/(int_num):size(sigma,2),'spline'); % spline ³»»ð(º¸°£¹ý)
                sigma2(cntTri,:) = conv(sigma2(cntTri,:),ones(1,w)/w,'same');
            end

            [~, avg_peak] = min(mean(sigma2));

            for sigma_Tri = 1:size(sigma2,1)
                [~, sigma_peak(1,sigma_Tri)] = min(sigma2(sigma_Tri,w/2+1:size(sigma2,2)/2)'); % min peak in each Tri(-)
                sigma_peak(1,sigma_Tri) = sigma_peak(1,sigma_Tri)+w/2;
            end

            sigma_peak2 = sigma_peak - avg_peak;
            sigma_peak2(sigma_peak2==-avg_peak+1)=0;
            sigma_peak2(sigma_peak2>=50)=0;
            sigma_peak2(sigma_peak2<=-50)=0;

            sigma_peak2 = sigma_peak2';
            sigma_peak3(:,cntBreath-1) = sigma_peak2(:,:);

            disp(num2str(cntBreath))
        end
        sigma_peak4 = mean(sigma_peak3,2);

        F = TriScatteredInterp(xy(:,1),xy(:,2),sigma_peak4);
        TimeLag_Image(:,:,cntPEEP) = F(qx,qy);

        disp(num2str(cntPEEP))
    end
end



