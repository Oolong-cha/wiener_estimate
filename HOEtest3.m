clear all
 img=imread('C:\Users\fumin\Documents\data\BARBARA.bmp');
 spimg=imgsyukusyou;
 
% figure
% imshow(img);
f=zeros(65536,81);
imggray=(double(img))/255;

imggray=reshape(imggray,65536,1);
% %500nm
% f(:,25)=imggray;

%500nm
% for x=24:26
%     f(:,x)=imggray; 
% end

f=imggray;

% imshowspsingle(reshape(f,256,256,81));
% imshowspsingle(reshape(f,256,256,81));
wl = [380:5:780];
h = normpdf(wl,500,5);
h=(h./(max(max(h)))).*0.8;
% h=zeros(1,81);
% h(1,25)=0.8;
HOE=zeros(65536,81);
for i=1:65536
    HOE(i,:)=h;
end
FH=(f.*HOE);
imshowspsingle(reshape(FH,256,256,81));
imshowspsingle(reshape(HOE,256,256,81));


%b’Ç‰Á “§‰ß—¦
a=0.9;
b=reshape(spimg,65536,81);
G=FH+a.*b;
G(G>1.0)=1;
% imshowspsingle(reshape(G,256,256,81));


%G‚ÉƒmƒCƒY’Ç‰Á-------------------
% Gnoise=zeros(65536,81);
% for n=1:81
%    Gnoise(:,n)=imnoise(G(:,n));
% end
% 
% G=Gnoise;

%------------------------------
%markov‚æ‚Ý‚±‚Ý
rrt=csvread('C:\Users\fumin\Documents\data\macbeth_markov_corr.csv');
Rf=zeros(82,82);
Rf(1,1)=1;
Rf(2:82,2:82)=rrt;
C=horzcat(h',0.9*eye(81));

%noise----------------------
% HffH=C*Rf*C';
% matsize=size(HffH);
% 
% middle=round(matsize(1,1)/2)+1;
% Rnseed=HffH(middle,middle)/10;
% Rn=(Rnseed)*eye(matsize(1,1));
% A=Rf*C'*inv(C*Rf*C'+Rn);

%-----------------------
A=Rf*C'*inv(C*Rf*C');

kotae=zeros(65536,82);


for i=1:81
    kotae=kotae+G(:,i).*A(:,i)';
end

%ŒvŽZ‚³‚ê‚½f
kotae1=uint8(255*kotae(:,1));
%ŒvŽZ‚³‚ê‚½background
kotae2=kotae(:,2:82);
kotae2(kotae2<0)=0;
figure
imshow(reshape(kotae1,256,256,1));
imshowspsingle(reshape(kotae2,256,256,81));


kotaetest=reshape(kotae(:,1),256,256,1);
G=reshape(G,256,256,81);
testimg=G(:,:,25);
groundf=reshape(imggray,256,256);


RMSEbefore=sqrt((testimg-groundf).^2);
RMSEafter=sqrt((kotaetest-groundf).^2);

%‚½‚¾‚Ìˆø‚«ŽZ
sabunbefore=testimg-groundf;
sabunafter=kotaetest-groundf;

max(max(sabunbefore))
max(max(sabunafter))
min(min(sabunbefore))
min(min(sabunafter))

sum(sum(RMSEbefore))/(256*256)
sum(sum(RMSEafter))/(256*256)

kotae2=reshape(kotae2,256,256,81);
bRMSEbefore=sqrt(sum((G-spimg).^2,3)./81);
bRMSEafter=sqrt(sum((kotae2-spimg).^2,3)./81);
sum(sum(bRMSEbefore))/(256*256)
sum(sum(bRMSEafter))/(256*256)

% figure
% imagesc(RMSEbefore,[0,1]);
% colorbar;
% xticks([]);
% yticks([]);
% colormap jet
% 
% figure
% imagesc(RMSEafter,[0,1]);
% colorbar;
% xticks([]);
% yticks([]);
% colormap jet

figure
imagesc(sabunbefore,[-1,1]);
colorbar;
xticks([]);
yticks([]);
colormap jet

figure
imagesc(sabunafter,[-1,1]);
colorbar;
xticks([]);
yticks([]);
colormap jet

kotae2=reshape(kotae2,256,256,81);
% imshowsp2(reshape(b,256,256,81),kotae2);
imshowsp2(kotae2,reshape(b,256,256,81));

bRMSEbefore=sqrt(sum((G-spimg).^2,3)./81);
bRMSEafter=sqrt(sum((kotae2-spimg).^2,3)./81);
sum(sum(bRMSEbefore))/(256*256)
sum(sum(bRMSEafter))/(256*256)
