function [estimatedspecimg]=wiener_estimationmulti(macbethsp,ill81,spec81,g,height,width)
%マクベスの分光感度、照明光スペクトル、カメラの分光感度、画像
%Winner estimation
%estimation matrixを作る
%rの行列 k=81

[col,row]=size(spec81); %入力のバンド数 
[g_col,g_row]=size(g);

%Rの算出-----------------------------------
% rrt=zeros(81,81);
% for i=2:25
%     r=macbethsp(:,i);
%     rrt=rrt+r*r';
% end
% rrt=rrt/24;
%\-----------------------------------
rrt=csvread('../data/macbeth_markov_corr.csv');

H=spec81.*ill81;

A=rrt*H'*inv(H*rrt*H');
estimatedspecimg=zeros(g_col,81);
for i=1:col
    estimatedspecimg=estimatedspecimg+g(:,i).*A(:,i)';
end

estimatedspecimg(estimatedspecimg>1.0)=1.0;
end