function [ Index ] = FxEIT_MakeFlag( Index )
%UNTITLED �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
Index(:,2) = Index;
flag = 0;
cnt = 0;
for i =1:size(Index,1)
    if Index(i,2) == 1 && flag == 1
        cnt = cnt +1;
        flag = 0;
    end
    if Index(i,2) == 0 && flag == 0
        flag = 1;
    end
    Index(i,1) = cnt;
end

end

