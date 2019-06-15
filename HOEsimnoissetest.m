% function HOEsim
clear all

imgnum=5; %background 3fliwer 4cloth 5plush
noise=0;%�m�C�Y�̗L��
ill=2; %�Ɩ���
n=16; %�J�����o���h��
a=0.8; %�K���X���߁A���˗�
HOEcoe=0.9; %HOE���˓���
lamdac=530; %HOE���S�g��
save=0; %�摜�ۑ�
disp=1; %�摜�\��

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if noise==1
    SNR=30;
    noisename=['noise_snr',num2str(SNR)];
    else
    noisename=[''];
end
if ill==1
    illname=['D65'];
elseif ill==2
    illname=['A'];
elseif ill==3
    illname=['F7'];
end
if n==8
    lamdacband=4;    
elseif n==16
    lamdacband=13;
end
bandname=[num2str(n),'band'];
spimgname=[num2str(imgnum),'-1smooth.bin'];
if n==3
    rgb401=csvread('../data/BaumerRGB_B1.csv');
    multi81=rgb401(:,2:4)';    
elseif n==8
    multi401=csvread('C:\Users\fumin\Documents\data\gauss8.csv');
    multi81=multi401(1:5:401,2:9)';
elseif n==81
    multi81=csvread('../data/ideal81.csv');
    multi81=multi81(:,2:82)';
elseif n==16
    imecrgb=csvread('../data/imecRGB.csv');
    multi81=imecrgb(:,2:17)';
end

%�摜�̓ǂݍ��� 
f=imread('C:\Users\fumin\Documents\data\BARBARA.bmp');  %f uint8
f=(double(f))/255; %f��double��
f=reshape(f,65536,1); %f�ꎟ����
spimg=binread256(spimgname,0); %b double
b=reshape(spimg,65536,81); %b�ꎟ����

%�Ɩ���%%%%%%%%%%%%%%%
if ill==1
    ill_401=csvread('../data/d65.csv');
elseif ill==2
    ill_401=csvread('../data/a.csv');
elseif ill==3
    ill_401=csvread('../data/f7.csv');
end
    ill81=(ill_401(1:5:401,2))';
    ill81=ill81/max(ill81);
    be=b.*ill81;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%HOE���˓����쐬
wl = [380:5:780];
h = normpdf(wl,lamdac,5);
h=(h./(max(max(h)))).*HOEcoe;
HOE=zeros(65536,81);
for i=1:65536
    HOE(i,:)=h;
end


%G�쐬
fe=f.*ill81(1,41);
sp81=fe.*HOE+a.*be; %�J�����ɓ��镪�����˗�

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
G=zeros(65536,n);
for i=1:n
    G(:,i)=sum(sp81.*multi81(i,:),2);
end


% test=(f.*HOE)+(a.*b);
% [grgb,grgb_norm]=spec2rgb(test,ill81,multi81);
% X=gammahosei(grgb_norm,256,256);
% figure
%  imshow(reshape(X,256,256,3));
%  
 
% %�P�x���K��
% ref=ones(1,81); %�S�Ă̔��˗���1�̕������˗����쐻
% refillg=ref.*ill81.*multi81(3,:);
% refillgsum=sum(refillg);
% k=1.0/refillgsum;
% g_norm=k.*G;
% g_norm(g_norm>1)=1.0;
% 
% refillmat=zeros(n,1);
% refillmat(3,:)=1.0;
% gain=zeros(1,n);
% gain(1,3)=1.0;
% for i=1:n
%      refill=ref.*ill81.*multi81(i,:);
%      refillsum=sum(refill);
%         refillsumnom=refillsum.*k;
%     if i==3
%         continue
%     end
%      refillmat(i,:)=refillsumnom;
%      gain(:,i)=refillmat(3,:)/refillmat(i,:);
% 
%    end  
%      g_norm=g_norm.*gain;
%      
% G=g_norm;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%
% G(G>1.0)=1;
GW=zeros(65536,n);
whitesp81=ones(65536,81);
for i=1:n
%     GW(:,i)=sum(whitesp81.*multi81(i,:).*ill81(1,:),2);
    GW(:,i)=sum(whitesp81.*multi81(i,:).*ill81(1,:),2);
end
if noise==1
%     SNR=40;    %SN��̐ݒ�@
% %     vnoise=var(G(:,:))/(10^(SNR/10));
%  vnoise=((GW).^2)/(10^(SNR/10));
%     Gnoise=zeros(65536,n);
%     for i=1:n
%         Gnoise(:,i)=imnoise(G(:,i),'gaussian',0,vnoise(1,i));
%     end
%     Gbackup=G;
%     G=Gnoise;
% end
   %SN��̐ݒ�@
    Gnoise=awgn(G,SNR,'measured');

    Gbackup=G;
    G=Gnoise;
end

% G(G>1.0)=1;

%wiener����@���֍s��쐬

rrt=csvread('C:\Users\fumin\Documents\data\macbeth_markov_corr.csv');
Rf=zeros(82,82);
Rf(1,1)=1;
Rf(2:82,2:82)=rrt;
C=horzcat(multi81*h',0.9*multi81);
if noise==1
    HffH=C*Rf*C';
    matsize=size(HffH);
    middle=round(matsize(1,1)/2)+1;
    Rnseed=HffH(middle,middle)/1000; %�m�C�Y�̐��K�����ڐݒ�
    Rn=(Rnseed)*eye(matsize(1,1));
    wA=Rf*C'*inv(C*Rf*C'+Rn);
