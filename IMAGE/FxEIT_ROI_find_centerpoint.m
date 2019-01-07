function [ x_mean y_mean ] = FxEIT_ROI_find_centerpoint ( ROI, nodes, elems )

repmatdata = elems.*repmat(ROI,1,3)

sorted_remat=sort(repmatdata)

sorted_data =reshape(sorted_remat,[],1)

sorted_data=sort(sorted_data)

sorted_data(sorted_data == 0) =[];
cnt =1;
temp = [];
for i = 1:size(sorted_data,1)-1
    if sorted_data(i,1)==sorted_data(i+1,1)
        temp(cnt) = i;
        cnt=cnt+1;
    end
end
sorted_data(temp)=[];
clear temp;


x_mean = mean(nodes(sorted_data,1));
y_mean = mean(nodes(sorted_data,2));

end