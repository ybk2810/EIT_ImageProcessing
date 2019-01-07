function [ s ] = FxDrager_timeplot_2Cursor( Drager_ChangeRef, Drager_ROI, Drager_Cursor_C1, Drager_Cursor_C2 )
FxEIT_timeplot_ROI( Drager_ChangeRef.time, Drager_ROI.ROI0, Drager_ROI.ROI1, 1, size(Drager_ROI.ROI0,2) )
subplot(5,5,[1 2 3 4]); hold on; plot(Drager_Cursor_C2.x, Drager_ROI.ROI0(Drager_Cursor_C2.x), 'r','LineWidth',2)
subplot(5,5,[6 7 8 9]); hold on; plot(Drager_Cursor_C2.x, reshape(Drager_ROI.ROI1.first(Drager_Cursor_C2.x),1,length(Drager_Cursor_C2.x)), 'r','LineWidth',2)
subplot(5,5,[11 12 13 14]); hold on; plot(Drager_Cursor_C2.x, reshape(Drager_ROI.ROI1.second(Drager_Cursor_C2.x),1,length(Drager_Cursor_C2.x)), 'r','LineWidth',2)
subplot(5,5,[16 17 18 19]); hold on; plot(Drager_Cursor_C2.x, reshape(Drager_ROI.ROI1.third(Drager_Cursor_C2.x),1,length(Drager_Cursor_C2.x)), 'r','LineWidth',2)
subplot(5,5,[21 22 23 24]); hold on; plot(Drager_Cursor_C2.x, reshape(Drager_ROI.ROI1.fourth(Drager_Cursor_C2.x),1,length(Drager_Cursor_C2.x)), 'r','LineWidth',2)

subplot(5,5,[1 2 3 4]); hold on; plot(Drager_Cursor_C1.x, Drager_ROI.ROI0(Drager_Cursor_C1.x), 'r','LineWidth',2)
subplot(5,5,[6 7 8 9]); hold on; plot(Drager_Cursor_C1.x, reshape(Drager_ROI.ROI1.first(Drager_Cursor_C1.x),1,length(Drager_Cursor_C1.x)), 'r','LineWidth',2)
subplot(5,5,[11 12 13 14]); hold on; plot(Drager_Cursor_C1.x, reshape(Drager_ROI.ROI1.second(Drager_Cursor_C1.x),1,length(Drager_Cursor_C1.x)), 'r','LineWidth',2)
subplot(5,5,[16 17 18 19]); hold on; plot(Drager_Cursor_C1.x, reshape(Drager_ROI.ROI1.third(Drager_Cursor_C1.x),1,length(Drager_Cursor_C1.x)), 'r','LineWidth',2)
subplot(5,5,[21 22 23 24]); hold on; plot(Drager_Cursor_C1.x, reshape(Drager_ROI.ROI1.fourth(Drager_Cursor_C1.x),1,length(Drager_Cursor_C1.x)), 'r','LineWidth',2)
s=[];
end

