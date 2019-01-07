function [ Drager_Cursor ] = FxDrager_Cursor1( Drager_ChangeRef, width1, width2 )
 Drager.EIT_waveform = Drager_ChangeRef.EIT_2_waveform;
 Drager.EIT_sigma = Drager_ChangeRef.EIT_0_sigma;
 
figure;plot(Drager.EIT_waveform);
[Drager.first.dot,~] = ginput(1);
Drager.first.dot = round(Drager.first.dot);
Drager.first.section = Drager.first.dot-round(width1/2) : Drager.first.dot+round(width1/2);
hold on; plot(Drager.first.section, Drager.EIT_waveform(Drager.first.section), 'r')

[Drager.second.dot,~] = ginput(1);
Drager.second.dot = round(Drager.second.dot);
Drager.second.section = Drager.second.dot-round(width2/2) : Drager.second.dot+round(width2/2);
plot(Drager.second.section,Drager.EIT_waveform(Drager.second.section),'r')

Drager.first.EIT_sigma = Drager.EIT_sigma(:,Drager.first.dot-round(width1/2) : Drager.first.dot+round(width1/2));
Drager.second.EIT_sigma = Drager.EIT_sigma(:,Drager.second.dot-round(width2/2) : Drager.second.dot+round(width2/2));


Drager_Cursor = Drager;
end

