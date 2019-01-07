function [ Drager_EELI_NumericValues ] = FxDrager_EELI_NumericValues( Drager_DynamicIMG, Drager_ROI_mask, Drager_ROI, Drager_Cursor2, Drager_StatusIMG, imgscale, Cmap )
Drager.TidalRate = (Drager_StatusIMG.count(end)-Drager_StatusIMG.count(end-60*50));
%% 1 �� ȣ������ ��ü ������ �� �ִ� �ּ� 
[~,maximumsection] = max(Drager_ROI.ROI0);
[~,minimumsection] = min(Drager_ROI.ROI0);
Drager.global = max(Drager_ROI.ROI0(maximumsection))-min(Drager_ROI.ROI0(minimumsection));
Drager.first = max(Drager_ROI.ROI4.first(maximumsection))-min(Drager_ROI.ROI4.first(minimumsection));
Drager.second = max(Drager_ROI.ROI4.second(maximumsection))-min(Drager_ROI.ROI4.second(minimumsection));
Drager.third = max(Drager_ROI.ROI4.third(maximumsection))-min(Drager_ROI.ROI4.third(minimumsection));
Drager.fourth = max(Drager_ROI.ROI4.fourth(maximumsection))-min(Drager_ROI.ROI4.fourth(minimumsection));

%% 2 Tidal Image�� �̹� ��⸻-����� �� �̹����̹Ƿ� �� �̹����� ��
% Drager_DynamicIMG.Dynamic_IMG_NaN = Drager_StatusIMG.Tidal_IMG_NaN(:,:,Drager_StatusIMG.index==Drager_Cursor2.breath);
% Drager_ROI_mask.Tidal_Image = Drager_StatusIMG.Tidal_IMG_NaN(:,:,Drager_StatusIMG.index==Drager_Cursor2.breath);
% 
% [ Drager ] = FxDrager_ROI4( Drager_DynamicIMG, Drager_ROI_mask, imgscale, Cmap );
% 
% Drager.global = sum(sum(Drager_ROI_mask.Tidal_Image));

Drager.first = round(Drager.first/Drager.global*100);
Drager.second = round(Drager.second/Drager.global*100);
Drager.third = round(Drager.third/Drager.global*100);
Drager.fourth = round(Drager.fourth/Drager.global*100);
Drager.global = round(Drager.global/Drager.global*100);

Drager_EELI_NumericValues = Drager;

Drager_DynamicIMG.Dynamic_IMG_NaN = Drager_StatusIMG.Tidal_IMG_NaN(:,:,Drager_StatusIMG.index==Drager_Cursor2.breath);
Drager_ROI_mask.Tidal_Image = Drager_StatusIMG.Tidal_IMG_NaN(:,:,Drager_StatusIMG.index==Drager_Cursor2.breath);

[ Drager ] = FxDrager_ROI4( Drager_DynamicIMG, Drager_ROI_mask, imgscale, Cmap );
end

