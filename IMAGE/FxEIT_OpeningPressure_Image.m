function [ OpeningPressure_Image2 ] = FxEIT_OpeningPressure_Image( Data, EIT_ref, DataSet, sigma_f )
Temp_ref = Data.Proj_Mat * mean(DataSet.EIT_L(:,EIT_ref(1):EIT_ref(2)),2); % boundary artifact remover

% Ventilation_delay_Image
% interpolation & mov avg for phase image
    
% int_num = 4;
% w = 90; % window size 
    for cntPEEP = 1:length(DataSet.PEEP) % PEEP
        for cntBreath = 1:length(DataSet.PEEP(cntPEEP).index) % Breath        
            Temp = Data.Proj_Mat * DataSet.EIT_L(:,DataSet.Breath(DataSet.PEEP(cntPEEP).index(cntBreath)).index); % one breath % boundary artifact remover

            sigma = -Data.inv_Sense_weighted_avg * (Temp - repmat(Temp_ref,1,size(Temp,2))); % Sensitivity matrix(weighted method)
            sigma(sigma_f~=1,:) = 0; % masking
    %         patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,sigma(:,120),'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
    %         axis equal; caxis([-80 80]); axis off; colormap(Cmap1);
    
            tEI = sum(DataSet.PV_raw(DataSet.Breath(DataSet.PEEP(cntPEEP).index(cntBreath)).index,2));
%             [ sigma2 ] = FxEIT_interp(sigma(:,1:tEI), int_num, w );
            sigma2=sigma;
%             sigma2 = sigma2(:,w/2+1:end);
            sigma2_avg = mean(sigma2,1);
            
            standard_Tri=[];
            
            min_Tri = sigma2(:,1);
            max_Tri = max(sigma2')';
            th_Tri = (max_Tri-min_Tri)*0.1+min_Tri;
            for cntSigma = 1:size(sigma2,1)                
                temp_sigma = sigma2(cntSigma,:)';
                temp_sigma(temp_sigma>=th_Tri(cntSigma)) = 0;
                temp_sigma(temp_sigma~=0) = 1;
                standard_Tri(cntSigma,1)= sum(temp_sigma);
                Popen(cntSigma,1) = standard_Tri(cntSigma,1);
                if standard_Tri(cntSigma,1) ~= 0
                    Popen(cntSigma,1) = DataSet.PV_raw(DataSet.Breath(DataSet.PEEP(cntPEEP).index(cntBreath)).index(1)+standard_Tri(cntSigma,1)-1,3);
                end
            end
            standard_Tri2(:,cntBreath) = Popen(:,1);
        end
        standard_Tri3 = mean(standard_Tri2,2);
%         clear standard_Tri2
        [OpeningPressure_Image] = FxEIT_Tri2Grid(Data.Element,Data.Node,standard_Tri3,256);
        
        disp(num2str(cntPEEP))
        temp = [0 5 10 15 20 25 20 15 10 5 0];
%         temp = [0 5 10 15 20 5];
        OpeningPressure_Image = OpeningPressure_Image-temp(cntPEEP);
        OpeningPressure_Image(OpeningPressure_Image == -temp(cntPEEP)) = 0;
        OpeningPressure_Image2(:,:,cntPEEP) = OpeningPressure_Image;
        
    end
end



