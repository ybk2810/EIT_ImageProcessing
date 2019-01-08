function [EIT_data] = FxEIT_txtImport(EIT_path, mask)

cd(EIT_path);
dirlist = dir('.');
fid = fopen(strcat([EIT_path,'\',dirlist(3,1).name]));
temp = textscan(fid, '%f%f%f%f');
fclose(fid);

if size(temp{1,1},1) < 16^2
    ch = 8;
elseif size(temp{1,1},1)< 32^2
    ch = 16;
else
    ch = 32;
end
disp(['ch : ', int2str(ch)]);

cnt = 1;
stop = 0;
miss = 0;
cnt_stop = 0;
while(stop~=1)
    try
        path = strcat(EIT_path,'\',int2str(cnt),'Scan.txt' );
        fid = fopen(path);
        temp = textscan(fid, '%f%f%f%f');
        fclose(fid);
        
        temp2 = sqrt(temp{1,3}.^2 + temp{1,4}.^2);
        if size(temp2,1) > ch^2
            temp2(end) = [];  %%% for java data header line
            temp{1,3}(ch^2+1:end) = [];
        end
        temp{1,3}(temp{1,3}<0) = -1;
        temp{1,3}(temp{1,3}>=0) = 1;
        EIT_data(:,cnt) = temp{1,3}.*temp2;
        
        cnt = cnt + 1;
        cnt_stop = 0;
    catch
        miss = miss + 1;
        cnt_stop = cnt_stop + 1;
        if cnt_stop > 4
            stop = 1;
        end
    end
end

disp(['miss data : ', int2str(miss-5)]);

% remove saturation ch data
if nargin ==1
    mask = [1,2,16,17,18,19,34,35,36,51,52,53,68,69,70,85,86,87,102,103,104,119,120,121,136,137,138,153,154,155,170,171,172,187,188,189,204,205,206,221,222,223,238,239,240,241,255,256;];
end
EIT_data(mask,:) = [];

end
