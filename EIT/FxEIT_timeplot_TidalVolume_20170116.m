function [ imgscale ] = FxEIT_timeplot_TidalVolume_20170116( time, plot_img, start, finish )

temp = time;
% plot_time.start = 1;
plot_time.start = start;
% plot_time.finish = length(temp);
plot_time.finish = finish;

plot_time.center(1) = round((plot_time.start + plot_time.finish)/2); 
plot_time.center(2) = round((plot_time.start + plot_time.center(1))/2);
plot_time.center(3) = round((plot_time.center(1) + plot_time.finish)/2); 
plot_time.center(4) = round((plot_time.start + plot_time.center(2))/2);
plot_time.center(5) = round((plot_time.center(2) + plot_time.center(1))/2); 
plot_time.center(6) = round((plot_time.center(1) + plot_time.center(3))/2);
plot_time.center(7) = round((plot_time.center(3) + plot_time.finish)/2);
plot_time.section(1) = plot_time.start; plot_time.section(2) = plot_time.center(4); 
plot_time.section(3) = plot_time.center(2); plot_time.section(4) = plot_time.center(5); 
plot_time.section(5) = plot_time.center(1); plot_time.section(6) = plot_time.center(6); 
plot_time.section(7) = plot_time.center(3); plot_time.section(8) = plot_time.center(7); 
plot_time.section(9) = plot_time.finish; 

plot_time.cemicolon = ':';
% plot_time.plot = temp(plot_time.start:plot_time.finish);

for i = 1:length(plot_time.section)
    plot_time.hms(i,1) = fix(temp(plot_time.section(i))/3600);
    plot_time.hms(i,2) = fix(rem(temp(plot_time.section(i)),3600)/60);
    plot_time.hms(i,3) = round(rem(rem(temp(plot_time.section(i)),3600),60));
    plot_time.time(i).time = strcat(num2str(plot_time.hms(i,1)), plot_time.cemicolon, num2str(plot_time.hms(i,2)), plot_time.cemicolon, num2str(plot_time.hms(i,3)));
end
clear i
%% Drager1
set(figure(1), 'Position', [100 100 900 300]);
subplot(2,12,[1 2 3 4 5 6 7 8 9 10 11 12]); plot(plot_img);
set(gca,'xlim',([plot_time.start plot_time.finish]));
set(gca,'ylim',([min(plot_img)-1000000 max(plot_img)+1000000]));
set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
set(gca,'xticklabel',{plot_time.time(:).time}); xlabel('Time(hh:mm:ss)'); ylabel('Zglobal');




end

