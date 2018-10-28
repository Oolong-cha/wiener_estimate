function [estimatedspecimg]=wiener_estimationmulti_markov(macbethsp,ill81,spec81,g,height,width,markov)
%マクベスの分光感度、照明光スペクトル、カメラの分光感度、画像
%Winner estimation
%estimation matrixを作る
%rの行列 k=81

[col,row]=size(spec81); %入力のバンド数 
[g_col,g_row]=size(g);

%Rの算出-----------------------------------
rrt=markov;
%\-----------------------------------


H=spec81.*ill81;

A=rrt*H'*inv(H*rrt*H');
estimatedspecimg=zeros(g_col,81);
for i=1:col
    estimatedspecimg=estimatedspecimg+g(:,i).*A(:,i)';
end


end