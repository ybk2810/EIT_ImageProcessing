function [ T ] = FxEIT_num2time( time, EIT_n )
%UNTITLED �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
T = time(1,EIT_n);

hms(1) = fix(T/3600);
hms(2) = fix(rem(T,3600)/60);
hms(3) = round(rem(rem(T,3600),60));
cemicolon = ':';
T = strcat(num2str(hms(1)), cemicolon, num2str(hms(2)), cemicolon, num2str(hms(3)));


end
