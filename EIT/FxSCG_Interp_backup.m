function [ Inter_Motion,Mag_data ] = FxSCG_Interp(SCGData)

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
    x_axis(1,m) = m/250; 
end

%% interpolation
SCG_Trigger_Num = find( SCGData(2,:) == 1 );
Inter_Motion1 = interp1( SCG_Trigger_Num(1,1):1:length(Mag_data1) , Mag_data1(2,(SCG_Trigger_Num(1,1):length(Mag_data1))) , SCG_Trigger_Num(1,1):0.5:length(Mag_data1) );
Inter_Motion2 = interp1( SCG_Trigger_Num(1,1):1:length(Mag_data1) , Mag_data1(3,(SCG_Trigger_Num(1,1):length(Mag_data1))) , SCG_Trigger_Num(1,1):0.5:length(Mag_data1) );
Inter_Motion3 = interp1( SCG_Trigger_Num(1,1):1:length(Mag_data1) , Mag_data1(4,(SCG_Trigger_Num(1,1):length(Mag_data1))) , SCG_Trigger_Num(1,1):0.5:length(Mag_data1) );
Inter_Motion4 = interp1( SCG_Trigger_Num(1,1):1:length(Mag_data1) , Mag_data1(5,(SCG_Trigger_Num(1,1):length(Mag_data1))) , SCG_Trigger_Num(1,1):0.5:length(Mag_data1) );
Inter_Motion5 = interp1( SCG_Trigger_Num(1,1):1:length(Mag_data1) , Mag_data1(6,(SCG_Trigger_Num(1,1):length(Mag_data1))) , SCG_Trigger_Num(1,1):0.5:length(Mag_data1) );
Inter_Motion6 = interp1( SCG_Trigger_Num(1,1):1:length(Mag_data1) , Mag_data1(7,(SCG_Trigger_Num(1,1):length(Mag_data1))) , SCG_Trigger_Num(1,1):0.5:length(Mag_data1) );
Inter_Motion7 = interp1( SCG_Trigger_Num(1,1):1:length(Mag_data1) , Mag_data1(8,(SCG_Trigger_Num(1,1):length(Mag_data1))) , SCG_Trigger_Num(1,1):0.5:length(Mag_data1) );
Inter_Motion(1,:) = Inter_Motion1;
Inter_Motion(2,:) = Inter_Motion2;
Inter_Motion(3,:) = Inter_Motion3;
Inter_Motion(4,:) = Inter_Motion4;
Inter_Motion(5,:) = Inter_Motion5;
Inter_Motion(6,:) = Inter_Motion6;
Inter_Motion(7,:) = Inter_Motion7;
Inter_Motion = Inter_Motion';

end