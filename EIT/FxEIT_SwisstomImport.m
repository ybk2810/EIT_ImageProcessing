function [EIT_data] = FxEIT_SwisstomImport(data_path)
% ST data read
output = ST_EIT_reader(data_path);
for i = 1:size(output.frames,2)
    EIT_data(:,i) = sqrt(output.frames(1,i).iqPayload(1:2:end).^2 + ...
        output.frames(1,i).iqPayload(1:2:end).^2);
end
signed = output.frames(1,i).iqPayload(1:2:end);
signed(signed>=0) = 1;
signed(signed<0) = -1;

% 32ch Adjacent mask
temp = zeros(32,32);
cnt1 = 1; cnt2 = 2; cnt3 = 32;
for i = 1:32
    temp([cnt1,cnt2,cnt3],i) = 1;
    cnt1 = cnt1 + 1;
    cnt2 = cnt2 + 1;
    cnt3 = cnt3 + 1;
    if cnt1 > 32
        cnt1 = 1;
    end
    if cnt2 > 32
        cnt2 = 1;
    end
    if cnt3 > 32
        cnt3 = 1;
    end
end
 
temp2 = reshape(temp,32*32,1);
[mask ~] = find(temp2 == 1);

EIT_data(mask,:) = [];
signed(mask) = [];
EIT_data = repmat(signed,1,size(EIT_data,2)).*EIT_data;