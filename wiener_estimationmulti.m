function [estimatedspecimg]=wiener_estimationmulti(macbethsp,ill81,spec81,g,height,width)
%�}�N�x�X�̕������x�A�Ɩ����X�y�N�g���A�J�����̕������x�A�摜
%Winner estimation
%estimation matrix�����
%r�̍s�� k=81

[col,row]=size(spec81); %���͂̃o���h�� 
[g_col,g_row]=size(g);

%R�̎Z�o-----------------------------------
% rrt=zeros(81,81);
% for i=2:25
%     r=macbethsp(:,i);
%     rrt=rrt+r*r';
% end
% rrt=rrt/24;
%\-----------------------------------
rrt=csvread('../data/macbeth_markov_corr.csv');

H=spec81.*ill81;

HffH=H*rrt*H';
matsize=size(HffH);
% middle=round(matsize(1,1)/2)+1;
% Rn=(HffH(middle,middle)/10000)*eye(matsize(1,1));
% HffH(middle,middle)/10000
% A=rrt*H'*inv(H*rrt*H');
middle=round(matsize(1,1)/2)+1;
Rnseed=HffH(middle,middle)/1000000
Rn=(Rnseed)*eye(matsize(1,1));
A=rrt*H'*inv(H*rrt*H'+Rn);
estimatedspecimg=zeros(g_col,81);
for i=1:col
    estimatedspecimg=estimatedspecimg+g(:,i).*A(:,i)';
end

estimatedspecimg(estimatedspecimg>1.0)=1.0;
estimatedspecimg(estimatedspecimg<0)=0;
end