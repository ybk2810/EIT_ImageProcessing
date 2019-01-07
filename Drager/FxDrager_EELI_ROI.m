function [ Drager_ROI_EELI ] = FxDrager_EELI_ROI( ROI, Drager_ROI_mask, Drager_DynamicIMG_EELI_C1, Drager_DynamicIMG_EELI_C2, imgscale, Cmap )
%% ROI0(global)
Drager.ROI0 = sum(sum(Drager_DynamicIMG_EELI_C2.Dynamic_IMG_NaN(:,:,end)))-sum(sum(Drager_DynamicIMG_EELI_C1.Dynamic_IMG_NaN(:,:,end)));
% Drager.ROI0 = reshape(Drager.ROI0 ,1, size(Drager.ROI0,3));

if ROI==1
    % ROI setting1

    Drager_DynamicIMG_EELI.Dynamic_IMG_NaN = Drager_DynamicIMG_EELI_C2.Dynamic_IMG_NaN(:,:,end) - Drager_DynamicIMG_EELI_C1.Dynamic_IMG_NaN(:,:,end);
    [ Drager.ROI1 ] = FxDrager_ROI1( Drager_DynamicIMG_EELI, Drager_ROI_mask, imgscale, Cmap );
%     Drager.ROI1.first = Drager.ROI1_C2.first - Drager.ROI1_C1.first;
%     Drager.ROI1.second = Drager.ROI1_C2.second - Drager.ROI1_C1.second;
%     Drager.ROI1.third = Drager.ROI1_C2.third - Drager.ROI1_C1.third;
%     Drager.ROI1.fourth = Drager.ROI1_C2.fourth - Drager.ROI1_C1.fourth;
elseif ROI==2
    % ROI setting2
    [ Drager.ROI2_C1 ] = FxDrager_ROI2( Drager_DynamicIMG_EELI_C1, Drager_ROI_mask, imgscale, Cmap );
    [ Drager.ROI2_C2 ] = FxDrager_ROI2( Drager_DynamicIMG_EELI_C2, Drager_ROI_mask, imgscale, Cmap );
    Drager.ROI2.first = Drager.ROI2_C2.first - Drager.ROI2_C1.first;
    Drager.ROI2.second = Drager.ROI2_C2.second - Drager.ROI2_C1.second;
    Drager.ROI2.third = Drager.ROI2_C2.third - Drager.ROI2_C1.third;
    Drager.ROI2.fourth = Drager.ROI2_C2.fourth - Drager.ROI2_C1.fourth;
elseif ROI==3
    % ROI setting3
    [ Drager.ROI3_C1 ] = FxDrager_ROI3( Drager_DynamicIMG_EELI_C1, Drager_ROI_mask, imgscale, Cmap );
    [ Drager.ROI3_C2 ] = FxDrager_ROI3( Drager_DynamicIMG_EELI_C2, Drager_ROI_mask, imgscale, Cmap );
    Drager.ROI3.first = Drager.ROI3_C2.first - Drager.ROI3_C1.first;
    Drager.ROI3.second = Drager.ROI3_C2.second - Drager.ROI3_C1.second;
    Drager.ROI3.third = Drager.ROI3_C2.third - Drager.ROI3_C1.third;
    Drager.ROI3.fourth = Drager.ROI3_C2.fourth - Drager.ROI3_C1.fourth;
elseif ROI==4
    % ROI setting4
    [ Drager.ROI4_C1 ] = FxDrager_ROI4( Drager_DynamicIMG_EELI_C1, Drager_ROI_mask, imgscale, Cmap );
    [ Drager.ROI4_C2 ] = FxDrager_ROI4( Drager_DynamicIMG_EELI_C2, Drager_ROI_mask, imgscale, Cmap );
    Drager.ROI4.first = Drager.ROI4_C2.first - Drager.ROI4_C1.first;
    Drager.ROI4.second = Drager.ROI4_C2.second - Drager.ROI4_C1.second;
    Drager.ROI4.third = Drager.ROI4_C2.third - Drager.ROI4_C1.third;
    Drager.ROI4.fourth = Drager.ROI4_C2.fourth - Drager.ROI4_C1.fourth;
end
Drager_ROI_EELI = Drager; clear Drager;



end


