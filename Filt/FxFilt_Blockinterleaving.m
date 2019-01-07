function FxFilt_Blockinterleaving
% block interleaving
% for i = 1:208
%     temp = reshape(EIT_data(i,:),breath_length,window_size/breath_length)';
%     temp2 = reshape(temp,window_size,1);
%     
%     N = 10;
%     a = 1;
%     b = ones(1,N)/N;
%     temp3 = filtfilt(b,a,temp2);
% %     plot(temp2); hold on; plot(temp3,'r','LineWidth',3);
% 
%     temp4 = reshape(temp3,window_size/breath_length,breath_length);
%     temp5 = reshape(temp4',1,window_size);
%     
% %     plot(EIT_data(1,:)); hold on; plot(temp5,'r','LineWidth',2); hold off;
%     EIT_data2(i,:) = temp5;
%     clear temp temp2 temp3 temp4 temp5;
% end