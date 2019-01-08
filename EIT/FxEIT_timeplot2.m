function [ sigma, plot_time ] = FxEIT_timeplot2( inv_Sense, DataSet, EIT_ref, start, finish, sigma_f )
% [ sigma, plot_time ] = FxEIT_timeplot2( Data, DataSet, EIT_ref(EIT data), start, finish )
% EIT_ref : x¡¬«•ø° ¥Î«— EIT data

temp = DataSet.time;
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

for i = 1:length(plot_time.section)
    plot_time.hms(i,1) = fix(temp(plot_time.section(i))/3600);
    plot_time.hms(i,2) = fix(rem(temp(plot_time.section(i)),3600)/60);
    plot_time.hms(i,3) = round(rem(rem(temp(plot_time.section(i)),3600),60));
    plot_time.time(i).time = strcat(num2str(plot_time.hms(i,1)), plot_time.cemicolon, num2str(plot_time.hms(i,2)), plot_time.cemicolon, num2str(plot_time.hms(i,3)));
end
clear i

Temp_ref = sum(inv_Sense * EIT_ref,1); % boundary artifact remover
for i=1:size(DataSet.EIT_L,2)
    EIT_proj(i) = sum(inv_Sense * DataSet.EIT_L(:,i),1); 
end
sigma = EIT_proj - repmat(mean(Temp_ref,2), 1, size(EIT_proj,2));
% sigma = sigma.*repmat(sigma_f,1,size(sigma,2));
sigma = sum(sigma,1);

set(figure(1), 'Position', [550 300 1000 200]);

plot(sum(sigma,1)); title('');
set(gca,'xlim',([plot_time.start plot_time.finish]));
set(gca,'xtick',plot_time.start:(plot_time.finish-plot_time.start)/(length(plot_time.section)-1):plot_time.finish);
set(gca,'xticklabel',{plot_time.time(:).time});
xlabel('Time(hh:mm:ss)');
ylabel('Zglobal');

end

