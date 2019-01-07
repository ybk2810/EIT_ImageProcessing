function [ ROI ] = FxEIT_ROI_tri_cut_diagonal_line( ROI, Data, x, y, set, angle, Cmap )

% y=angle*x+offset;
offset = y - angle*x;

flag = []; roc = 1;                                                         %node
if set == 1
    for i = 1:length(Data.Node)
        if Data.Node(i,2) > angle*Data.Node(i,1)+offset
            flag(roc) = i; roc = roc+1;
        end
    end
elseif set == 2
    for i = 1:length(Data.Node)
        if Data.Node(i,2) < angle*Data.Node(i,1)+offset
            flag(roc) = i; roc = roc+1;
        end
    end
end

for i = 1:length(Data.Element)                                              %element
    for j = 1:length(flag)
        if Data.Element(i,1)==flag(j) | Data.Element(i,2)==flag(j) | Data.Element(i,3)==flag(j)
            ROI(i,1) = 0;
        end
    end
end

figure; patch('Faces',Data.Element,'Vertices' ,Data.Node,'FaceVertexCData' ,ROI,'FaceColor' ,'flat' ,'EdgeColor' ,'None' );
axis equal; caxis([0 1]); colormap(Cmap); axis off;

end