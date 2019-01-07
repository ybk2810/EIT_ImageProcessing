function [ ROI_mask_Image ] = FxEIT_ROI_tri( Image, cnt, threshold )
th = max(max(Image(:,cnt)))*threshold*0.01;
temp = Image(:,cnt);
temp(temp<=th) = 0; temp(temp>=th) = 1;
ROI_mask_Image = temp;
end

