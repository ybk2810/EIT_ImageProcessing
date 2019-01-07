function [ Strain_Image ] = FxEIT_Strain_Image( EELV_Image, TV_Image )
% Strain image
for cnt = 1:size(TV_Image,3) % TidalVolume
    Strain_Image(:,:,cnt) = TV_Image(:,:,cnt)./EELV_Image(:,:,cnt);
    
    disp(num2str(cnt))
end

end

