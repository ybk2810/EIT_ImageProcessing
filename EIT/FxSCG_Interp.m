function [ Inter_Motion, tag, Mag_data, Mag_data1 ] = FxSCG_Interp(SCGData, interp_value)
% SCGData= DataSet.SCG_raw;
data_index = 8;

for k =1:8
    Mag_data(k,:) =  SCGData(2.*(k-1)+1,:) + (256*SCGData(2.*k,:));
end
clear k;

for m = 1: length(Mag_data)
    for n = 1: data_index
        if Mag_data(n,m) > 32767
            Mag_data1(n,m) = Mag_data(n,m) - 65536;
        else
            Mag_data1(n,m) = Mag_data(n,m);
        end
     end
%     x_axis(1,m) = m/250; 
end
clear m n;

%
a = 0.9; b = 0.1; 
EIT_stat = SCGData(2,:);
[ roc, ~ ] = FxEIT_BIOPAC_trigger( EIT_stat, a, b );

if nargin == 2
        while  (roc(2)-roc(1))/interp_value < 1.2                    % interpolation
            temp = [];
            for i = 1:size(SCGData,1)
                temp(i,:) = interp1(1:1:size(SCGData,2), SCGData(i,:), 1:0.5:size(SCGData,2));
            end
            temp2 = [];
            for i = 1:size(Mag_data1,1)
                temp2(i,:) = interp1(1:1:size(Mag_data1,2), Mag_data1(i,:), 1:0.5:size(Mag_data1,2));
            end
            SCGData = temp;
            Mag_data1 = temp2;
            SCGData(2,:) = round(SCGData(2,:));
            EIT_stat = SCGData(2,:);
            [ roc, ~ ] = FxEIT_BIOPAC_trigger( EIT_stat, a, b );
        end
        [ roc, ~ ] = FxEIT_BIOPAC_trigger( EIT_stat, a, b, interp_value );
end
    
SCG_index = round((roc(1:end-1) + roc(2:end))./2);                  % find ECG BoipacData.data in each middle point of window trigger
Inter_Motion = Mag_data1(2:8,SCG_index);
tag = {'Gyro_Z','Gyro_Y','Gyro_X','Temperature','Accel_Z','Accel_Y','Accel_X'};
Inter_Motion(4,:) = (Inter_Motion(4,:)-21 / 333.87) + 21;

end

