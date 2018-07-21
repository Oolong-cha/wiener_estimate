
illminant=input('Please select the spectral image(1-3)\n\n<1>D65\n<2>A\n<3>F1\n<4>An object at rest\n<5>Portrait\n<6>Fruits\n<7>Bottle\n<8>Wool\n>>>');
wiener=input('wiener estimate?(0-1)\n\n<0>no\n<1>yes\n');

WHITEBALANCE=0;
%macbethsp=csvread('macbeth.csv'); %マクベス分光反射率データ
sp151=nh7read('sample.nh7');
sp81=sp151(:,:,17:197);
macbethsp=csvread('macbeth.csv');
%sp81=macbethchart(macbethsp,10,5); %分光画像作成
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
     ill81=csvread('nakamaillmination.csv');
%    ill_401=csvread('d65.csv');

elseif illminant==2
    ill_401=csvread('a.csv');
elseif illminant==3
    ill_401=csvread('F1toF12.csv');
end
%  ill81=(ill_401(:,2))';
%  ill81=imresize(ill81,[1 81]);


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
[gxyz,gxyz_norm]=spec2xyz(sp81,ill81,xyz81,height,width);

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

%WB
if WHITEBALANCE==1
    refillx=ref.*ill81.*x81;
    refillxsum=sum(refillx);
    refillz=ref.*ill81.*z81;
    refillzsum=sum(refillz);
    refillxsumnom=refillxsum.*k;
    refillzsumnom=refillzsum.*k;
    refillysumnom=refillysum/refillysum;
    refillxyz2srgb=xyz2srgbmat*[refillxsumnom;refillysumnom;refillzsumnom];
    gain=[refillxyz2srgb(2,1)/refillxyz2srgb(1,1) ...
        1.0 ...
        refillxyz2srgb(2,1)/refillxyz2srgb(3,1)];
    for i=1:height
        for j=1:width
            tempgsrgb(1,:)=grgb(i,j,:);
            grgb(i,j,:)=gain.*tempgsrgb(1,:);
        end
    end
end


g_norm=gammahosei(g_norm,height,width);
gxyz_srgb=gammahosei(gxyz_srgb,height,width);


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
 
 figure
 subplot(2,3,1);
 imshow(uint8(g_norm.*255));
title('rgb');
  subplot(2,3,2);
  imshow(uint8(gxyz_srgb.*255));
title('xyz');
  subplot(2,3,3);
  imshow(uint8(est_gxyz_srgb.*255));
title('estimation');
subplot(2,3,4);
plotsp(1,:)=sp81(424,780,:);
plotest(1,:)=estimatedimg(424,780,:);
plot(wl81,plotsp,wl81,plotest(1,:));
 ylim([0 1]);
 subplot(2,3,5);
 plotsp1(1,:)=sp81(580,866,:);
plotest1(1,:)=estimatedimg(580,866,:);
plot(wl81,plotsp1,wl81,plotest1(1,:));
 ylim([0 1]);
  subplot(2,3,6);
  plotsp2(1,:)=sp81(198,215,:);
plotest2(1,:)=estimatedimg(198,215,:);
plot(wl81,plotsp2,wl81,plotest2(1,:));
 ylim([0 1]);
%     imwrite(uint8(g_norm.*255),'leaf_dsc.bmp');
%     imwrite(uint8(gxyz_srgb.*255),'leaf_xyz.bmp');
%  imwrite(uint8(est_gxyz_srgb.*255),'leaf_xyz_estimation.bmp');
%  figure
%  subplot(2,3,1);
%  imshow(uint8(g_norm.*255));
% title('rgb');
%   subplot(2,3,2);
%   imshow(uint8(gxyz_srgb.*255));
% title('xyz');
%   subplot(2,3,3);
%   imshow(uint8(est_gxyz_srgb.*255));
% title('estimation');
% subplot(2,3,4);
% plotsp(1,:)=sp81(649,743,:);
% plotest(1,:)=estimatedimg(649,743,:);
% plot(wl81,plotsp,wl81,plotest(1,:));
%  ylim([0 1]);
%  subplot(2,3,5);
%  plotsp1(1,:)=sp81(441,694,:);
% plotest1(1,:)=estimatedimg(441,694,:);
% plot(wl81,plotsp1,wl81,plotest1(1,:));
%  ylim([0 1]);
%   subplot(2,3,6);
%   plotsp2(1,:)=sp81(198,215,:);
% plotest2(1,:)=estimatedimg(198,215,:);
% plot(wl81,plotsp2,wl81,plotest2(1,:));
%  ylim([0 1]);
