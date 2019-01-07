function [ ROI ] = FxEIT_ROI_tri_cut( ROI, Data, x, y, set1, set2, C )
%% y<th
flag = []; roc = 1;                                                         %node
if set2 == 1
    for i = 1:length(Data.Node)
        if Data.Node(i,2) < y
            flag(roc) = i; roc = roc+1;
        end
    end
elseif set2 == 2
    for i = 1:length(Data.Node)
        if Data.Node(i,2) > y
            flag(roc) = i; roc = roc+1;
        end
    end
end

if set2 == 1 || set2 == 2
    for i=1:length(Data.Element)                                                %element
        for j = 1:length(flag)
            if Data.Element(i,1)==flag(j) | Data.Element(i,2)==flag(j) | Data.Element(i,3)==flag(j)
                ROI(i,1) = 0;
            end
        end
    end
end

%% x<th
flag = []; roc = 1;                                                         %node
if set1 == 1
    for i = 1:length(Data.Node)
        if Data.Node(i,1) > x
            flag(roc) = i; roc = roc+1;
        end
    end
elseif set1 == 2
    for i = 1:length(Data.Node)
        if Data.Node(i,1) < x
            flag(roc) = i; roc = roc+1;
        end
    end
end

if set1 == 1 || set1 == 2
    for i = 1:length(Data.Element)                                              %element
        for j = 1:length(flag)
            if Data.Element(i,1)==flag(j) | Data.Element(i,2)==flag(j) | Data.Element(i,3)==flag(j)
                ROI(i,1) = 0;
            end
        end
    end
end

figure; patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,ROI,'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
axis equal; caxis([0 1]); colormap(C); axis off;

end