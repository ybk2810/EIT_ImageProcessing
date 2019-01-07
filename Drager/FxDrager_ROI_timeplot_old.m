function [ Drager4 ] = FxDrager_ROI_timeplot_old( Drager2, Drager4, recount )
Drager4.ROI3.first(recount) = sum(sum(Drager4.Image_NaN((Drager4.Center+Drager4.Indicater_max)/2+1:Drager4.Indicater_max,:)));
Drager4.ROI3.second(recount) = sum(sum(Drager4.Image_NaN(Drager4.Center+1:(Drager4.Center+Drager4.Indicater_max)/2,:)));
Drager4.ROI3.third(recount) = sum(sum(Drager4.Image_NaN((Drager4.Indicater_min+Drager4.Center)/2+1:Drager4.Center,:)));
Drager4.ROI3.fourth(recount) = sum(sum(Drager4.Image_NaN(Drager4.Indicater_min:(Drager4.Indicater_min+Drager4.Center)/2,:)));




if length(Drager4.ROI3.first)<1000
    temp = Drager4.time(1):1/50:Drager4.time+1000/50;
else
    temp = Drager4.time(end)-1000/50:1/50:Drager4.time(end);

end

plot_time.start = 1;
plot_time.finish = 1000;

plot_time.center(1) = round((plot_time.start + plot_time.finish)/2); 
plot_time.center(2) = round((plot_time.start + plot_time.center(1))/2);
plot_time.center(3) = round((plot_time.center(1) + plot_time.finish)/2); 
plot_time.center(4) = round((plot_time.start + plot_time.center(2))/2);
plot_time.center(5) = round((plot_time.center(2) + plot_time.center(1))/2); 
plot_time.center(6) = round((plot_time.center(1) + plot_time.center(3))/2);
plot_time.center(7) = round((plot_time.center(3) + plot_time.finish)/2);
plot_time.section(1) = plot_time.start;     plot_time.section(2) = plot_time.center(4); 
plot_time.section(3) = plot_time.center(2); plot_time.section(4) = plot_time.center(5); 
plot_time.section(5) = plot_time.center(1); plot_time.section(6) = plot_time.center(6); 
plot_time.section(7) = plot_time.center(3); plot_time.section(8) = plot_time.center(7); 
plot_time.section(9) = plot_time.finish; 
plot_time.cemicolon = ':';

for i = 1:length(plot_time.section)
    plot_time.hms(i,1) = fix(temp(plot_time.section(i))/3600);
    plot_time.hms(i,2) = fix(rem(temp(plot_time.section(i)),3600)/60);
    plot_time.hms(i,3) = round(rem(rem(temp(plot_time.section(i)),3600),60));
    plot_time.time(i).time = strcat(num2str(plot_time.hms(i,1)), plot_time.cemicolon, num2str(plot_time.hms(i,2)), plot_time.cemicolon, num2str(plot_time.hms(i,3)));
end
clear i

figure(1);subplot(6,6,[ 15 16 17 18 ])

if length(Drager4.ROI3.first)<1001
    plot(Drager4.ROI3.first,'LineWidth',2); hold on;
    plot(Drager2.reference_instant(1:end),Drager4.ROI3.first(Drager2.reference_instant(1:end)),'r*')
    plot(Drager2.inhale_instant(2:end),Drager4.ROI3.first(Drager2.inhale_instant(2:end)),'k*')
else
    plot(Drager4.ROI3.first(recount-1000:recount),'LineWidth',2); hold on;
    temp = Drager2.reference_instant(Drager2.reference_instant>recount-1000);
    plot(temp-(recount-1000),Drager4.ROI3.first(temp),'r*')
    temp = Drager2.inhale_instant(Drager2.inhale_instant>recount-1000);
    plot(temp-(recount-1000),Drager4.ROI3.first(temp),'k*')

end

%     plot(Drager4.EIT_waveform,'LineWidth',2); hold on;
%     plot(Drager4.reference_instant(2:end),Drager4.EIT_waveform(Drager4.reference_instant(2:end)),'r*')
%     plot(Drager4.inhale_instant(2:end),Drager4.EIT_waveform(Drager4.inhale_instant(2:end)),'k*')
% if length(Drager4.EIT_waveform)<1001
%     set(gca,'xlim',([0 1000]));
% else
%     set(gca,'xlim',([length(Drager4.EIT_waveform)-1000 length(Drager4.EIT_waveform)]));
% end

set(gca,'xlim',([0 1000]));
set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
set(gca,'xticklabel',{plot_time.time(:).time});
xlabel('Time(hh:mm:ss)');
ylabel('dZglobal');
title('Impedance Waveforms');
hold off;
%     saveas(gcf,sprintf('video_%6.0f.jpg',recount),'jpg');
end

