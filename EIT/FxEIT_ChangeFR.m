function [ output_data,data_projection ] = FxEIT_ChangeFR( data, rate )
% [ output_data ] = ChangeFR( data, rate )
%   Apply projection according to time depending on the rate you want to change
%   rate option : '10frame', '5frame', '1frame', '1frame projection update'

if rate == 1                                                                % 10frame
    flag =[0,3,6,9,12,16];
    for cnt_frame = 1:floor(size(data,2)/5)
%         output_data(13*0+1:13*3,cnt_frame) = data(13*0+1:13*3,(cnt_frame-1)*5+1);
%         output_data(13*3+1:13*6,cnt_frame) = data(13*3+1:13*6,(cnt_frame-1)*5+2);
%         output_data(13*6+1:13*9,cnt_frame) = data(13*6+1:13*9,(cnt_frame-1)*5+3);
%         output_data(13*9+1:13*12,cnt_frame) = data(13*9+1:13*12,(cnt_frame-1)*5+4);
%         output_data(13*12+1:13*16,cnt_frame) = data(13*12+1:13*16,(cnt_frame-1)*5+5);
        for cnt_injection = 1:5
            output_data(13*flag(cnt_injection)+1:13*flag(cnt_injection+1),cnt_frame) = ...
            data(13*flag(cnt_injection)+1:13*flag(cnt_injection+1),(cnt_frame-1)*5+cnt_injection);
        end
    end
    
elseif rate == 2                                                            % 5frame
    flag = [0,1,3,4,6,7,9,10,12,14,16];
    for cnt_frame = 1:floor(size(data,2)/10)
%         output_data(13*0+1:13*1,cnt_frame) = data(13*0+1:13*1,(cnt_frame-1)*10+1);
%         output_data(13*1+1:13*3,cnt_frame) = data(13*1+1:13*3,(cnt_frame-1)*10+2);
%         output_data(13*3+1:13*4,cnt_frame) = data(13*3+1:13*4,(cnt_frame-1)*10+3);
%         output_data(13*4+1:13*6,cnt_frame) = data(13*4+1:13*6,(cnt_frame-1)*10+4);
%         output_data(13*6+1:13*7,cnt_frame) = data(13*6+1:13*7,(cnt_frame-1)*10+5);
%         output_data(13*7+1:13*9,cnt_frame) = data(13*7+1:13*9,(cnt_frame-1)*10+6);
%         output_data(13*9+1:13*10,cnt_frame) = data(13*9+1:13*10,(cnt_frame-1)*10+7);
%         output_data(13*10+1:13*12,cnt_frame) = data(13*10+1:13*12,(cnt_frame-1)*10+8);
%         output_data(13*12+1:13*14,cnt_frame) = data(13*12+1:13*14,(cnt_frame-1)*10+9);
%         output_data(13*14+1:13*16,cnt_frame) = data(13*14+1:13*16,(cnt_frame-1)*10+10);
        for cnt_injection = 1:10
            output_data(13*flag(cnt_injection)+1:13*flag(cnt_injection+1),cnt_frame) = ...
            data(13*flag(cnt_injection)+1:13*flag(cnt_injection+1),(cnt_frame-1)*10+cnt_injection);
        end
    end
    
elseif rate == 3                                                            % 1frame
    flag = [1,4,7,10,14,17,20,23,26,29,32,35,39,42,45,48];
    for cnt_frame = 1:floor(size(data,2)/50)
%         output_data(13*0+1:13*1,cnt_frame) = data(13*0+1:13*1,(cnt_frame-1)*50+1);
%         output_data(13*1+1:13*2,cnt_frame) = data(13*1+1:13*2,(cnt_frame-1)*50+4);
%         output_data(13*2+1:13*3,cnt_frame) = data(13*2+1:13*3,(cnt_frame-1)*50+7);
%         output_data(13*3+1:13*4,cnt_frame) = data(13*3+1:13*4,(cnt_frame-1)*50+10);
%         output_data(13*4+1:13*5,cnt_frame) = data(13*4+1:13*5,(cnt_frame-1)*50+14);
%         output_data(13*5+1:13*6,cnt_frame) = data(13*5+1:13*6,(cnt_frame-1)*50+17);
%         output_data(13*6+1:13*7,cnt_frame) = data(13*6+1:13*7,(cnt_frame-1)*50+20);
%         output_data(13*7+1:13*8,cnt_frame) = data(13*7+1:13*8,(cnt_frame-1)*50+23);
%         output_data(13*8+1:13*9,cnt_frame) = data(13*8+1:13*9,(cnt_frame-1)*50+26);
%         output_data(13*9+1:13*10,cnt_frame) = data(13*9+1:13*10,(cnt_frame-1)*50+29);
%         output_data(13*10+1:13*11,cnt_frame) = data(13*10+1:13*11,(cnt_frame-1)*50+32);
%         output_data(13*11+1:13*12,cnt_frame) = data(13*11+1:13*12,(cnt_frame-1)*50+35);
%         output_data(13*12+1:13*13,cnt_frame) = data(13*12+1:13*13,(cnt_frame-1)*50+39);
%         output_data(13*13+1:13*14,cnt_frame) = data(13*13+1:13*14,(cnt_frame-1)*50+42);
%         output_data(13*14+1:13*15,cnt_frame) = data(13*14+1:13*15,(cnt_frame-1)*50+45);
%         output_data(13*15+1:13*16,cnt_frame) = data(13*15+1:13*16,(cnt_frame-1)*50+48);
        for cnt_injection = 1:16
            output_data(13*(cnt_injection-1)+1:13*cnt_injection,cnt_frame) = ...
            data(13*(cnt_injection-1)+1:13*cnt_injection,(cnt_frame-1)*50+flag(cnt_injection));
        end
    end
    
elseif rate == 4                                                            % projection update
    for cnt_frame = 1:size(data,2)
        for cnt_injection = 1:16
            data_projection(1:13*1,(cnt_frame-1)*16+cnt_injection) = ...
            data(13*(cnt_injection-1)+1:13*cnt_injection,cnt_frame);
        end
    end
    for cnt_injection = 1:16
        output_data(13*(cnt_injection-1)+1:13*cnt_injection,1) = data_projection(:,cnt_injection);
    end
    cnt = 1;
    for cnt_frame = 2:size(data_projection,2)-15
        output_data(:,cnt_frame) = output_data(:,cnt_frame-1);
        output_data(13*(cnt-1)+1:13*cnt,cnt_frame) = data_projection(:,cnt_frame+15);
        if cnt == 16
            cnt = 1;
        else
            cnt = cnt+1;
        end
    end
end

end






