function [estimatedimg,estimatedimgfrom16,estimatedimgfrom19]=program_realimg(sp81,illminant)
% function program_realimg
% clear all
height=1024;
width=1280;
% 
% imgname=input('Which image?(0-1)\n\n<0>Leaf\n<1>Flower\n');
% illminant=input('Please select the spectral image(1-3)\n\n<1>D65\n<2>A\n<3>F1\n<4>An object at rest\n<5>Portrait\n<6>Fruits\n<7>Bottle\n<8>Wool\n>>>');
%  wiener=input('wiener estimate?(0-1)\n\n<0>no\n<1>yes\n');
% piecewisewiener=input('p-wiener estimate?(0-1)\n\n<0>no\n<1>yes\n');
% imgname=1;
%  illminant=1;
wiener=1;
piecewisewiener=0;
% WHITEBALANCE=input('white balance?(0-1)\n\n<0>no\n<1>yes\n');

macbethsp=csvread('../data/macbeth.csv'); %マクベス分光反射率データ
% 
% if imgname==0
%     imgname='../Ebajapan\sample.nh7';
%     whiteboard='white.nh7';
%     dark='';
% else 
%     imgname='../Ebajapan\1-1.nh7';
% %      whiteboard='C:\Users\fumin\Documents\Ebajapan\白板\可視光増強(露光時間長)\white1(3f,70g).nh7';
%      whiteboard='C:\Users\fumin\Documents\Ebajapan\白板\近赤外非飽和(露光時間短)\white1(10f,22g).nh7';
% %      dark='C:\Users\fumin\Documents\Ebajapan\ダーク\可視光増強(露光時間長)\dark1(3f,70g).nh7';
%     dark=' C:\Users\fumin\Documents\Ebajapan\ダーク\近赤外非飽和(露光時間短)\dark1(10f,22g).nh7';
% end
% whiteboard='C:\Users\fumin\Documents\Ebajapan\白板\近赤外非飽和(露光時間短)\white1(10f,22g).nh7';
% dark=' C:\Users\fumin\Documents\Ebajapan\ダーク\近赤外非飽和(露光時間短)\dark1(10f,22g).nh7';
% sp151=nh7read(imgname);
% tmpsp81=sp151(:,:,7:87); %81バンド分光イメージ(入力画像)
% wh151=nh7read(whiteboard);
% wh81=wh151(:,:,7:87); %81バンド分光イメージ(ホワイトボード)
% 
% %ダーク引き算
% dk151=nh7read(dark);
% dk81=dk151(:,:,7:87); %81バンド分光イメージ(入力画像)
%  tmpsp81=tmpsp81-dk81;
%   wh81=wh81-dk81;
% 
% %------debug用---------%
% %      hadd=400;
% %      wadd=600;
% %      tmpsp81=sp151(1+hadd:128+hadd,1+wadd:128+wadd,17:97); %81バンド分光イメージ(入力画像)
% %      wh81=wh151(1+hadd:128+hadd,1+wadd:128+wadd,17:97); %81バンド分光イメージ(ホワイトボード)
% % % % 
% 
% %高さと幅
% tempsize=size(tmpsp81);
% height=tempsize(1,1);
% width=tempsize(1,2);
% 
% 
% %照明光・カメラの分光感度特性の除外
% 
% %ピクセルごとに割り算
% % sp81=tmpsp81./wh81;
% % sp81(sp81>1.0)=1.0;
% % sp81=reshape(sp81,height*width,81); %一次元へ
% 
% %平均値で割り算
% %平均値のスペクトルの計算
% tmpsp81=reshape(tmpsp81,height*width,81);
% sp81=zeros(height*width,81);
% tmpwh81=reshape(wh81,height*width,81);
% whmid=sum(tmpwh81)./(height*width);
% sp81=tmpsp81./whmid;


wl81=380:5:780; %波長の配列

% 
% 光源データの読み込み(ill)、補完
% https://www.rit.edu/cos/colorscience/rc_useful_data.php  の　Full set of 1nm data, including all of the following
if illminant==1
    illname='d65';
    ill_401=csvread('../data/d65.csv');
     ill81=(ill_401(1:5:401,2))';
