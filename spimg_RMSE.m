function spimg_RMSE(img1,img2,original)
% (img1,img2,original)

% img1_row=reshape(img1,gyou*retu,ta);
% img2_row=reshape(img2,1,gyou*retu,ta);
% 
% img1=csvread('C:\Users\fumin\Documents\wiener_estimate\p_1-1.csv');
% img2=csvread('C:\Users\fumin\Documents\wiener_estimate\w_1-1.csv');
% original=csvread('C:\Users\fumin\Documents\wiener_estimate\•ªŒõ‰æ‘œcsv\1-1\1-1.csv');
rmse_map1=sqrt(sum((img1-original).^2,2)./81);
rmse_map2=sqrt(sum((img2-original).^2,2)./81);

if max(rmse_map1)>max(rmse_map2)
    maxn=max(rmse_map1);
else
    maxn=max(rmse_map2);
end
figure
subplot(1,2,1)
 imagesc(reshape(rmse_map1,1024,1280),[0,0.3]);
 colorbar;
 subplot(1,2,2)
 imagesc(reshape(rmse_map2,1024,1280),[0,0.3]);
 colorbar;

end