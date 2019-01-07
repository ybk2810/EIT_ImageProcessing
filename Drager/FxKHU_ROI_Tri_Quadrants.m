function [ ROI_Q ] = FxKHU_ROI_T_Quadrants( ROI, Data,C )
% 20170611 2017EIT학회 heart ROI quadrants tri_mesh
ROI_Q.ROI = ROI;

ROI_Element = ROI.*[1:size(ROI,1)]';
ROI_Element(ROI_Element==0)=[];
ROI_Element=ROI_Element'; % ROI에 해당하는 element

temp = Data.Element(ROI_Element,:);
temp1(1:size(temp,1)) = temp(:,1);
temp1(end+1:end+size(temp,1)) = temp(:,2);
temp1(end+1:end+size(temp,1)) = temp(:,3);
temp1 = sort(temp1);

cnt=1;
for i=1:size(temp1,2)-1
    if temp1(i)==temp1(i+1)
        temp2(cnt)=i+1;
        cnt=cnt+1;
    end
end
temp1(temp2)=[];

ROI_Node = Data.Node(temp1,:); % ROI에 해당하는 node
x_max = max(ROI_Node(:,1));
x_min = min(ROI_Node(:,1));
y_max = max(ROI_Node(:,2));
y_min = min(ROI_Node(:,2));
Center = [round((x_max + x_min)/2),round((y_max + y_min)/2)];

[ ROI_Q.ROI1 ] = FxEIT_ROI_tri_cut( ROI, Data, Center(1), Center(2), 1, 1, C );
[ ROI_Q.ROI2 ] = FxEIT_ROI_tri_cut( ROI, Data, Center(1), Center(2), 2, 1, C );
[ ROI_Q.ROI3 ] = FxEIT_ROI_tri_cut( ROI, Data, Center(1), Center(2), 1, 2, C );
[ ROI_Q.ROI4 ] = FxEIT_ROI_tri_cut( ROI, Data, Center(1), Center(2), 2, 2, C );

end

