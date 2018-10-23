function [estimatedspecimg]=wiener_estimationmulti(macbethsp,ill81,spec81,g,height,width)
%�}�N�x�X�̕������x�A�Ɩ����X�y�N�g���A�J�����̕������x�A�摜
%Winner estimation
%estimation matrix�����
%r�̍s�� k=81

[col,row]=size(spec81); %���͂̃o���h�� 
[g_col,g_row]=size(g);
rrt=zeros(81,81);
for i=2:25
    r=macbethsp(:,i);
    rrt=rrt+r*r';
end
rrt=rrt/24;

H=spec81.*ill81;

A=rrt*H'*inv(H*rrt*H');
estimatedspecimg=zeros(g_col,81);
for i=1:col
    estimatedspecimg=estimatedspecimg+g(:,i).*A(:,i)';
end


end