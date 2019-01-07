function [ output_args ] = FxDrager_timeplot( Drager2, recount )

if length(Drager2.EIT_waveform)<1000
    temp = Drager2.time(1):1/50:Drager2.time+1000/50;
else
    temp = Drager2.time(end)-1000/50:1/50:Drager2.time(end);

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

figure(1);subplot(6,6,[ 3 4 5 6 9 10 11 12])

if length(Drager2.EIT_waveform)<1001
    plot(Drager2.EIT_waveform,'LineWidth',2); hold on;
    plot(Drager2.reference_instant(1:end),Drager2.EIT_waveform(Drager2.reference_instant(1:end)),'r*')
    plot(Drager2.inhale_instant(2:end),Drager2.EIT_waveform(Drager2.inhale_instant(2:end)),'k*')
else
    plot(Drager2.EIT_waveform(recount-1000:recount),'LineWidth',2); hold on;
    temp = Drager2.reference_instant(Drager2.reference_instant>recount-1000);
    plot(temp-(recount-1000),Drager2.EIT_waveform(temp),'r*')
    temp = Drager2.inhale_instant(Drager2.inhale_instant>recount-1000);
    plot(temp-(recount-1000),Drager2.EIT_waveform(temp),'k*')

end

%     plot(Drager2.EIT_waveform,'LineWidth',2); hold on;
%     plot(Drager2.reference_instant(2:end),Drager2.EIT_waveform(Drager2.reference_instant(2:end)),'r*')
%     plot(Drager2.inhale_instant(2:end),Drager2.EIT_waveform(Drager2.inhale_instant(2:end)),'k*')
% if length(Drager2.EIT_waveform)<1001
%     set(gca,'xlim',([0 1000]));
% else
%     set(gca,'xlim',([length(Drager2.EIT_waveform)-1000 length(Drager2.EIT_waveform)]));
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

