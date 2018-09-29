clear all
illminant=1;
%input('Please select the spectral image(1-3)\n\n<1>D65\n<2>A\n<3>F1\n<4>An object at rest\n<5>Portrait\n<6>Fruits\n<7>Bottle\n<8>Wool\n>>>');
wiener=1;
%input('wiener estimate?(0-1)\n\n<0>no\n<1>yes\n');
piecewisewiener=1;
%input('p-wiener estimate?(0-1)\n\n<0>no\n<1>yes\n');


macbethsp=csvread('../data/macbeth.csv'); %マクベス分光反射率データ
sp81=macbethchart(macbethsp,8,4); %分光画像作成
wl81=380:5:780; %波長の配列

%高さと幅
tempsize=size(sp81);
height=tempsize(1,1);
width=tempsize(1,2);

%分光画像作製
% extension='.bmp'
% rootname='macbethspectrumimage_'
% for sp=1:81
%     for i=1:height
%         for j=1:width
%             spimage(i,j)=sp81(i,j,sp);
%         end
%     end
%     %spimagematrix(1,sp)=spimage;
%     filename = [rootname, num2str(sp), extension];
%     imwrite(spimage,filename);
% end


%光源データの読み込み(ill)、補完
%https://www.rit.edu/cos/colorscience/rc_useful_data.php  の　Full set of 1nm data, including all of the following
if illminant==1
    illname='d65';
%     ill81=csvread('nakamaillmination.csv');
    ill_401=csvread('../data/d65.csv');

elseif illminant==2
    ill_401=csvread('../data/a.csv');
elseif illminant==3
    ill_401=csvread('../data/F1toF12.csv');
end
 ill81=(ill_401(:,2))';
 ill81=imresize(ill81,[1 81]);


%デジタルカメラ分光感度読み込み
rgb401=csvread('../data/digitalcamera_d1.csv');
rgb401=rgb401(:,2:4)';
rgb81=imresize(rgb401,[3 81],'nearest');

%XYZ等色関数の読み込み、変換
%https://www.waveformlighting.com/tech/color-matching-function-x-y-z-values-by-wavelength-csv-excel-format
xyz401=csvread('../data/xyz.csv');
xyz401=xyz401(:,2:4)';
xyz81=imresize(xyz401,[3 81],'nearest');

%///
sp81=reshape(sp81,height*width,81);
%///

[grgb,g_norm]=spec2rgb(sp81,ill81,rgb81);

%///
%grgb=reshape(grgb,height,width,3);
g_norm=reshape(g_norm,height,width,3);
%///

[gxyz,gxyz_norm]=spec2xyz(sp81,ill81,xyz81);

%///
gxyz=reshape(gxyz,height,width,3);
gxyz_norm=reshape(gxyz_norm,height,width,3);
%///

 %XYZ2sRGB in d65
 %http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
 xyz2srgbmat=[ 3.2404542 -1.5371385 -0.4985314;...
             -0.9692660  1.8760108  0.0415560;...
              0.0556434 -0.2040259  1.0572252];
 gxyz_srgb=zeros(height,width,3);
 for i=1:height
          for j=1:width
             tempgxyz(1,:)=gxyz_norm(i,j,:);
             tempgxyztrans=tempgxyz';
             gxyz_srgb(i,j,:)=xyz2srgbmat*tempgxyztrans;
          end
 end



if wiener==1
    estimatedimg=wiener_estimation(macbethsp,ill81,rgb81,grgb,height,width);
    [est_gxyz,est_gxyz_norm]=spec2xyz(estimatedimg,ill81,xyz81);
    %///
    est_gxyz=reshape(est_gxyz,height,width,3);
    est_gxyz_norm=reshape(est_gxyz_norm,height,width,3);
    %///

    est_gxyz_srgb=zeros(height,width,3);
     for i=1:height
              for j=1:width
                 tempest_gxyz(1,:)=est_gxyz_norm(i,j,:);
                 tempest_gxyztrans=tempest_gxyz';
                 est_gxyz_srgb(i,j,:)=xyz2srgbmat*tempest_gxyztrans;
              end
     end
    est_gxyz_srgb=gammahosei(est_gxyz_srgb,height,width);

