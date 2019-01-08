function [result,tag] = FxEIT_PVImport(PV_path)

try
    fid = fopen(PV_path); %Hamilton G5
    data = textscan(fid,'%s');

    data{1,1}(1:28) = []; % remove header
    data = reshape(data{1,1}(:),10,length(data{1,1})/10)';

    result(:,1) = data(:,4); % Breath
    result(:,2) = data(:,5); % Status
    result(:,3) = data(:,6); % Paw
    result(:,4) = data(:,8); % Volume
    result = str2double(result);
    tag = {'Breath','Status','Paw','Volume'};
    fclose(fid);
catch
    fid = fopen(PV_path); %Hamilton Galileo Emulation
    data = textscan(fid,'%s');

    data{1,1}(1:29) = []; % remove header
    data = reshape(data{1,1}(:),10,length(data{1,1})/10)';

    result(:,1) = data(:,4); % Breath
    result(:,2) = data(:,5); % Status
    result(:,3) = data(:,6); % Paw
    result(:,4) = data(:,8); % Volume
    result = str2double(result);
    tag = {'Breath','Status','Paw','Volume'};
    fclose(fid);
end
