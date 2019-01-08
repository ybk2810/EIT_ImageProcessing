function [mask] = FxEIT_mask(ch,first_sat)
temp = zeros(ch,ch);
if nargin == 1
    first_sat = [ch,1,2];
end

if length(first_sat) == 4
    cnt1 = first_sat(1); cnt2 = first_sat(2); cnt3 = first_sat(3); cnt4 = first_sat(4);
    for i = 1:ch
        temp([cnt1,cnt2,cnt3,cnt4],i) = 1;
        cnt1 = cnt1 + 1;
        cnt2 = cnt2 + 1;
        cnt3 = cnt3 + 1;
        cnt4 = cnt4 + 1;
        if cnt1 > ch
            cnt1 = 1;
        end
        if cnt2 > ch
            cnt2 = 1;
        end
        if cnt3 > ch
            cnt3 = 1;
        end
        if cnt4 > ch
            cnt4 = 1;
        end
    end
else
    cnt1 = first_sat(1); cnt2 = first_sat(2); cnt3 = first_sat(3);
    for i = 1:ch
        temp([cnt1,cnt2,cnt3],i) = 1;
        cnt1 = cnt1 + 1;
        cnt2 = cnt2 + 1;
        cnt3 = cnt3 + 1;
        if cnt1 > ch
            cnt1 = 1;
        end
        if cnt2 > ch
            cnt2 = 1;
        end
        if cnt3 > ch
            cnt3 = 1;
        end
    end
end

temp2 = reshape(temp,ch*ch,1);
[mask b] = find(temp2 == 1);