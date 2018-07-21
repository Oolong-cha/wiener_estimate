function [estimatedspecimg]=wiener_estimation(macbethsp,ill81,rgb81,grgb,height,width)
%マクベスの分光感度、照明光スペクトル、カメラの分光感度、画像
%Winner estimation
%estimation matrixを作る
%R_rv　茶色
%rの行列 k=81
wl81=380:5:780;
rrt=zeros(81,81);
for i=2:25
    r=macbethsp(:,i);
    rrt=rrt+r*r';
end
rrt=rrt/24;

for i=1:3
    S=rgb81(i,:);
    for j=1:81
        H(i,j)=S(1,j).*ill81(1,j);
    end
end

A=rrt*H'*inv(H*rrt*H');

estimatedspecimg=zeros(height,width,81);
for i=1:height
    i
    for j=1:width
        vtemp=grgb(i,j,:);
        v(:,1)=vtemp;
        r_est=A*v;
        r_est(r_est>1)=1;
        estimatedspecimg(i,j,:)=r_est;
    end
end

end