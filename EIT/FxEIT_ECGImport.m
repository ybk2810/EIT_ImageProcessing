function [ ECG_data ] = FxEIT_ECGImport( ECG_path )
load(ECG_path)

try
    while (data(1,1)<30)
        data(1,:) = [];
    end
    EIT_stat = data(:,1);
    ECG_data = data(:,2);

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

    ECG_index = round((roc(1:end-1) + roc(2:end))./2);     % find ECG data in each middle point of window trigger
    ECG_data = ECG_data(ECG_index)';                       % ECG data match with EIT frame rate
catch
    while (data(1,2)<30)
        data(1,:) = [];
    end
    EIT_stat = data(:,2);
    ECG_data = data(:,1);

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

    ECG_index = round((roc(1:end-1) + roc(2:end))./2);     % find ECG data in each middle point of window trigger
    ECG_data = ECG_data(ECG_index)';                       % ECG data match with EIT frame rate
end
end

