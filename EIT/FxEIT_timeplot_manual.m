function [ recon_data, plot_time ] = FxEIT_timeplot_manual( inv_Sense, EIT_data, time, EIT_ref, start, finish, sigma_f )
% [ recon_data, plot_time ] = FxEIT_timeplot_manual( inv_Sense, EIT_data, time, EIT_ref, start, finish, sigma_f )

plot_time.start = start;
plot_time.finish = finish;
plot_time.center(1) = round((plot_time.start + plot_time.finish)/2); 
plot_time.center(2) = round((plot_time.start + plot_time.center(1))/2); 
plot_time.center(3) = round((plot_time.center(1) + plot_time.finish)/2); 
plot_time.center(4) = round((plot_time.start + plot_time.center(2))/2); 
plot_time.center(5) = round((plot_time.center(2) + plot_time.center(1))/2); 
plot_time.center(6) = round((plot_time.center(1) + plot_time.center(3))/2); 
plot_time.center(7) = round((plot_time.center(3) + plot_time.finish)/2); 
plot_time.section(1) = plot_time.start; plot_time.section(2) = plot_time.center(4); 
plot_time.section(3) = plot_time.center(2); plot_time.section(4) = plot_time.center(5); 
plot_time.section(5) = plot_time.center(1); plot_time.section(6) = plot_time.center(6); 
plot_time.section(7) = plot_time.center(3); plot_time.section(8) = plot_time.center(7); 
plot_time.section(9) = plot_time.finish; 
plot_time.cemicolon = ':';
% plot_time.plot = temp(plot_time.start:plot_time.finish);

for i = 1:length(plot_time.section)
    plot_time.hms(i,1) = fix(time(plot_time.section(i))/3600);
    plot_time.hms(i,2) = fix(rem(time(plot_time.section(i)),3600)/60);
    plot_time.hms(i,3) = round(rem(rem(time(plot_time.section(i)),3600),60));
    plot_time.time(i).time = strcat(num2str(plot_time.hms(i,1)), plot_time.cemicolon, num2str(plot_time.hms(i,2)), plot_time.cemicolon, num2str(plot_time.hms(i,3)));
end
clear i

%% 1row
% Temp_ref = sum(inv_Sense * EIT_data(:,EIT_ref(1):EIT_ref(2)),1); % boundary artifact remover
% for i=1:size(EIT_data,2)
%     EIT_proj(i) = sum(inv_Sense * EIT_data(:,i),1); 
% end
% sigma = EIT_proj - repmat(mean(Temp_ref,2), 1, size(EIT_proj,2));
% sigma = sigma.*repmat(sigma_f,1,size(sigma,2));
% sigma = sum(sigma,1);

%% for loop
Temp_ref = mean(EIT_ref(:,1:end),2); % boundary artifact remover

if size(EIT_data,2) > 1000 && size(EIT_data,2) < 9999
    calculation_size = 100;
elseif size(EIT_data,2) > 10000 && size(EIT_data,2) < 99999
    calculation_size = 1000;
elseif size(EIT_data,2) > 100000 && size(EIT_data,2) < 999999
    calculation_size = 10000;
elseif size(EIT_data,2) > 1000000 && size(EIT_data,2) < 9999999
    calculation_size = 100000;
end

for i=1:fix(size(EIT_data,2)/calculation_size)
    temp = sum(((inv_Sense * (EIT_data(:,(i-1)*calculation_size+1:(i)*calculation_size) - repmat(Temp_ref,1,calculation_size))) .* repmat(sigma_f,1,calculation_size)),1);
    recon_data((i-1)*calculation_size+1:i*calculation_size) = temp;
end
temp = sum(((inv_Sense * (EIT_data(:,i*calculation_size+1:end) - repmat(Temp_ref,1,size(EIT_data,2)-i*calculation_size))) .* repmat(sigma_f,1,size(EIT_data,2)-i*calculation_size)),1);
recon_data(i*calculation_size+1:size(EIT_data,2)) = temp;

%% plot
set(figure(1), 'Position', [550 300 1000 200]);
plot(recon_data); title(''); set(gca,'xlim',([plot_time.start plot_time.finish]));
set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
set(gca,'xticklabel',{plot_time.time(:).time}); xlabel('Time(hh:mm:ss)'); 
if sigma_f==ones(size(inv_Sense,1),1);
    ylabel('Zglobal');
end

end

