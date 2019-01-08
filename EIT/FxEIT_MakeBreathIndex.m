function [ Breath ] = FxEIT_MakeBreathIndex( BreathFlag, Fs )
%UNTITLED2 이 함수의 요약 설명 위치
%   자세한 설명 위치
index_start = BreathFlag(1,1) +1; % first & last breath remove
index_finish = BreathFlag(end,1) -1; % first & last breath remove
breath_index = index_start;

save_flag = 0;
cnt = 1;
for i = 1:size(BreathFlag,1)
    if BreathFlag(i,1) == breath_index
        save_flag = 1;
    else
        if BreathFlag(i,1) < index_start
            save_flag = 0;
        elseif breath_index > index_finish
            save_flag = 0;
        else
            breath_index = breath_index + 1;
        end
        cnt = 1;
    end
    
    if save_flag == 1
        Breath(breath_index-index_start+1).index(cnt) = i;
        cnt = cnt + 1;
    end

end

% cnt=1;
% temp=[];
for i = 1:size(Breath,2)                                            % inhale, Start of Inspiration, End of Expiration, Paw
    Breath(i).Start_Insp = Breath(1,i).index(1,1);
    Breath(i).inhale = sum(BreathFlag(Breath(i).index,2))+Breath(i).index(1)-1;
    Breath(i).End_Exp = Breath(1,i).index(1,end);
%     if size(Breath(i).index,1)>Fs*10 || Breath(i).Start_Insp+Fs/2 > Breath(i).inhale || size(Breath(i).index,1)<Fs
%         temp(1,cnt)=i;
%         cnt=cnt+1;
%     end
end
% Breath( temp ) = [];
% for i = 2:size(Breath,2)
%     Breath(i).index = Breath(i).Start_Insp:Breath(i).End_Exp;
% end

end

