function [  ] = FxEIT_SeveralPlotting( plot_time ,data1, data2, data3, data4, data5, data6 )
%UNTITLED2 이 함수의 요약 설명 위치
%   자세한 설명 위치
start = data1.range(1);
finish = data1.range(2);
label_x = start-(finish-start+1)/10;
if nargin == 3
    offset = [0, 1; 1.5, 2.5];
    label_position = mean(offset,2);
    offset_rename = [data1.value; data2.value];
    set(figure(1), 'Position', [0 0 1000 500]); hold on;
    a = gca;
    plot(data1.waveform+offset(2,1),'k','LineWidth',2);
    plot(data2.waveform+offset(1,1),'k','LineWidth',2);
    
    set(gca,'FontSize',12); set(gca,'FontWeight','bold');
    set(gca, 'xlim', [start, finish]);
    set(gca, 'ylim', [0, 2.5]);
    set(gca,'xtick', plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
    set(gca,'xticklabel', {plot_time.time(:).time}); xlabel('Time(hh:mm:ss)'); 

    set(gca,'ytick', reshape(label_position',1,size(label_position,1)*size(label_position,2)));
    set(gca,'yticklabel', {data2.data_name, data1.data_name});
    a.YTickLabelRotation = 45;
    
elseif nargin == 5
    offset = [0, 1; 1.5, 2.5; 3, 4; 4.5, 5.5];
    label_position = mean(offset,2);
    offset_rename = [data1.value; data2.value; data3.value; data4.value];
    set(figure(1), 'Position', [0 0 1400 700]); hold on;
    a = gca;
    plot(data1.waveform+offset(4,1),'k','LineWidth',2);
    plot(data2.waveform+offset(3,1),'k','LineWidth',2);
    plot(data3.waveform+offset(2,1),'k','LineWidth',2);
    plot(data4.waveform+offset(1,1),'k','LineWidth',2);
    
    set(gca,'FontSize',12); set(gca,'FontWeight','bold');
    set(gca, 'xlim', [start, finish]);
    set(gca, 'ylim', [0, 5.5]);
    set(gca,'xtick', plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
    set(gca,'xticklabel', {plot_time.time(:).time}); xlabel('Time(hh:mm:ss)'); 
%     set(gca,'ytick', reshape(offset',1,size(offset,1)*size(offset,2)));
%     set(gca,'yticklabel', {reshape(offset_rename',1,size(offset_rename,1)*size(offset_rename,2))});

    set(gca,'ytick', reshape(label_position',1,size(label_position,1)*size(label_position,2)));
    set(gca,'yticklabel', {data4.data_name, data3.data_name, data2.data_name, data1.data_name});
    a.YTickLabelRotation = 45;
    
elseif nargin == 7
    offset = [0, 1; 1.5, 2.5; 3, 4; 4.5, 5.5; 6, 7; 7.5, 8.5];
    label_position = mean(offset,2);
    offset_rename = [data1.value; data2.value; data3.value; data4.value; data5.value; data6.value];
    set(figure(1), 'Position', [0 0 1400 700]); hold on;
    a = gca;
    plot(data1.waveform+offset(6,1),'k','LineWidth',2);
    plot(data2.waveform+offset(5,1),'k','LineWidth',2);
    plot(data3.waveform+offset(4,1),'k','LineWidth',2);
    plot(data4.waveform+offset(3,1),'k','LineWidth',2);
    plot(data5.waveform+offset(2,1),'k','LineWidth',2);
    plot(data6.waveform+offset(1,1),'k','LineWidth',2);
    
    set(gca,'FontSize',12); set(gca,'FontWeight','bold');
    set(gca, 'xlim', [start, finish]);
    set(gca, 'ylim', [0, 9]);
    set(gca,'xtick', plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
    set(gca,'xticklabel', {plot_time.time(:).time}); xlabel('Time(hh:mm:ss)'); 
%     set(gca,'ytick', reshape(offset',1,size(offset,1)*size(offset,2)));
%     set(gca,'yticklabel', {reshape(offset_rename',1,size(offset_rename,1)*size(offset_rename,2))});

    set(gca,'ytick', reshape(label_position',1,size(label_position,1)*size(label_position,2)));
    set(gca,'yticklabel', {data6.data_name, data5.data_name, data4.data_name, data3.data_name, data2.data_name, data1.data_name});
    a.YTickLabelRotation = 45;
    
end



end

