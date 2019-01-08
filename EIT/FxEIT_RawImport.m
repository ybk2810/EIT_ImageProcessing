function [EIT_data, data_name] = FxEIT_RawImport(EIT_data_path, mask)
scan_num = 512; % 1 raw data have 512 scan data
data_num = 256; % depend on protocol

cd(EIT_data_path);
dirlist = dir('.');
for i = 1:length(dirlist)
    data_name{i}=dirlist(i).name;
end
data_name(1:2) = [];
clear dirlist;

cnt = 1;
for i = 1:length(data_name);
    file_path = strcat(EIT_data_path,'\',data_name{i});
    fid = fopen(file_path);
    raw_data = fread(fid,data_num*scan_num*6,'uint8');
    raw_data = reshape(raw_data,data_num*6,scan_num);
    fclose(fid);
    
    for j = 1:scan_num % 512 scan data
        temp = raw_data(:,j);
        temp = reshape(temp,6,256);
        temp(1,:)=temp(1,:)-128;
        temp(1:2,:) = temp([2 1],:);
        temp(3,:) = temp(3,:).*256 + temp(4,:);
        temp(4,:) = temp(5,:).*256 + temp(6,:);
        temp(5:6,:) = [];
        temp(temp>2^15-1) = temp(temp>2^15-1) - 2^16;
        temp = temp';
        temp = temp([1:16:256 2:16:256 3:16:256 4:16:256 5:16:256 6:16:256 7:16:256 8:16:256 9:16:256 10:16:256 11:16:256 12:16:256 13:16:256 14:16:256 15:16:256 16:16:256],:);
        scan_data(:,:,cnt) = temp;
        signed = scan_data(:,3,cnt);
        signed(signed>=0) = 1;
        signed(signed<0) = -1;
        
        EIT_data(:,cnt) = signed.*sqrt(scan_data(:,3,cnt).^2 + scan_data(:,4,cnt).^2);
        clear temp;
        cnt = cnt + 1;
    end
    clear raw_data;
    
    disp(['data import : ' num2str(i) ' / ' num2str(length(data_name))]);
end

% remove saturation ch data
if nargin ==1
    mask = [1,2,16,17,18,19,34,35,36,51,52,53,68,69,70,85,86,87,102,103,104,119,120,121,136,137,138,153,154,155,170,171,172,187,188,189,204,205,206,221,222,223,238,239,240,241,255,256;];
end

EIT_data(mask,:) = [];

end
