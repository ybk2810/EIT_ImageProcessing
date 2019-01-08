function [ sigma, plot_time, r ] = FxEIT_timeplot( inv_Sense, DataSet, EIT_ref, start, finish, sigma_f )
% [ sigma, plot_time ] = FxEIT_timeplot( Data, DataSet, EIT_ref, start, finish )

temp = DataSet.time;
% plot_time.start = 1;
% plot_time.start = start;
plot_time.start = DataSet.Breath(section_TV(1)).index(1);
% plot_time.finish = length(temp);
% plot_time.finish = finish;
plot_time.finish = DataSet.Breath(section_TV(2)).index(end)-(26048-25602)

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

Temp_ref = inv_Sense * DataSet.EIT_L(:,EIT_ref(1):EIT_ref(2)); % boundary artifact remover
EIT_proj = inv_Sense * DataSet.EIT_L; 
sigma = EIT_proj - repmat(mean(Temp_ref,2), 1, size(EIT_proj,2));
sigma = sigma.*repmat(sigma_f,1,size(sigma,2));

set(figure(1), 'Position', [550 300 1000 200]);
% subplot(3,4,[1 2 3 4]);
% subplot(2,4,[1 2 3 5 6 7]);
plot(sum(sigma));
% title('');
set(gca,'xlim',([plot_time.start plot_time.finish]));
set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
set(gca,'xticklabel',[]);
% set(gca,'xticklabel',{plot_time.time(:).time});
% xlabel('Time(hh:mm:ss)');
% ylabel('Zglobal');

set(figure(2), 'Position', [550 200 1000 200]);
plot(DataSet.PV_raw(:,4),'r');
set(gca,'xlim',([plot_time.start plot_time.finish]));
set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
set(gca,'xticklabel',[]);
% set(gca,'xticklabel',{plot_time.time(:).time});
% xlabel('Time(hh:mm:ss)');
% ylabel('PV.V');

set(figure(4), 'Position', [550 200 1000 200]);
[AX,H1,H2] = plotyy(1:size(sigma,2),sum(sigma),1:size(sigma,2),DataSet.PV_raw(:,4))
set(AX,'xlim',([plot_time.start plot_time.finish]));
set(AX,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
set(AX,'xticklabel',[]);

set(figure(6), 'Position', [550 200 1000 200]);
plot(DataSet.PV_raw(:,3),'k');
set(gca,'xlim',([plot_time.start plot_time.finish]));
set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
set(gca,'xticklabel',[]);

cmap = jet(plot_time.finish-plot_time.start+1);
set(figure(5), 'Position', [850 200 800 800]);
plot(DataSet.PV_raw(plot_time.start:plot_time.finish,4),sum(sigma(:,plot_time.start:plot_time.finish),1),'.k');
plot(DataSet.PV_raw(plot_time.start:plot_time.start+(plot_time.finish-plot_time.start)/2,4),sum(sigma(:,plot_time.start:plot_time.start+(plot_time.finish-plot_time.start)/2),1),'.k');
for i = plot_time.start:plot_time.finish
    plot(DataSet.PV_raw(i,4),sum(sigma(:,i),1),'Color',cmap(i-plot_time.start+1,:)); hold on;
    i
    pause(0.000000000000000001)
end
% (plot_time.finish-plot_time.start)/2



GI = sum(sigma(:,plot_time.start:plot_time.finish),1);
Airwaw = DataSet.PV_raw(plot_time.start:plot_time.finish,:);

bootstrap
r = corrcoef(DataSet.PV_raw(plot_time.start:plot_time.finish,4),sum(sigma(:,plot_time.start:plot_time.finish),1))

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

% % PV plot
% set(figure(1), 'Position', [100 100 750 300]);
% [AX,H1,H2]=plotyy(1:length(DataSet.time),DataSet.PV_raw(:,4),1:length(DataSet.time),DataSet.PV_raw(:,3));
% title('PEEP(Pressure mode)');
% set(AX,'xlim',([plot_time.start plot_time.finish]));
% set(AX,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
% set(AX,'xticklabel',{plot_time.time(:).time});
% axes(AX(1));
% set(gca,'ylim',([-200 600])); 
% set(gca,'ytick',([-200 -100 0 100 200 300 400 500 600]));
% axes(AX(2));
% set(gca,'ylim',([-5 40])); 
% set(gca,'ytick',([-5 0 5 10 15 20 25 30 35 40]));
% xlabel('Time(hh:mm:ss)');
% set(get(AX(1),'Ylabel'),'String','Volume(ml)') 
% set(get(AX(2),'Ylabel'),'String','Paw(cmH2O)')
% clear plot_time temp AX H1 H2

%% Drager1
% set(figure(1), 'Position', [100 100 750 300]);
% plot(sum(DataSet.EIT_filt_L),'LineWidth',2); title('Generation of EIT images'); ylabel('dZglobal');
% % plot(DataSet.PV_raw(:,3)); title('PEEP(Pressure mode)'); ylabel('Paw(cmH2O)');
% % plot(DataSet.PV_raw(:,3)); title('Tital Volume'); ylabel('Volume(ml)');
% set(gca,'xlim',([start finish]));
% set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
% set(gca,'xticklabel',{plot_time.time(:).time});
% xlabel('Time(hh:mm:ss)');


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



end

