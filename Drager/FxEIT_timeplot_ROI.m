function [ Drager ] = FxEIT_timeplot_ROI( time, global_waveform, ROI, start, finish )

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

% EIT_proj = Data.Proj_Mat * DataSet.EIT_filt_L; sigma = Data.inv_Sense_weighted_avg * EIT_proj; clear EIT_proj; % C
% sigma = -sigma;
% 
% set(figure(1), 'Position', [550 100 1000 200]);
% plot(sum(sigma))
% title('EIT voltage raw data(PEEP(Pressure mode))');
% set(gca,'xlim',([plot_time.start plot_time.finish]));
% set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
% set(gca,'xticklabel',{plot_time.time(:).time});
% xlabel('Time(hh:mm:ss)');
% ylabel('Magnitude');

% set(figure(2), 'Position', [550 100 1000 200]);
% [AX,H1,H2]=plotyy(1:length(DataSet.time),sum(DataSet.EIT_filt_L),1:length(DataSet.time),DataSet.PV_raw(:,3));
% title('EIT voltage raw data after band pass filter');
% set(AX,'xlim',([plot_time.start plot_time.finish]));
% set(AX,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
% set(AX,'xticklabel',{plot_time.time(:).time});
% % set(get(AX,'Ylabel'),'String','Time(hh:mm:ss)') 
% xlabel('Time(hh:mm:ss)');
% set(get(AX(1),'Ylabel'),'String','Magnitude') 
% set(get(AX(2),'Ylabel'),'String','Paw')
% clear plot_time temp AX H1 H2

%% Drager1
% figure(1);subplot(3,4,[1 2 3 4]);
% plot(sum(DataSet.EIT_filt_L),'LineWidth',2); 
% title('Generation of EIT images');
% set(gca,'xlim',([plot_time.start plot_time.finish]));
% set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
% set(gca,'xticklabel',{plot_time.time(:).time});
% xlabel('Time(hh:mm:ss)');
% ylabel('dZglobal');

%% Drager_change reference
% figure(1);subplot(3,4,[1 2 3 4]);
% plot(DataSet.EIT_0_waveform,'LineWidth',2); title('origin');
% set(gca,'xlim',([plot_time.start plot_time.finish]));
% set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
% set(gca,'xticklabel',{plot_time.time(:).time}); xlabel('Time(hh:mm:ss)'); ylabel('dZglobal');
% 
% subplot(3,4,[5 6 7 8]);
% plot(DataSet.EIT_1_waveform,'LineWidth',2); title('change reference using each start of inspiration');
% set(gca,'xlim',([plot_time.start plot_time.finish]));
% set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
% set(gca,'xticklabel',{plot_time.time(:).time}); xlabel('Time(hh:mm:ss)'); ylabel('dZglobal');
% 
% subplot(3,4,[9 10 11 12]);
% plot(DataSet.EIT_2_waveform,'LineWidth',2); title('change reference using each start of inspiration(10ref avg)');
% set(gca,'xlim',([plot_time.start plot_time.finish]));
% set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
% set(gca,'xticklabel',{plot_time.time(:).time}); xlabel('Time(hh:mm:ss)'); ylabel('dZglobal');

%% Drager_StatusIMG
% figure(1); subplot(3,10,[1 2 3 4 5 6 7 8 9 10])
% plot(DataSet.waveform,'LineWidth',2); title('origin');
% set(gca,'xlim',([plot_time.start plot_time.finish]));
% set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
% set(gca,'xticklabel',{plot_time.time(:).time}); xlabel('Time(hh:mm:ss)'); ylabel('dZglobal');

%% Drager_ROI_waveform
Gmax = max(global_waveform); Gmin = min(global_waveform);
Gmean = mean(global_waveform);
if Gmean>0
    Gmax = Gmax+Gmean;
    Gmin = Gmin-Gmean;
else
    Gmax = Gmax-Gmean;
    Gmin = Gmin+Gmean;
end

figure(1);
subplot(5,5,[1 2 3 4]);
plot(global_waveform,'LineWidth',2); 
set(gca,'xlim',([plot_time.start plot_time.finish]));
set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
set(gca,'xticklabel',{plot_time.time(:).time}); ylabel('dZglobal');%xlabel('Time(hh:mm:ss)');
set(gca,'ylim',([Gmin Gmax])); 

subplot(5,5,[6 7 8 9]);
plot(ROI.first,'LineWidth',2); 
set(gca,'xlim',([plot_time.start plot_time.finish]));
set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
set(gca,'xticklabel',{plot_time.time(:).time}); ylabel('ROI 1');
set(gca,'ylim',([Gmin Gmax])); 

subplot(5,5,[11 12 13 14]);
plot(ROI.second,'LineWidth',2); 
set(gca,'xlim',([plot_time.start plot_time.finish]));
set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
set(gca,'xticklabel',{plot_time.time(:).time}); ylabel('ROI 2');
set(gca,'ylim',([Gmin Gmax])); 

subplot(5,5,[16 17 18 19]);
plot(ROI.third,'LineWidth',2);
set(gca,'xlim',([plot_time.start plot_time.finish]));
set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
set(gca,'xticklabel',{plot_time.time(:).time}); ylabel('ROI 3');
set(gca,'ylim',([Gmin Gmax]));  

subplot(5,5,[21 22 23 24]);
plot(ROI.fourth,'LineWidth',2); 
set(gca,'xlim',([plot_time.start plot_time.finish]));
set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
set(gca,'xticklabel',{plot_time.time(:).time}); ylabel('ROI 4');
set(gca,'ylim',([Gmin Gmax])); 

%     saveas(gcf,sprintf('video_%6.0f.jpg',recount),'jpg');
end