else
    wA=Rf*C'*inv(C*Rf*C');
end
%wiener����v�Z
westimated=zeros(65536,82);
for i=1:n
    westimated=westimated+G(:,i).*wA(:,i)';
end


% imshowspsingle(reshape(G,256,256,n))
%����fe �摜�\���p��uint��
westimatedfe01=westimated(:,1);
westimatedfe=uint8(255*westimated(:,1));

%����be
westimatedbe=westimated(:,2:82);



%�]��
%f%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%G��fe�̕��ϒl�����킹�Ė��邳�����킹�鏈��
G4_corr=(G(:,lamdacband)./mean(G(:,lamdacband))).*mean(fe);
gsabun=G4_corr-fe;
% psabun=pestimated(:,1)-f;
wsabun=westimated(:,1)-fe;

gsabunmax=max(max(gsabun))
wsabunmax=max(max(wsabun))
gsabunmin=min(min(gsabun))
wsabunmin=min(min(wsabun))

% RMSEafter=sqrt((westimated(:,1)-fe).^2);

RMSEafter=sqrt(sum((westimated(:,1)-fe).^2)/(256*256))

bRMSEafter=sqrt(sum(sum((westimated(:,2:82)-be).^2,2))/81/(256*256))
% bRMSEafter=sum(sqrt(sum((westimated(:,2:82)-be).^2,2)./81))/(256*256)

if disp==1
    figure
    subplot(1,3,1);
    imshow(reshape(fe,256,256));
    subplot(1,3,2);
    imshow(reshape(G4_corr,256,256));
    subplot(1,3,3);
    imshow(reshape(westimatedfe,256,256));  
     
     %4�o���h�ڂ�fe�Ɩ��邳�����킹��G�̕\�� 8�o���h�̏ꍇ
    imshowspsingle(reshape((G./mean(G(:,lamdacband))).*mean(fe),256,256,n))

    %G4-fe�}�b�v
    figure
    imagesc(reshape(gsabun,256,256),[-1,1]);
    colorbar('Fontsize',13);
    xticks([]);
    yticks([]);
    colormap jet
    axis image
    fig1 = get(groot,'CurrentFigure');

    %Fe����-fe�}�b�v
    figure
    imagesc(reshape(wsabun,256,256),[-1,1]);
    colorbar('Fontsize',13);
    xticks([]);
    yticks([]);
    colormap jet
    axis image
    fig2 = get(groot,'CurrentFigure');
   
else
    figure('visible', 'off');
    imagesc(reshape(gsabun,256,256),[-1,1]);
    colorbar('Fontsize',13);
    xticks([]);
    yticks([]);
    colormap jet
    axis image
    fig1 = get(groot,'CurrentFigure');
    
    figure('visible', 'off');
    imagesc(reshape(wsabun,256,256),[-1,1]);
    colorbar('Fontsize',13);
    xticks([]);
    yticks([]);
    colormap jet
    axis image
    fig2 = get(groot,'CurrentFigure');


end

if save==1
    G4_corr_disp=uint8(255*G4_corr);
    fe_corr_disp=uint8(255*fe);
    savename_g = [num2str(imgnum),'_',bandname,'g_',noisename,illname,'.bmp'];
    savename_fe = [num2str(imgnum),'_',bandname,'fe_',noisename,illname,'.bmp'];
    savename_fest = [num2str(imgnum),'_',bandname,'fest_',noisename,illname,'.bmp'];
    savename_g4_fe = [num2str(imgnum),'_',bandname,'gdiff_',noisename,illname,'.bmp'];
    savename_fest_fe = [num2str(imgnum),'_',bandname,'festdiff_',noisename,illname,'.bmp'];
    imwrite(reshape(G4_corr_disp,256,256),savename_g);
    imwrite(reshape(fe_corr_disp,256,256),savename_fe);
    imwrite(reshape(westimatedfe,256,256),savename_fest);
    saveas(fig1,savename_g4_fe);
    saveas(fig2,savename_fest_fe);
end

%b%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% imshowsp2(reshape(westimatedbe,256,256,81),reshape(be,256,256,81));
% imshowsp2(reshape(Gbackup,256,256,8),reshape(Gnoise,256,256,8));
% imshowsp3(reshape(pestimatedb,256,256,81),reshape(be,256,256,81),reshape(G,256,256,8),'est','b','G');

% wlab=labdeltaE(b,westimatedb,2000);
% ggg=labdeltaE(b,G,2000);


%��ܔ����Ƃ��� 102,94 �摜�����傭�@�΂̂ʂ̂ł�����Ă݂�

% figure
% 
%      imagesc(reshape(plab,256,256),[0,1]);
%      title('fromrgb')
%       colorbar;
%      xticks([]);
%      yticks([]);
%      figure
% 
%      imagesc(reshape(wlab,256,256),[0,1]);
%      title('fromrgb')
%       colorbar;
%      xticks([]);
%      yticks([]);
%      
%      figure
%           imagesc(reshape(ggg,256,256),[0,1]);
%      title('fromrgb')
%       colorbar;
%      xticks([]);
%      yticks([]);

%b �F���ł̕]��

% figure
% imagesc(reshape(Gnoise(:,1)-Gbackup(:,1),256,256),[0,0.001]);
% colorbar;
% xticks([]);
% yticks([]);
% colormap jet

% end


