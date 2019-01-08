function [ result1, result2, result3 ] = FxEIT_BoipacImport( Boipac, interp_value )
Boipac.data = Boipac.data';
if max(Boipac.data(1,:)) > 10
%     while BoipacData.data(1,1)<1
%         BoipacData.data(1,:) = [];
%     end
    EIT_stat = Boipac.data(1,:);
    
    a = 49; b = 5; 
    [ roc, ~ ] = FxEIT_BIOPAC_trigger( EIT_stat, a, b );
    
    if nargin == 2
        while  (roc(2)-roc(1))/interp_value < 1
            temp = [];
            for i = 1:size(Boipac.data,1)
                temp(i,:) = interp1(1:1:size(Boipac.data,2), Boipac.data(i,:), 1:0.5:size(Boipac.data,2));
            end
            Boipac.data = temp;
            Boipac.data(1,:) = round(Boipac.data(1,:));
            EIT_stat = Boipac.data(1,:);
            [ roc, ~ ] = FxEIT_BIOPAC_trigger( EIT_stat, a, b );
        end
        [ roc, ~ ] = FxEIT_BIOPAC_trigger( EIT_stat, a, b, interp_value );
        
    end

    Boipac_index = round((roc(1:end-1) + roc(2:end))./2);                  % find ECG BoipacData.data in each middle point of window trigger
    if size(Boipac.data,1) == 2
        Boipac_Data.data1 = Boipac.data(2,:);
        result1 = Boipac_Data.data1(Boipac_index);        % ECG BoipacData.data match with EIT frame rate
    elseif size(Boipac.data,1) == 3
        Boipac_Data.data1 = Boipac.data(2,:);
        Boipac_Data.data2 = Boipac.data(3,:);
        result1 = Boipac_Data.data1(Boipac_index);
        result2 = Boipac_Data.data2(Boipac_index);
    elseif size(Boipac.data,1) == 4
        Boipac_Data.data1 = Boipac.data(2,:);
        Boipac_Data.data2 = Boipac.data(3,:);
        Boipac_Data.data3 = Boipac.data(4,:);
        result1 = Boipac_Data.data1(Boipac_index);
        result2 = Boipac_Data.data2(Boipac_index);
        result3 = Boipac_Data.data3(Boipac_index);
    end

elseif max(Boipac.data(:,2)) > 10
%     while BoipacData.data(1,1)<10
%         BoipacData.data(2,:) = [];
%     end
    EIT_stat = Boipac.data(2,:);
    
    flag = 1;
    cnt = 0;
    a = 49; b = 5; % 
    for i = 1:length(EIT_stat)-1
        if (EIT_stat(i)>a) && (flag==1)
            cnt = cnt+1;
            flag = 0;
            roc(cnt) = i;
        elseif (EIT_stat(i)<b) && (flag==0)
            cnt = cnt+1;
            flag = 1;
            roc(cnt) = i;
        end
        EIT_index(i) = cnt;
    end

    Boipac_index = round((roc(1:end-1) + roc(2:end))./2);                  % find ECG BoipacData.data in each middle point of window trigger
    Boipac_Data.data1 = Boipac.data(1,:);
    result1 = Boipac_Data.data1(Boipac_index);
end

end