end

 
if piecewisewiener==1
    L=4;
    k=4;
    %///
    sp81=reshape(sp81,height,width,81);
    %///
    p_estimatedimg=piecewise_wiener_estimation(ill81,rgb81,grgb,sp81,height,width,L,k);
    [p_est_gxyz,p_est_gxyz_norm]=spec2xyz(p_estimatedimg,ill81,xyz81);
    
    %///
    p_est_gxyz=reshape(p_est_gxyz,height,width,3);
    p_est_gxyz_norm=reshape(p_est_gxyz_norm,height,width,3);
    %///
   
    imshow3Dfull(p_est_gxyz_norm);
    p_est_gxyz_srgb=zeros(height,width,3);
     for i=1:height
              for j=1:width
                 tempp_est_gxyz(1,:)=p_est_gxyz_norm(i,j,:);
                 tempp_est_gxyztrans=tempp_est_gxyz';
                 p_est_gxyz_srgb(i,j,:)=xyz2srgbmat*tempp_est_gxyztrans;
              end
     end
    p_est_gxyz_srgb=gammahosei(p_est_gxyz_srgb,height,width);

end

g_norm=gammahosei(g_norm,height,width);
gxyz_srgb=gammahosei(gxyz_srgb,height,width);

if piecewisewiener==1
     figure
     subplot(2,2,1)
     imshow(uint8(g_norm.*255))
    title('rgb')
      subplot(2,2,2)
      imshow(uint8(gxyz_srgb.*255))
    title('xyz')
      subplot(2,2,3)
      imshow(uint8(est_gxyz_srgb.*255))
    title('estimation')
      subplot(2,2,4)
      imshow(uint8(p_est_gxyz_srgb.*255))
    title('p-estimation')
else 
     figure
     subplot(1,3,1)
     imshow(uint8(g_norm.*255))
    title('rgb')
      subplot(1,3,2)
      imshow(uint8(gxyz_srgb.*255))
    title('xyz')
end
  imwrite(uint8(g_norm.*255),'3digital3band.bmp');
   imwrite(uint8(gxyz_srgb.*255),'3xyz.bmp');
   imwrite(uint8(est_gxyz_srgb.*255),'3est_xyz.bmp');
   imwrite(uint8(p_est_gxyz_srgb.*255),'3p_est_xyz.bmp');

tmp1(1,:)=sp81(5,5,:);
a=reshape(estimatedimg,height,width,81);
b=reshape(p_estimatedimg,height,width,81);
tmp2(1,:)=a(5,5,:);
tmp2p(1,:)=b(5,5,:);
%  tmp3(1,:)=sp81(668,686,:);
%  tmp4(1,:)=estimatedimg(668,686,:);
%  tmp4p(1,:)=p_estimatedimg(668,686,:);
%  tmp5(1,:)=sp81(755,1106,:);
%  tmp6(1,:)=estimatedimg(755,1106,:)
%  tmp6p(1,:)=p_estimatedimg(755,1106,:)

 figure
% subplot(1,3,1)
plot(wl81,tmp1,wl81,tmp2,wl81,tmp2p)
ylim([0 1])
title('back')
% subplot(1,3,2)
% plot(wl81,tmp3,wl81,tmp4,wl81,tmp4p)
% ylim([0 1])
% title('leaf')
% subplot(1,3,3)
% plot(wl81,tmp5,wl81,tmp6,wl81,tmp6p)
% ylim([0 1])
% title('fake')

% tmp3(1,:)=sp81(668,686,:);
% tmp4(1,:)=estimatedimg(668,686,:);
% tmp4p(1,:)=p_estimatedimg(668,686,:);
% tmp5(1,:)=sp81(755,1106,:);
% tmp6(1,:)=estimatedimg(755,1106,:)
% tmp6p(1,:)=p_estimatedimg(755,1106,:)



%   imwrite(uint8(g_norm.*255),'leaf_dsc.bmp');
%   imwrite(uint8(gxyz_srgb.*255),'leaf_xyz.bmp');