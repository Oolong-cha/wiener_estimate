function [rmse_map] = spimg_RMSE(img1,img2)

%分光画像の大きさの取得 最終的にはメインプログラム内では一次元で受け渡
%ししたいのでここは消える予定
[gyou,retu,ta]=size(img1);

img1_row=reshape(img1,1,gyou*retu,ta);
img2_row=reshape(img2,1,gyou*retu,ta);

rmse_map=sqrt(sum((img1_row-img2_row).^2,3)./ta);


end