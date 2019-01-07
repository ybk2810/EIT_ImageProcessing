function [ Drager2 ] = FxDrager_2( Data, Cmap, DataSet, section )
% 1 frame마다 불러서 impedance waveform 생성
% status img, ROI, ROI Waveform 추가
% 2161222 편집종료(FxDrager_MainView로 추가 진행)
count = 1;
recount = 1;
flag = 1;
inhale_count = 0;
exhale_count = 0;
cnt_inhale = 1;
cnt_ref = 1;
Drager2.reference = [];
Tidal_flag = 0;
Tidal_start = 0;

meshsize = max(max(abs(Data.Node)))*1.25; % depend on original Image
pixel_num = 256;
for j = 1:size(Data.Element,1)
    xy(j,:) = mean(Data.Node(Data.Element(j,1:3),:));
end
ti = -meshsize:(2*meshsize)/(pixel_num-1):meshsize;
[qx,qy] = meshgrid(ti,ti);
clear meshsize pixel_num ti

for i = DataSet.Breath(section(1)).index(1):DataSet.Breath(section(2)).index(end)
    % load
    Drager2.EIT_filt_L(:,count) = DataSet.EIT_filt_L(:,i);
    Drager2.PV_raw(count,:) = DataSet.PV_raw(i,:);
    
    if Drager2.PV_raw(count,2) == 1
        if flag == 0 % exhale -> inhale
            Drager2.reference_instant(cnt_ref) = recount;
            Drager2.reference(:,cnt_ref) = Drager2.EIT_filt_L(:,count);
            Drager3.reference(:,cnt_ref) = Drager2.EIT_filt_L(:,count);
            if size(Drager2.reference,2)>10 % 10 mean ref
                Drager2.reference(:,cnt_ref) = mean(Drager2.reference(:,cnt_ref-10:cnt_ref),2);
            end
            cnt_ref = cnt_ref + 1;
        end
        flag = 1;
        inhale_count = inhale_count + 1;
        exhale_count = 0;
    else 
        if flag == 1 % inhale -> exhale
            Drager2.inhale_instant(cnt_inhale) = recount;
            Drager3.standard(:,cnt_ref) = Drager2.EIT_filt_L(:,count);
            cnt_inhale = cnt_inhale + 1;
            if cnt_ref == 1 % 엇박 방지
                cnt_inhale = 1;
            end
        end
        flag = 0;
        exhale_count = exhale_count + 1;
        inhale_count = 0;
    end
    
    if length(Drager2.reference) ~= 0
        Drager2.EIT_result(:,recount) = Drager2.EIT_filt_L(:,count) - Drager2.reference(:,cnt_ref-1);
        Drager2.PV_result(recount,:) = Drager2.PV_raw(count,:);
        Drager2.time(:,recount) = DataSet.time(:,i);

        
        EIT_proj = Data.Proj_Mat * Drager2.EIT_result(:,recount);
        Drager2.EIT_sigma(:,recount) = Data.inv_Sense_weighted_avg * EIT_proj; clear EIT_proj;
        Drager2.imgscale = min(Drager2.EIT_sigma(:,1));
        Drager2.EIT_waveform(1,recount) = -sum(Drager2.EIT_sigma(:,recount));
        
%         F = TriScatteredInterp(xy(:,1),xy(:,2),Drager2.EIT_sigma(:,recount));
%         Drager2.Image(:,:,i) = F(qx,qy);
        
        FxDrager_timeplot( Drager2, recount )
        
        if cnt_ref == cnt_inhale
            Tidal_flag = 1;
        end
        
        if cnt_ref > cnt_inhale && Tidal_flag == 1
            Tidal_flag = 0;
            Tidal_start = 1;
            Drager3.Tidal_EIT(:,cnt_inhale-1) =  Drager3.standard(:,cnt_inhale-1) - Drager3.reference(:,cnt_inhale-1);
            EIT_proj = Data.Proj_Mat * Drager3.Tidal_EIT(:,cnt_inhale-1);
            Drager3.Tidal_sigma(:,cnt_inhale-1) = Data.inv_Sense_weighted_avg * EIT_proj; clear EIT_proj;
           
            Drager3.Tidal_Image = FxDrager_Tidal_Tri2Grid(Data.Element,Data.Node,Drager3.Tidal_sigma(:,cnt_inhale-1),256,cnt_inhale-1);
            
            Tidal_scale = min(min(Drager3.Tidal_Image(:,:,1)));
            subplot(6,6,7);imagesc(Drager3.Tidal_Image(:,:,cnt_inhale-1));
            set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]); axis square;
            caxis([-abs(Tidal_scale) abs(Tidal_scale)]); colormap(Cmap); hold off;
            
            if size(Drager3.Tidal_Image,3)>10
                Drager3.Minute_Image(:,:,cnt_inhale-11) = mean(Drager3.Tidal_Image(:,:,end-9:end),3);
               
                Minute_scale = min(min(Drager3.Minute_Image(:,:,1)));
                figure(1);subplot(6,6,13);imagesc(Drager3.Minute_Image(:,:,cnt_inhale-11));
                set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]); axis square;
                caxis([-abs(Minute_scale) abs(Minute_scale)]); colormap(Cmap);hold off;
            end
        end
        
        
        if Tidal_start == 1;
            Drager4 = FsDrager_ROI( Drager2.EIT_sigma(:,recount), Drager3.Tidal_sigma, Tidal_scale, Data, Cmap );
%             Drager4 = FxDrager_ROI_timeplot( Drager2, Drager4, recount );
        end
        
%         FxDrager_ROI_timeplot( Drager4, recount )
        
%         a = min(Drager2.EIT_sigma(:,1));
%         subplot(6,6,[1 2 7 8]); imagesc(Drager2.Image(:,:,recount)); 
%         set(gca,'YDir','normal'); set(gca,'xdir','normal'); set(gca,'xtick',[], 'ytick',[]); axis square;
%         caxis([-abs(a) abs(a)]); colormap(Cmap);
        
        recount = recount + 1;
        pause(0.00000001)
    end
    
    count = count + 1;
    disp(num2str(recount));
end

end

