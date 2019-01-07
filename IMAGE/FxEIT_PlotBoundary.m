function [ROI_contour_outside] = FxEIT_PlotBoundary(bnd,color,width,opt)
if nargin < 4
    bnd(isnan(bnd)) = 0;
    if bnd(1,1) == 1
        bnd = ~bnd;
    end
    [temp(1) temp(2)] = find(bnd,1);
    ROI_contour_outside = bwtraceboundary(bnd,temp,'W',8,Inf,'counterclockwise');

    if nargin < 2
        color = 'w';
        width = 2;
    elseif nargin < 3
        width = 2;
    end
    hold on; plot(ROI_contour_outside(:,2),ROI_contour_outside(:,1),color,'LineWidth',width);
    
elseif opt ==2
    
    bnd(isnan(bnd)) = 0;
    if bnd(1,1) == 1
        bnd = ~bnd;
    end
    temp=[];
    left_bnd = bnd(:,1:size(bnd,1)/2);
    right_bnd = bnd(:,size(bnd,1)/2+1:end);

    [temp(1) temp(2)] = find(left_bnd,1);
    [temp2(1) temp2(2)] = find(right_bnd,1);
    left_ROI_bnd = bwtraceboundary(left_bnd,temp,'W',8,Inf,'counterclockwise');
    right_ROI_bnd = bwtraceboundary(right_bnd,temp2,'W',8,Inf,'counterclockwise');

    

    if nargin < 2
        color = 'w';
        width = 2;
    elseif nargin < 3
        width = 2;
    end
    hold on; 
    plot(left_ROI_bnd(:,2),left_ROI_bnd(:,1),'w','LineWidth',width);
    plot(right_ROI_bnd(:,2)+size(bnd,1)/2,right_ROI_bnd(:,1),'w','LineWidth',width);
end