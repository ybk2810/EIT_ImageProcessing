function [ Index ] = FxEIT_MakeBreathFlag( Flow, section, BreathIndexTheshold )
%UNTITLED 이 함수의 요약 설명 위치
%   자세한 설명 위치

flag = 0;
flag_inhale = 0;
flag_exhale = 0;
for i = section
    if Flow(i) == 1
        if flag == 0
            if flag_exhale < BreathIndexTheshold
                Flow(i-flag_exhale:i-1) = 0;
            end
        end
        flag_exhale = 0;
        flag = 1;
        flag_inhale = flag_inhale+1;
    else
        if flag == 1
            if flag_inhale < BreathIndexTheshold
                Flow(i-flag_inhale:i-1) = 0;
            end
        end
        flag_inhale = 0;
        flag = 0;
        flag_exhale = flag_exhale+1;
    end
end
Index = Flow;

end

