function [ data_output ] = FxEIT_SetPlotRange( data_name, data, start, finish, range )
%UNTITLED 이 함수의 요약 설명 위치
%   자세한 설명 위치
data_output.data_name = data_name;
data_output.data = data;
data_output.range = [start, finish];
data_output.max_value = max(data_output.data(start:finish));
data_output.min_value = min(data_output.data(start:finish));

if nargin == 4
    range = 10;
end

cnt = 0;
P_N_flag = 1;
if data_output.max_value < 0
    P_N_flag = 0;
    data_output.max_value = abs(data_output.max_value);
end
if data_output.max_value > 1
    while data_output.max_value>range
        data_output.max_value = (data_output.max_value)/10;
        cnt = cnt+1;
    end
    data_output.max_value = ceil(data_output.max_value);
    for i=1:cnt
        data_output.max_value = data_output.max_value*10;
    end
else
    while data_output.max_value<1
        data_output.max_value = (data_output.max_value)*10;
        cnt = cnt+1;
    end
    data_output.max_value = ceil(data_output.max_value);
    for i=1:cnt
        data_output.max_value = data_output.max_value/10;
    end
end
if P_N_flag == 0
    data_output.max_value = -(data_output.max_value);
end

cnt = 0;
P_N_flag = 1;
if data_output.min_value < 0
    P_N_flag = 0;
    data_output.min_value = abs(data_output.min_value);
end
if data_output.min_value > 1
    while data_output.min_value>range
        data_output.min_value = (data_output.min_value)/10;
        cnt = cnt+1;
    end
    data_output.min_value = ceil(data_output.min_value);
    for i=1:cnt
        data_output.min_value = data_output.min_value*10;
    end
else
    while data_output.min_value<1
        data_output.min_value = (data_output.min_value)*10;
        cnt = cnt+1;
    end
    data_output.min_value = ceil(data_output.min_value);
    for i=1:cnt
        data_output.min_value = data_output.min_value/10;
    end
end
if P_N_flag == 0
    data_output.min_value = -(data_output.min_value);
end

data_output.value = [data_output.min_value, data_output.max_value];
data_output.waveform = data_output.data-data_output.min_value;
data_output.waveform = data_output.waveform/(data_output.max_value-data_output.min_value);
end

