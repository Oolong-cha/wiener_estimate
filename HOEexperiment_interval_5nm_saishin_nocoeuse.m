clear all
rawfiles=dir('C:\Users\fumin\Documents\wiener_estimate\0819\*.raw');
numfiles=length(rawfiles);
mydata=cell(1,numfiles);
for k=1:numfiles
    filename=['C:\Users\fumin\Documents\wiener_estimate\0819\',rawfiles(k).name];
    mydata{k}=raw216band(filename);
    expo="PRF_200_0_2048x1024_2B_LE_FN3_FD0_FS0.raw";
    if contains(filename,expo)==0
        continue;
    end
%      if contains(filename,'omly')==0
%         continue;
%      end
%     if contains(filename,'full')==0
%         continue;
%     end

    for lamdac=525
        syori(mydata{k},expo,lamdac)
    end
end


%画像の読み込み 、スケーリング（係数）
function syori(img,expo,lamdac)
black=raw216band("C:\Users\fumin\Documents\wiener_estimate\0626\450_0_2048x1024_2B_LE_FN61_FD0_FS0.raw");
img=img-black;
save=0;
a=0.1; %ガラス透過、反射率
HOEcoe=0.23; %5HOE反射特性
% lamdac=546; %HOE中心波長
epsilon=0.001;
lamdacband=13;
displayall=1; %画像表示
displayresultonly=0;
n=16;

imecrgb=csvread('../data/imecexp.csv');
% imecrgb=csvread('../data/imecRGB.csv');

multi81=imecrgb(:,2:17)';

G=reshape(img(:,150:405,:),256*256,16); %%中心
% G=reshape(img(:,1:256,:),256*256,16);

%HOE反射特性作成
wl = [380:5:780];
h = normpdf(wl,lamdac,4);
h=(h./(max(max(h)))).*HOEcoe;
% figure
% plot(wl,h)
% xlim([500 550])
% h=csvread("C:\Users\fumin\Documents\data\HOEexperiment\hoedef_experiment.csv");
% h=h(1:5:401,2)';
HOE=zeros(65536,81);
for i=1:65536
    HOE(i,:)=h;
end


%wiener推定　相関行列作成
rrt=csvread('C:\Users\fumin\Documents\data\markov_0999.csv');
Rf=zeros(82,82);
Rf(1,1)=1;
Rf(2:82,2:82)=rrt;
C=horzcat(multi81*h',a*multi81);
    HffH=C*Rf*C';
    matsize=size(HffH);
    middle=round(matsize(1,1)/2)+1;
    Rnseed=HffH(middle,middle)*epsilon; %ノイズの正規化項目設定
    Rn=(Rnseed)*eye(matsize(1,1));
    wA=Rf*C'*inv(C*Rf*C'+Rn);

%wiener推定計算
westimated=zeros(65536,82);
for i=1:n
    westimated=westimated+G(:,i).*wA(:,i)';
end

westimated(westimated<0)=0;

%推定fe 画像表示用にuintへ
westimatedfe01=westimated(:,1);
% westimatedfe=uint8(255*westimated(:,1));

%推定be xyz表示
    westimatedbe=westimated(:,2:82);
             xyz401=csvread('../data/xyz.csv');
        xyz81=xyz401(1:5:401,2:4)';

        [beforegxyz,beforexyz_norm]=spec2xyz(westimatedbe./max(max(westimatedbe)),ones(1,81),xyz81);
        xyz2srgbmat=[ 3.2404542 -1.5371385 -0.4985314;...
                 -0.9692660  1.8520108  0.0415560;...
                  0.0556434 -0.2040259  1.0572276];
    %XYZ値からRGB値へ         
        beforexyz_norm_srgb=(xyz2srgbmat*beforexyz_norm')';
        beforeX=gammahosei(beforexyz_norm_srgb,256,256);
if displayall==1
    figure('Name','b復元結果')
    imshow(reshape(beforeX,256,256,3))

%画像の平均値・標準偏差調整
    fe_est=msadj(G(:,lamdacband)./1023,westimatedfe01);
    figure('Name',num2str(lamdac))
    imshow(reshape(fe_est,256,256));


%     
%         figure('Name',num2str(lamdac))
%     imshow(reshape(TEST2*westimatedfe01,256,256)./mean(mean(westimatedfe01)));
%         figure('Name',num2str(lamdac))
%     imshow(reshape(G(:,lamdacband),256,256));
% 
%     imshowspsingle(reshape(G,256,256,16)./1023);
%     imshowspsingle(reshape(westimatedbe./max(max(westimatedbe)),256,256,81));
%     % imshowspsingle(reshape(westimated(:,2:82),256,256,81)./max(max(westimated(:,2:82))));
elseif displayresultonly==1
%      TEST=max(G(:,lamdacband))/1023;
    TEST2=mean((G(:,lamdacband)))/1023;
        figure('Name',num2str(lamdac))
%     imshow(reshape(TEST*westimatedfe01,256,256)./max(max(westimatedfe01)));  
    imshow(reshape(TEST2*westimatedfe01,256,256)./mean(mean(westimatedfe01)));
end
if save==1
    name=[num2str(expo),'_',num2str(lamdac),'.bmp'];
    nameback=[num2str(lamdac),'a_',num2str(a),'.bmp'];
%     imwrite(reshape(TEST*westimatedfe01,256,256)./max(max(westimatedfe01)),name);
    imwrite(reshape(TEST2*westimatedfe01,256,256)./mean(mean(westimatedfe01)),name);
    imwrite(reshape(beforeX,256,256,3),nameback);
    XXX=reshape(uint8(255*G./1023),256,256,16);
imwrite(XXX(:,:,1),'test16_1.bmp');
imwrite(XXX(:,:,2),'test16_2.bmp');
imwrite(XXX(:,:,3),'test16_3.bmp');
imwrite(XXX(:,:,4),'test16_4.bmp');
imwrite(XXX(:,:,5),'test16_5.bmp');
imwrite(XXX(:,:,6),'test16_6.bmp');
imwrite(XXX(:,:,7),'test16_7.bmp');
imwrite(XXX(:,:,8),'test16_8.bmp');
imwrite(XXX(:,:,9),'test16_9.bmp');
imwrite(XXX(:,:,10),'test16_10.bmp');
imwrite(XXX(:,:,11),'test16_11.bmp');
imwrite(XXX(:,:,12),'test16_12.bmp');
imwrite(XXX(:,:,13),'test16_13.bmp');
imwrite(XXX(:,:,14),'test16_14.bmp');
imwrite(XXX(:,:,15),'test16_15.bmp');
imwrite(XXX(:,:,16),'test16_16.bmp');
end
end