function [ Cursor ] = FxKHU_Cursor_ECG( DataSet, avg_order )
% make the cardiac cycle data set using cursor function
% matrials : DataSet(recon_data, ECG_raw2, locs_Rwave, RR_interval), avg_order
% reference the relation to ECG : FxEIT_findRpeak

set(figure(1), 'Position', [550 300 1000 200]);
[AX,H1,H2] = plotyy(1:size(DataSet.recon_data,2),DataSet.ECG_raw2(1:size(DataSet.recon_data,2)),1:size(DataSet.recon_data,2),DataSet.recon_data);
ylabel (AX(1),'Conductivity Waveform'); ylabel (AX(2), 'ECG');
zoom on; pause();

[Cursor.dot,~] = ginput(1);
Cursor.x_point = round(Cursor.dot);

X = DataSet.locs_Rwave;
interval = DataSet.RR_interval;
try
%     Cursor.Cardiac_index = find(X==Cursor.x_point);
    Cursor.Cardiac_index = sum(X<Cursor.x_point);
catch
end

hold on; set(AX(2)); 
plot(Cursor.x_point, DataSet.recon_data(Cursor.x_point), '*k','LineWidth',2); 
hold off;

for i=1:2^avg_order
    index = Cursor.Cardiac_index+i-1;
    Cursor.Cardiac(i).index = X(index)-interval(index)+50-25:X(index)+interval(index)+50+25;
    Cursor.Cardiac(i).interval = interval(index);
    hold on; 
    plot(Cursor.Cardiac(i).index, DataSet.recon_data(Cursor.Cardiac(i).index), 'k');
    hold off;

end

end

