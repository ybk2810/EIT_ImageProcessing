function [ electrode2 ] = FxKHU_tilt( electrode, rotAngle )
%UNTITLED2 �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
electrode2(:,1) = electrode(:,1).*cos(rotAngle) - electrode(:,2).*sin(rotAngle);
electrode2(:,2) = electrode(:,1).*sin(rotAngle) + electrode(:,2).*cos(rotAngle);

end

