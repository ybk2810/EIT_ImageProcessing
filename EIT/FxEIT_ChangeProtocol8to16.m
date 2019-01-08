function [ Mag_8_mask ] = FxEIT_ChangeProtocol8to16( scan_data )
% 16ch->8ch scan_data
mask_8 = [1,2,8,9,10,11,18,19,20,27,28,29,36,37,38,45,46,47,54,55,56,57,63,64];

for i=1:size(scan_data,2)
    for j=1:8
        scan_data_8(1+8*(j-1):8*j,i)=scan_data(1+16*(j-1):8+16*(j-1),i);
        scan_data_8(1+8*(j-1),i)=scan_data(9+16*(j-1),i);
        if j==1
            scan_data_8(j:j+7,i)=scan_data(j+128:j+135,i);
            scan_data_8(j,i)=scan_data(129+8,i);
        end
    end
end
clear i j scan_data Mag ans mask 

Mag_8_mask=scan_data_8;
Mag_8_mask(mask_8,:)=[];

end

