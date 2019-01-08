function [SCG_data,error] = FxSCG_RawImport(SCG_data_path)
cd(SCG_data_path);
dirlist = dir('.');
for i = 1:size(dirlist,1)
    data_name{i}=dirlist(i).name;
end
data_name(1:2) = [];
clear dirlist;

error = 0;
cnt = 1;
data_index = 8;


for i = 1:size(data_name,2)
    try
        path = strcat(SCG_data_path,'\',int2str(i),'Scan.txt.');
        fid = fopen(path);
        Raw_data = textscan(fid,'%f');
        fclose(fid);
        
        R_data(:,i) = Raw_data{1,1};
        for j = 1:50
            for k = 1:16
                SCG_data(k,j+(50*(i-1))) = R_data(k+((j-1)*16),i);
            end
        end
        clear k j;
    
    catch me
        error(cnt) = i;
        cnt = cnt + 1;
    end
    disp(['data import : ' num2str(i) ' / ' num2str(size(data_name,2))]);
end 