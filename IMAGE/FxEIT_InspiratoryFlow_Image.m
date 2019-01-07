function [ InspiratoryFlow_Image ] = FxEIT_InspiratoryFlow_Image( Data, EIT_ref, DataSet, Breath )
Temp_ref = Data.Proj_Mat * mean(DataSet.EIT_L(:,EIT_ref(1):EIT_ref(2)),2); % boundary artifact remover

% interpolation & mov avg for phase image
int_num = 3;
w = 4; % window size        
Temp = Data.Proj_Mat * DataSet.EIT_L(:,Breath); % one breath % boundary artifact remover
sigma = -Data.inv_Sense_weighted_avg * (Temp - repmat(Temp_ref,1,size(Temp,2))); % Sensitivity matrix(weighted method)
% sigma(sigma_f~=1,:) = 0; % masking
% patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,sigma(:,120),'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
% axis equal; caxis([-80 80]); axis off; colormap(Cmap1);
[ sigma2 ] = FxEIT_interp( sigma, int_num, w );
sigma2 = sigma2(:,w/2+1:end);

for sigma_Tri = 1:size(sigma2,1)
    min_Tri(sigma_Tri) = sigma2(sigma_Tri,1);
    [max_Tri(sigma_Tri), max_Tri_x(sigma_Tri)] = max(sigma2(sigma_Tri,:));

    standard_Tri_90_dot = (max_Tri(sigma_Tri)-min_Tri(sigma_Tri))*0.9+min_Tri(sigma_Tri);
    standard_Tri_90_x = [];
    for time = 1:max_Tri_x(sigma_Tri)
        if sigma2(sigma_Tri,time)<standard_Tri_90_dot
            standard_Tri_90_x(1,time) = 1;
        else
            standard_Tri_90_x(1,time) = 0;
        end
    end

    standard_Tri_10_dot = (max_Tri(sigma_Tri)-min_Tri(sigma_Tri))*0.1+min_Tri(sigma_Tri);
    standard_Tri_10_x = [];
    for time = 1:max_Tri_x(sigma_Tri)
        if sigma2(sigma_Tri,time)<standard_Tri_10_dot
            standard_Tri_10_x(1,time) = 1;
        else
            standard_Tri_10_x(1,time) = 0;
        end
    end

    standard_Tri(sigma_Tri,1) = (standard_Tri_90_dot - standard_Tri_10_dot) / sum(standard_Tri_90_x(1,:) - standard_Tri_10_x(1,:));
    if standard_Tri(sigma_Tri,1) == NaN
        standard_Tri(sigma_Tri,1) = 0;
    end
    if standard_Tri(sigma_Tri,1) == inf
        standard_Tri(sigma_Tri,1) = 0;
    end
end
standard_Tri(isnan(standard_Tri))=0;
[InspiratoryFlow_Image] = FxEIT_Tri2Grid(Data.Element,Data.Node,standard_Tri,256);

end
