function [ EIT_s_time, EIT_f_time ] = FxEIT_time2num( time, EIT_s, EIT_f )
%UNTITLED 이 함수의 요약 설명 위치
%   자세한 설명 위치

EIT_hour = str2double(EIT_s(1:2)); 
EIT_minute = str2double(EIT_s(3:4)); 
EIT_second = str2double(EIT_s(5:6));
EIT_s_time = EIT_hour*3600+EIT_minute*60+EIT_second;
EIT_s_time = sum(time<EIT_s_time); 

EIT_hour = str2double(EIT_f(1:2)); 
EIT_minute = str2double(EIT_f(3:4)); 
EIT_second = str2double(EIT_f(5:6));
EIT_f_time = EIT_hour*3600+EIT_minute*60+EIT_second;
EIT_f_time = sum(time<EIT_f_time);

end

