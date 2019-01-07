function [ Drager_Cursor2 ] = FxDrager_Cursor2( Drager_ChangeRef, Drager_StatusIMG )
 Drager.EIT_waveform = Drager_ChangeRef.EIT_2_waveform;
 Drager.EIT_sigma = Drager_ChangeRef.EIT_0_sigma;
 
figure;plot(Drager.EIT_waveform);
[Drager.dot,~] = ginput(1);
Drager.dot = round(Drager.dot);
Drager.breath = Drager_StatusIMG.count(Drager.dot);

X = Drager_StatusIMG.count;
[~,Drager.x]=find(X==Drager.breath);
Drager.IMG = Drager_StatusIMG.IMG(:,:,Drager_StatusIMG.index==Drager.breath);

hold on; plot(Drager.x, Drager.EIT_waveform(Drager.x), 'r')
Drager_Cursor2 = Drager;
end

