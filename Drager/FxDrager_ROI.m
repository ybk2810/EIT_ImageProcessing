function [ Drager_ROI ] = FxDrager_ROI( ROI, Drager_ROI_mask, Drager_DynamicIMG, imgscale, Cmap )

%% ROI0(global)
Drager.ROI0 = sum(sum(Drager_DynamicIMG.Dynamic_IMG_NaN));
Drager.ROI0 = reshape(Drager.ROI0 ,1, size(Drager.ROI0,3));

if ROI==1
    % ROI setting1
    [ Drager.ROI1 ] = FxDrager_ROI1( Drager_DynamicIMG, Drager_ROI_mask, imgscale, Cmap );
elseif ROI==2
    % ROI setting2
    [ Drager.ROI2 ] = FxDrager_ROI2( Drager_DynamicIMG, Drager_ROI_mask, imgscale, Cmap );
elseif ROI==3
    % ROI setting3
    [ Drager.ROI3 ] = FxDrager_ROI3( Drager_DynamicIMG, Drager_ROI_mask, imgscale, Cmap );
elseif ROI==4
    % ROI setting4
    [ Drager.ROI4 ] = FxDrager_ROI4( Drager_DynamicIMG, Drager_ROI_mask, imgscale, Cmap );
end

Drager_ROI = Drager;
end