elseif illminant==2
    ill_401=csvread('../data/a.csv');
     ill81=(ill_401(1:5:401,2))';
elseif illminant==3
    ill_401=csvread('../data/F1toF12.csv'); %F11
    ill81=(ill_401(:,12))';
end


%デジタルカメラ分光感度読み込み
rgb401=csvread('../data/BaumerRGB_B1.csv');
rgb81=rgb401(:,2:4)';

%XYZ等色関数の読み込み、変換
%https://www.waveformlighting.com/tech/color-matching-function-x-y-z-values-by-wavelength-csv-excel-format
xyz401=csvread('../data/xyz.csv');
xyz81=xyz401(1:5:401,2:4)';

%imec分光感度読み込み
imecrgb=csvread('../data/imecRGB.csv');
imec81=imecrgb(:,2:17)';

%imecrgb分光感度読み込み
imecrgb=csvread('../data/imecRGB.csv');
imecrgb81=imecrgb(:,2:20)';

%-------------------------------------------------------------------------------------------------------
%分光画像から、与えられた照明光スペクトルとデジタルカメラの分光感度を用いてRGB画像を生成
 [grgb,g_norm]=spec2rgb(sp81,ill81,rgb81);

%分光画像から、与えられた照明光スペクトルとXYZ値を用いてXYZ画像を生成
[gxyz,gxyz_norm]=spec2xyz(sp81,ill81,xyz81);

%分光画像から、与えられた照明光スペクトルとimecの分光感度を用いて16バンド画像を生成
[gimec,gimec_norm]=spec2imec(sp81,ill81,imec81);

%分光画像から、与えられた照明光スペクトルとimec+RGBの分光感度を用いて19バンド画像を生成
[gimecrgb,gimergbc_norm]=spec2imecrgb(sp81,ill81,imecrgb81);

%XYZ2sRGB in d65
%http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
xyz2srgbmat=[ 3.2404542 -1.5371385 -0.4985314;...
             -0.9692660  1.8760108  0.0415560;...
              0.0556434 -0.2040259  1.0572252];
