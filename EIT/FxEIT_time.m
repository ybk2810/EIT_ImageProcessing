function [ time ] = FxEIT_time( data_name, data )
EIT_file_count = length(data_name);

EIT_start = data_name(1); 
EIT_finish = data_name(end); 
if EIT_start{1}(13) == '_'
    EIT_start = EIT_start{1}(14:19);
    EIT_finish = EIT_finish{1}(14:19);
else
    EIT_start = EIT_start{1}(13:18);
    EIT_finish = EIT_finish{1}(13:18);
end

EIT_start_hour = str2double(EIT_start(1:2)); EIT_start_minute = str2double(EIT_start(3:4)); EIT_start_second = str2double(EIT_start(5:6));
EIT_finish_hour = str2double(EIT_finish(1:2)); EIT_finish_minute = str2double(EIT_finish(3:4)); EIT_finish_second = str2double(EIT_finish(5:6));

EIT_start_time = EIT_start_hour*3600+EIT_start_minute*60+EIT_start_second;
EIT_start_time = EIT_start_time-511/50;
EIT_finish_time =  EIT_finish_hour*3600+EIT_finish_minute*60+EIT_finish_second;

time = EIT_start_time:(EIT_finish_time-EIT_start_time+1/50)/(length(data)+1):EIT_finish_time;

if size(time,2) > size(data,2)
    time(end)=[];
elseif size(time,2) < size(data,2)
    time(end+1)=time(end);
end

end

