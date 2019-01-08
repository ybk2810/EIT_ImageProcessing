function [ roc, EIT_index ] = FxEIT_BIOPAC_trigger( EIT_stat, a, b, interp_value )
%UNTITLED 이 함수의 요약 설명 위치
%   자세한 설명 위치
flag = 1;
cnt = 0;
if nargin == 3
    for i = 1:length(EIT_stat)-1
        if (EIT_stat(i)>a) && (flag==1)
            cnt = cnt+1;
            flag = 0;
            roc(cnt) = i;
        elseif (EIT_stat(i)<b) && (flag==0)
            cnt = cnt+1;
            flag = 1;
            roc(cnt) = i;
        end
        EIT_index(i) = cnt;
    end
    
elseif nargin == 4
    for i = 1:length(EIT_stat)-1
        if (EIT_stat(i)>a) && (flag==1)
            cnt = cnt+1;
            flag = 0;
            roc(interp_value*(cnt-1)+1) = i;
        elseif (EIT_stat(i)<b) && (flag==0)
            cnt = cnt+1;
            flag = 1;
            roc(interp_value*(cnt-1)+1) = i;
        end
        EIT_index(i) = cnt;
    end
    for i=1:cnt-1
        s = roc(interp_value*(i-1)+1);
        f = roc(interp_value*(i)+1);
        roc(interp_value*(i-1)+1:interp_value*(i)) = round(s:(f-s)/(interp_value-1):f);
    end
    
end


end

