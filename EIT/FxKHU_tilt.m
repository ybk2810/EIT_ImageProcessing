function [ electrode2 ] = FxKHU_tilt( electrode, rotAngle )
%UNTITLED2 이 함수의 요약 설명 위치
%   자세한 설명 위치
electrode2(:,1) = electrode(:,1).*cos(rotAngle) - electrode(:,2).*sin(rotAngle);
electrode2(:,2) = electrode(:,1).*sin(rotAngle) + electrode(:,2).*cos(rotAngle);

end

