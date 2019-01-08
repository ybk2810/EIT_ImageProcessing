function [ DataSet, Fs_OM ] = FxEIT_OrientalMedicineImport( DataSet, Path.Oriental_Medicine )
OM = load(Path.Oriental_Medicine);
OM.data = reshape(OM.data,length(OM.data)/7,7);
OM.data = OM.data';
Fs_OM = OM.tickrate;

t = 1:size(OM.data,2); t = t/Fs_OM;
plot(t,OM.data(end,:)); zoom on; pause();
[x] = round(ginput(1)*Fs_OM);
OM.data(:,1:x) = []; clear x t;

while (OM.data(7,1) < 0.05)
    OM.data(:,1) = [];
end

flag = 1;
cnt = 0;
a = 0.08; b = -0.08; % 
for i = 1:length(OM.data(7,:))-1
    if (OM.data(7,i)>a) && (flag==1)
        cnt = cnt+1;
        flag = 0;
        roc(cnt) = i;
    elseif (OM.data(7,i)<b) && (flag==0)
        cnt = cnt+1;
        flag = 1;
        roc(cnt) = i;
    end
    EIT_index(i) = cnt;
end

OM_index = round((roc(1:end-1) + roc(2:end))./2);     % find ECG data in each middle point of window trigger
OM.data = OM.data(:,OM_index);                        % ECG data match with EIT frame rate

subplot(3,4,1:4); title('EIT data');
subplot(3,4,5:8); plot(OM.data(5,:));title('Oriental Medicine data');
subplot(3,4,9:12); plot(OM.data(7,:)); title('EIT toggle data');
hold on; plot(roc,OM.data(7,roc),'*r'); plot(roc(1:2:end),OM.data(7,roc(1:2:end)),'*b')

FxEIT_FFT(OM.data(7,:), Fs_OM) 



figure; plotyy(1:Fs.EIT:length(sigma),sum(sigma),)

DataSet.OM = OM.data;
DataSet.OM_tag = OM.titles;
end

