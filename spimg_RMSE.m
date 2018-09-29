function [rmse_map] = spimg_RMSE(img1,img2)

%�����摜�̑傫���̎擾 �ŏI�I�ɂ̓��C���v���O�������ł͈ꎟ���Ŏ󂯓n
%���������̂ł����͏�����\��
[gyou,retu,ta]=size(img1);

img1_row=reshape(img1,1,gyou*retu,ta);
img2_row=reshape(img2,1,gyou*retu,ta);

rmse_map=sqrt(sum((img1_row-img2_row).^2,3)./ta);


end