%XYZ値からRGB値へ         
% gxyz_srgb=(xyz2srgbmat*gxyz_norm')';

if wiener==1
     estimatedimg=wiener_estimationmulti(macbethsp,ill81,rgb81,grgb,height,width); %wiener推定
    estimatedimgfrom16=wiener_estimationmulti(macbethsp,ill81,imec81,gimec,height,width); %wiener推定16
    estimatedimgfrom19=wiener_estimationmulti(macbethsp,ill81,imecrgb81,gimecrgb,height,width); %wiener推定19
     %     [est_gxyz,est_gxyz_norm]=spec2xyz(estimatedimg,ill81,xyz81); %推定により得られた分光画像よりXYZ画像を生成
%     est_gxyz_srgb=(xyz2srgbmat*est_gxyz_norm')'; %XYZ画像からｓRGB画像へ
end
 tic
if piecewisewiener==1
    L=16; %分光画像の、RGB画像に対する1ピクセルの一辺
    k=16; %RGB画像に対する1ブロックの一辺の長さ
    p_estimatedimg=piecewise_wiener_estimation(ill81,rgb81,grgb,sp81,height,width,L,k);
%     [p_est_gxyz,p_est_gxyz_norm]=spec2xyz(p_estimatedimg,ill81,xyz81);
%     p_est_gxyz_srgb=(xyz2srgbmat*p_est_gxyz_norm')'; %XYZ画像からｓRGB画像へ
end
toc
% 
% g_norm=gammahosei(g_norm,height,width);
% gxyz_srgb=gammahosei(gxyz_srgb,height,width);
% est_gxyz_srgb=gammahosei(est_gxyz_srgb,height,width);  
% % p_est_gxyz_srgb=gammahosei(p_est_gxyz_srgb,height,width);
% % 
% %///
% g_norm=reshape(g_norm,height,width,3);
% gxyz_srgb=reshape(gxyz_srgb,height,width,3);
% est_gxyz_srgb=reshape(est_gxyz_srgb,height,width,3);
% p_est_gxyz_srgb=reshape(p_est_gxyz_srgb,height,width,3);
%///

%    imwrite(uint8(g_norm.*255),'3digital3band.bmp');
%     imwrite(uint8(gxyz_srgb.*255),'3xyz.bmp');
%     imwrite(uint8(est_gxyz_srgb.*255),'3est_xyz.bmp');
%     imwrite(uint8(p_est_gxyz_srgb.*255),'3p_est_xyz.bmp');
%     csvwrite('wiener.csv',estimatedimg);
%     csvwrite('pwiener.csv',p_estimatedimg);
    
%  figure
%  subplot(2,2,1)
%  imshow(uint8(g_norm.*255))
% title('rgb')
%   subplot(2,2,2)
%   imshow(uint8(gxyz_srgb.*255))
% title('xyz')
%    subplot(2,2,3)
%    imshow(uint8(est_gxyz_srgb.*255))
%  title('wiener')
%   subplot(2,2,4)
%   imshow(uint8(p_est_gxyz_srgb.*255))
% title('p-wiener')


%-------------------------------------------------------------------------------------------------------

%---------------------------------------------%
% if piecewisewiener==1
%      figure
%      subplot(2,2,1)
%      imshow(uint8(g_norm.*255))
%     title('rgb')
%       subplot(2,2,2)
%       imshow(uint8(gxyz_srgb.*255))
%     title('xyz')
%        subplot(2,2,3)
%        imshow(uint8(est_gxyz_srgb.*255))
%      title('wiener')
%       subplot(2,2,4)
%       imshow(uint8(p_est_gxyz_srgb.*255))
%     title('p-wiener')
% else 
%      figure
%      subplot(1,3,1)
%      imshow(uint8(g_norm.*255))
%     title('rgb')
%       subplot(1,3,2)
%       imshow(uint8(gxyz_srgb.*255))
%     title('xyz')
%       subplot(1,3,3)
%       imshow(uint8(est_gxyz_srgb.*255))
%     title('wiener')
% end

% [gyou,retu,ta]=size(sp81);
% figure
% imagesc(reshape(spimg_RMSE(sp81,estimatedimg),gyou,retu),[0,0.13]);
% colorbar;
% figure
% imagesc(reshape(spimg_RMSE(sp81,p_estimatedimg),gyou,retu),[0,0.13]);
% colorbar;

% figure
% imagesc(reshape(spimg_RMSE(sp81,p_estimatedimg2),gyou,retu),[0,0.13]);
% colorbar;
% 
% A=reshape(spimg_RMSE(sp81,estimatedimg),gyou,retu);
% B=reshape(spimg_RMSE(sp81,p_estimatedimg),gyou,retu);
% C=sqrt((A-B).^2);
% figure
% imagesc(C,[0,0.13]);
% colorbar;



% % %なんかそのままだとplotできないので
%  tmp1_h=27;
%  tmp1_w=103;
%  tmp1(1,:)=sp81(tmp1_h,tmp1_w,:);
% %  tmp2(1,:)=estimatedimg(tmp1_h,tmp1_w,:);
%  tmp2p(1,:)=p_estimatedimg(tmp1_h,tmp1_w,:);
%  tmp2p_w(1,:)=p_estimatedimg2(tmp1_h,tmp1_w,:);
%  %  tmp3(1,:)=sp81(477,645,:);
%  %  tmp4(1,:)=estimatedimg(477,645,:);
%  %  tmp4p(1,:)=p_estimatedimg(477,645,:);
%  %  tmp5(1,:)=sp81(343,728,:);
% % %  tmp6(1,:)=estimatedimg(343,728,:);
% % %  tmp6p(1,:)=p_estimatedimg(343,728,:);
% % %  
%   figure
% % %  subplot(1,3,1)
% %  plot(wl81,tmp1,wl81,tmp2,wl81,tmp2p,wl81,tmp2p_w)
%  plot(wl81,tmp1,wl81,tmp2p)
% % ylim([0 1])
% % title('back')
% %  subplot(1,3,2)
% %  plot(wl81,tmp3,wl81,tmp4,wl81,tmp4p)
% % ylim([0 1])
% %  title('leaf')
% %  subplot(1,3,3)
% %  plot(wl81,tmp5,wl81,tmp6,wl81,tmp6p)
% %  ylim([0 1])
% %  title('fake')