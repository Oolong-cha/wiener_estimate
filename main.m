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

sp81=reshape(sp81,height*width,81); %一次元へ

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

%imec分光感度読み込み
imecrgb=csvread('../data/imecRGB.csv');
imec81=imecrgb(:,2:17)';

%imecrgb分光感度読み込み
imecrgb=csvread('../data/imecRGB.csv');
imecrgb81=imecrgb(:,2:20)';

%XYZ等色関数の読み込み、変換
%https://www.waveformlighting.com/tech/color-matching-function-x-y-z-values-by-wavelength-csv-excel-format
xyz401=csvread('../data/xyz.csv');
xyz401=xyz401(:,2:4)';
xyz81=imresize(xyz401,[3 81],'nearest');


%分光画像から、与えられた照明光スペクトルとデジタルカメラの分光感度を用いてRGB画像を生成
[grgb,g_norm]=spec2rgb(sp81,ill81,rgb81);

%分光画像から、与えられた照明光スペクトルとimecの分光感度を用いて16バンド画像を生成
[gimec,gimec_norm]=spec2imec(sp81,ill81,imec81);

%分光画像から、与えられた照明光スペクトルとimec+RGBの分光感度を用いて19バンド画像を生成
[gimecrgb,gimergbc_norm]=spec2imecrgb(sp81,ill81,imecrgb81);

%分光画像から、与えられた照明光スペクトルとXYZ値を用いてXYZ画像を生成
[gxyz,gxyz_norm]=spec2xyz(sp81,ill81,xyz81);

%XYZ2sRGB in d65
%http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
xyz2srgbmat=[ 3.2404542 -1.5371385 -0.4985314;...
             -0.9692660  1.8760108  0.0415560;...
              0.0556434 -0.2040259  1.0572252];
%XYZ値からRGB値へ         
gxyz_srgb=(xyz2srgbmat*gxyz_norm')';

if wiener==1
    estimatedimgfromrgb=wiener_estimationmulti(macbethsp,ill81,rgb81,grgb,height,width); %wiener推定rgb
    estimatedimgfrom16=wiener_estimationmulti(macbethsp,ill81,imec81,gimec,height,width); %wiener推定16
    estimatedimgfrom19=wiener_estimationmulti(macbethsp,ill81,imecrgb81,gimecrgb,height,width); %wiener推定19
    [est_gxyz,est_gxyz_norm]=spec2xyz(estimatedimgfromrgb,ill81,xyz81); %推定により得られた分光画像よりXYZ画像を生成
    est_gxyz_srgb=(xyz2srgbmat*est_gxyz_norm')'; %XYZ画像からｓRGB画像へ
end
 
if piecewisewiener==1
    L=4;
    k=4;
    p_estimatedimg=piecewise_wiener_estimation(ill81,rgb81,grgb,sp81,height,width,L,k);
    [p_est_gxyz,p_est_gxyz_norm]=spec2xyz(p_estimatedimg,ill81,xyz81);
    p_est_gxyz_srgb=(xyz2srgbmat*p_est_gxyz_norm')'; %XYZ画像からｓRGB画像へ
end

g_norm=gammahosei(g_norm,height,width);
gxyz_srgb=gammahosei(gxyz_srgb,height,width);
est_gxyz_srgb=gammahosei(est_gxyz_srgb,height,width);  
p_est_gxyz_srgb=gammahosei(p_est_gxyz_srgb,height,width);

%///
g_norm=reshape(g_norm,height,width,3);
gxyz_srgb=reshape(gxyz_srgb,height,width,3);
est_gxyz_srgb=reshape(est_gxyz_srgb,height,width,3);
p_est_gxyz_srgb=reshape(p_est_gxyz_srgb,height,width,3);
%///

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
%   imwrite(uint8(g_norm.*255),'3digital3band.bmp');
%    imwrite(uint8(gxyz_srgb.*255),'3xyz.bmp');
%    imwrite(uint8(est_gxyz_srgb.*255),'3est_xyz.bmp');
%    imwrite(uint8(p_est_gxyz_srgb.*255),'3p_est_xyz.bmp');

x=reshape(sp81,height,width,81);
a=reshape(estimatedimgfromrgb,height,width,81);
b=reshape(p_estimatedimg,height,width,81);
a16=reshape(estimatedimgfrom16,height,width,81);
a19=reshape(estimatedimgfrom19,height,width,81);

figure
cnt=1;
for i=0:3
    for j=0:5
        tmp1(1,:)=x(5+i*12,5+j*12,:);
        tmp2(1,:)=a(5+i*12,5+j*12,:);
        tmp2p(1,:)=b(5+i*12,5+j*12,:);
        tmp2_16(1,:)=a16(5+i*12,5+j*12,:);
        tmp2_19(1,:)=a19(5+i*12,5+j*12,:);
        ylim([0 1])
        xlim([380 780])
        subplot(4,6,cnt)
        plot(wl81,tmp1,wl81,tmp2,wl81,tmp2p,wl81,tmp2_16,wl81,tmp2_19)
        cnt=cnt+1;
    end
end
legend('f','fromrgb','p','from16','from19')

a=reshape(estimatedimgfromrgb,height,width,81);
b=reshape(p_estimatedimg,height,width,81);
a16=reshape(estimatedimgfrom16,height,width,81);
a19=reshape(estimatedimgfrom19,height,width,81);

%rmse
rmse_maprgb=sqrt(sum((estimatedimgfromrgb-sp81).^2,2)./81);
rmse_mapp_estimatedimg=sqrt(sum((p_estimatedimg-sp81).^2,2)./81);
rmse_mapestimatedimgfrom16=sqrt(sum((estimatedimgfrom16-sp81).^2,2)./81);
rmse_mapestimatedimgfrom19=sqrt(sum((estimatedimgfrom19-sp81).^2,2)./81);

% if max(rmse_maprgb)>max(rmse_mapp_estimatedimg)
%     maxn=max(rmse_maprgb);
% else
%     maxn=max(rmse_mapp_estimatedimg);
% end

figure
subplot(2,2,1)
 imagesc(reshape(rmse_maprgb,height,width),[0,0.2]);
 title('fromrgb')
 colorbar;
 subplot(2,2,2)
 imagesc(reshape(rmse_mapp_estimatedimg,height,width),[0,0.2]);
  title('piece')
 colorbar;
  subplot(2,2,3)
 imagesc(reshape(rmse_mapestimatedimgfrom16,height,width),[0,0.2]);
 title('from16')
 colorbar;
  subplot(2,2,4)
 imagesc(reshape(rmse_mapestimatedimgfrom19,height,width),[0,0.2]);
 title('from19')
 colorbar;
