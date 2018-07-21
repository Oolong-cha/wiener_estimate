clear all
% 
% imgname=input('Which image?(0-1)\n\n<0>Leaf\n<1>Flower\n');
% illminant=input('Please select the spectral image(1-3)\n\n<1>D65\n<2>A\n<3>F1\n<4>An object at rest\n<5>Portrait\n<6>Fruits\n<7>Bottle\n<8>Wool\n>>>');
%  wiener=input('wiener estimate?(0-1)\n\n<0>no\n<1>yes\n');
% piecewisewiener=input('p-wiener estimate?(0-1)\n\n<0>no\n<1>yes\n');
imgname=1;
illminant=1;
 wiener=1;
piecewisewiener=1;
% WHITEBALANCE=input('white balance?(0-1)\n\n<0>no\n<1>yes\n');

macbethsp=csvread('macbeth.csv'); %マクベス分光反射率データ

if imgname==0
    imgname='Ebajapan\sample.nh7';
    whiteboard='white.nh7';
    dark='';
else 
    imgname='Ebajapan\4-1.nh7';
    whiteboard='Ebajapan\white1(10f,22g).nh7';
    dark='Ebajapan\ダーク\近赤外非飽和(露光時間短)\dark1(10f,22g).nh7';
end
    
sp151=nh7read(imgname);
tmpsp81=sp151(:,:,17:97); %81バンド分光イメージ(入力画像)
wh151=nh7read(whiteboard);
wh81=wh151(:,:,17:97); %81バンド分光イメージ(ホワイトボード)

%ダーク引き算
dk151=nh7read(dark);
dk81=dk151(:,:,17:97); %81バンド分光イメージ(入力画像)
tmpsp81=tmpsp81-dk81;
wh81=wh81-dk81;

%------debug用---------%
%   hadd=400;
%   wadd=600;
%   tmpsp81=sp151(1+hadd:128+hadd,1+wadd:128+wadd,17:97); %81バンド分光イメージ(入力画像)
%   wh81=wh151(1+hadd:128+hadd,1+wadd:128+wadd,17:97); %81バンド分光イメージ(ホワイトボード)


%高さと幅
tempsize=size(tmpsp81);
height=tempsize(1,1);
width=tempsize(1,2);

%照明光・カメラの分光感度特性の除外
sp81=zeros(height,width,81);
%ピクセルごとに割り算
sp81=tmpsp81./wh81;
sp81(sp81>1.0)=1.0;
% sp81=sp81./ 4095;
%平均値で割り算
%平均値のスペクトルの計算
% midspec=zeros(1,81);
% for i=1:81
%     midspec(1,i)=sum(sum(wh81(:,:,i)))/(height*width);
% end
% for i=1:height
%     for j=1:width
%         sp81(i,j,:)=tmpsp81(i,j)./midspec;
%     end
% end

wl81=380:5:780; %波長の配列


%光源データの読み込み(ill)、補完
%https://www.rit.edu/cos/colorscience/rc_useful_data.php  の　Full set of 1nm data, including all of the following
if illminant==1
    illname='d65';
    ill_401=csvread('d65.csv');
elseif illminant==2
    ill_401=csvread('a.csv');
elseif illminant==3
    ill_401=csvread('F1toF12.csv');
end
ill81=(ill_401(:,2))';
ill81=imresize(ill81,[1 81]);

%デジタルカメラ分光感度読み込み
rgb401=csvread('digitalcamera_d1.csv');
rgb401=rgb401(:,2:4)';
rgb81=imresize(rgb401,[3 81],'nearest');

%XYZ等色関数の読み込み、変換
%https://www.waveformlighting.com/tech/color-matching-function-x-y-z-values-by-wavelength-csv-excel-format
xyz401=csvread('xyz.csv');
xyz401=xyz401(:,2:4)';
xyz81=imresize(xyz401,[3 81],'nearest');

[grgb,g_norm]=spec2rgb(sp81,ill81,rgb81,height,width);
g_norm=gammahosei(g_norm,height,width);

%-------------------------------------------------------------------------%
[gxyz,gxyz_norm]=spec2xyz(sp81,ill81,xyz81,height,width);
 %XYZ2sRGB in d65
 %http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
 xyz2srgbmat=[ 3.2404542 -1.5371385 -0.4985314;...
             -0.9692660  1.8760108  0.0415560;...
              0.0556434 -0.2040259  1.0572252];
 %配列確保
 gxyz_srgb=zeros(height,width,3);         
 for i=1:height
          for j=1:width
             tempgxyz(1,:)=gxyz_norm(i,j,:);
             tempgxyztrans=tempgxyz';
             gxyz_srgb(i,j,:)=xyz2srgbmat*tempgxyztrans;
          end
 end
gxyz_srgb=gammahosei(gxyz_srgb,height,width);

%--------------------------------------------------------------------------%
if wiener==1
    estimatedimg=wiener_estimation(macbethsp,ill81,rgb81,grgb,height,width);
    [est_gxyz,est_gxyz_norm]=spec2xyz(estimatedimg,ill81,xyz81,height,width);
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
%     L=8;
%     k=4;
    L=32;
    k=64;
    p=0.5;
    p_estimatedimg=piecewise_wiener_estimation(ill81,rgb81,grgb,sp81,height,width,L,k,p);

    [p_est_gxyz,p_est_gxyz_norm]=spec2xyz(p_estimatedimg,ill81,xyz81,height,width);
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
% % %なんかそのままだとplotできないので
% tmp1_h=443;
% tmp1_w=690;
% tmp1(1,:)=sp81(tmp1_h,tmp1_w,:);
% tmp2(1,:)=estimatedimg(tmp1_h,tmp1_w,:);
% tmp2p(1,:)=p_estimatedimg(tmp1_h,tmp1_w,:);
% %  tmp3(1,:)=sp81(477,645,:);
% %  tmp4(1,:)=estimatedimg(477,645,:);
% %  tmp4p(1,:)=p_estimatedimg(477,645,:);
% %  tmp5(1,:)=sp81(343,728,:);
% %  tmp6(1,:)=estimatedimg(343,728,:);
% %  tmp6p(1,:)=p_estimatedimg(343,728,:);
% %  
%  figure
% %  subplot(1,3,1)
% plot(wl81,tmp1,wl81,tmp2,wl81,tmp2p)
% ylim([0 1])
% title('back')
%  subplot(1,3,2)
%  plot(wl81,tmp3,wl81,tmp4,wl81,tmp4p)
% ylim([0 1])
%  title('leaf')
%  subplot(1,3,3)
%  plot(wl81,tmp5,wl81,tmp6,wl81,tmp6p)
%  ylim([0 1])
%  title('fake')