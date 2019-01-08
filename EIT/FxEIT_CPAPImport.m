function [ CPAP ] = FxEIT_CPAPImport( CPAP_data_path )
%UNTITLED2 이 함수의 요약 설명 위치
%   자세한 설명 위치
fid = fopen(CPAP_data_path);
temp = textscan(fid, '%s%s%s%s%s');

cnt_T = 0; cnt_P = 0; cnt_V = 0;
stop = 0;
miss = 0;
cnt_stop = 0;
T = [];
P = [];
V = [];
for i=1:size(temp{1,1},1)
    if temp{1,1}{i,1} == 'T'
        cnt_T = cnt_T+1;
        Time = temp{1,3}{i,1};
        CPAP.T(cnt_T,1) = str2double(Time(1:2));
        CPAP.T(cnt_T,2) = str2double(Time(4:5));
        CPAP.T(cnt_T,3) = str2double(Time(7:8));
    elseif temp{1,1}{i,1} == 'P'
        cnt_P = cnt_P+1;
        CPAP.P(cnt_P,1) = CPAP.T(cnt_T,1)*3600+CPAP.T(cnt_T,2)*60+CPAP.T(cnt_T,3);
        CPAP.P(cnt_P,2) = (str2double(temp{1,2}{i,1}))/10;
        CPAP.P(cnt_P,3) = (str2double(temp{1,3}{i,1}))/10;
        CPAP.P(cnt_P,4) = (str2double(temp{1,4}{i,1}))/10;
    else
        cnt_V = cnt_V+1;
        CPAP.V(cnt_V,1) = CPAP.T(cnt_T,1)*3600+CPAP.T(cnt_T,2)*60+CPAP.T(cnt_T,3);
        CPAP.V(cnt_V,2) = str2double(temp{1,2}{i,1});
        CPAP.V(cnt_V,3) = str2double(temp{1,3}{i,1});
        CPAP.V(cnt_V,4) = str2double(temp{1,4}{i,1});
        CPAP.V(cnt_V,5) = str2double(temp{1,5}{i,1});
    end
end
end

