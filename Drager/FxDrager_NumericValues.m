function [ Drager_NumericValues ] = FxDrager_NumericValues( Drager_DynamicIMG, Drager_ROI_mask, Drager_ROI, Drager_Cursor2, Drager_StatusIMG, imgscale, Cmap )
Drager.TidalRate = (Drager_StatusIMG.count(end)-Drager_StatusIMG.count(end-60*50));
%% 1 한 호흡에서의 전체 프레임 중 최대 최소 
[~,maximumsection] = max(Drager_ROI.ROI0(Drager_Cursor2.x));
[~,minimumsection] = min(Drager_ROI.ROI0(Drager_Cursor2.x));
Drager.global = max(Drager_ROI.ROI0(Drager_Cursor2.x(maximumsection)))-min(Drager_ROI.ROI0(Drager_Cursor2.x(minimumsection)));
Drager.first = max(Drager_ROI.ROI1.first(Drager_Cursor2.x(maximumsection)))-min(Drager_ROI.ROI1.first(Drager_Cursor2.x(minimumsection)));
Drager.second = max(Drager_ROI.ROI1.second(Drager_Cursor2.x(maximumsection)))-min(Drager_ROI.ROI1.second(Drager_Cursor2.x(minimumsection)));
Drager.third = max(Drager_ROI.ROI1.third(Drager_Cursor2.x(maximumsection)))-min(Drager_ROI.ROI1.third(Drager_Cursor2.x(minimumsection)));
Drager.fourth = max(Drager_ROI.ROI1.fourth(Drager_Cursor2.x(maximumsection)))-min(Drager_ROI.ROI1.fourth(Drager_Cursor2.x(minimumsection)));

%% 2 Tidal Image는 이미 흡기말-흡기초 한 이미지이므로 그 이미지의 합
% Drager_DynamicIMG.Dynamic_IMG_NaN = Drager_StatusIMG.Tidal_IMG_NaN(:,:,Drager_StatusIMG.index==Drager_Cursor2.breath);
% Drager_ROI_mask.Tidal_Image = Drager_StatusIMG.Tidal_IMG_NaN(:,:,Drager_StatusIMG.index==Drager_Cursor2.breath);
% 
% [ Drager ] = FxDrager_ROI1( Drager_DynamicIMG, Drager_ROI_mask, imgscale, Cmap );
% 
% Drager.global = sum(sum(Drager_ROI_mask.Tidal_Image));

Drager.first = round(Drager.first/Drager.global*100);
Drager.second = round(Drager.second/Drager.global*100);
Drager.third = round(Drager.third/Drager.global*100);
Drager.fourth = round(Drager.fourth/Drager.global*100);
Drager.global = round(Drager.global/Drager.global*100);

Drager_NumericValues = Drager;

Drager_DynamicIMG.Dynamic_IMG_NaN = Drager_StatusIMG.IMG_NaN(:,:,Drager_StatusIMG.index==Drager_Cursor2.breath);
Drager_ROI_mask.Tidal_Image = Drager_StatusIMG.IMG_NaN(:,:,Drager_StatusIMG.index==Drager_Cursor2.breath);

[ Drager ] = FxDrager_ROI1( Drager_DynamicIMG, Drager_ROI_mask, imgscale, Cmap );
end

