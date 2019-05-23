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

%幅を持ったf
% for x=24:26
%     f(:,x)=imggray; 
% end
f=imggray;
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
% imshowspsingle(reshape(FH,256,256,81));
% imshowspsingle(reshape(HOE,256,256,81));



%バックグラウンドマクベス

% macbethsp=csvread('C:\Users\fumin\Documents\data\macbeth.csv');
% macbeth=macbethchart(macbethsp,50,5);
% FH=reshape(FH,512,512,81);
% G=FH;
% for i=100:324
%     for j=50:384
%         G(i,j,:)=FH(i,j,:)+0.9*macbeth(i-99,j-49,:);
%     end
% end
% %???
% G(G>1.0)=1.0;
% imshowspsingle(G);
% 
% G=reshape(G,262144,81);

%b追加 透過率
a=0.9;
b=reshape(spimg,65536,81);
G=FH+a.*b;
G(G>1.0)=1;
imshowspsingle(reshape(G,256,256,81));

%g=Axの形にする、
kotae=zeros(65536,82);
kotaebefore=zeros(65536,82);
A=horzcat(h',0.9*eye(81));
for k=1:65536    
    kotaebefore(k,:)=pinv(A)*G(k,:)';
end
% A=pinv(A);
% % for k=1:81  
% %     kotae=kotae+G(:,k).*A(:,k)';
% % end

kotae=kotaebefore;
kotae(kotae<0)=0;


kotae1=uint8(255*kotae(:,1));

kotae2=kotae(:,2:82);
figure
imshow(reshape(kotae1,256,256,1));
imshowspsingle(reshape(kotae2,256,256,81));
kotaetest=reshape(kotae(:,1),256,256,1);
G=reshape(G,256,256,81);
testimg=G(:,:,25);
groundf=reshape(imggray,256,256);


RMSEbefore=sqrt((testimg-groundf).^2);
RMSEafter=sqrt((kotaetest-groundf).^2);

%ただの引き算
sabunbefore=testimg-groundf;
sabunafter=kotaetest-groundf;

max(max(sabunbefore))
max(max(sabunafter))
min(min(sabunbefore))
min(min(sabunafter))

sum(sum(RMSEbefore))/(256*256)
sum(sum(RMSEafter))/(256*256)
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


% 
% kotaetest=reshape(kotae(:,1),256,256,1);
% G=reshape(G,256,256,81);
% testimg=G(:,:,25);
% f=reshape(f,256,256,81);
% f=f(:,:,25);
% 
% 
% RMSEbefore=sqrt((testimg-f).^2);
% RMSEafter=sqrt((kotaetest-f).^2);
% 
% %ただの引き算
% sabunbefore=testimg-f;
% sabunafter=kotaetest-f;
% 
% % figure
% % imagesc(RMSEbefore,[0,1]);
% % colorbar;
% % xticks([]);
% % yticks([]);
% % colormap jet
% % 
% % figure
% % imagesc(RMSEafter,[0,1]);
% % colorbar;
% % xticks([]);
% % yticks([]);
% % colormap jet
% 
% figure
% imagesc(sabunbefore,[-1,1]);
% colorbar;
% xticks([]);
% yticks([]);
% colormap gray
% 
% figure
% imagesc(sabunafter,[-1,1]);
% colorbar;
% xticks([]);
% yticks([]);
% colormap gray
% 
% kotae2=reshape(kotae2,256,256,81);
% % imshowsp2(reshape(b,256,256,81),kotae2);
% imshowsp2(kotae2,reshape(b,256,256,81));
% X(1,:)=kotae2(189,192,:);
% Y=macbethsp(:,10)';
% 
% figure
% plot(wl,X,wl,Y);
% 
% % A=horzcat(h,eye(81));
% % ans=pinv(A)*g;
% % figure;
% % plot(wl,ans(2:82,1)')
% % ylim([0 1]);
% % xlim([380 780]);
% % 
% % ANS
% % ans(1,1)
% 
% 
% % 
% % %HOEの反射率特性h(λ)　81次元(380nm~780nm 5nm間隔）中心波長480nm
% % wl = [380:5:780];
% % h = normpdf(wl,480,2);
% % figure;
% % plot(wl,4*h)
% % ylim([0 1]);
% % xlim([380 780]);
% % 
% % 
% % h=h';
% % 
% % %被写体のある座標x,yにあるピクセルのf(λ) テストとしてマクベス1番
% % macbethsp=csvread('../data/macbeth.csv');
% % f=macbethsp(:,15)';
% % figure;
% % plot(wl,f)
% % ylim([0 1]);
% % xlim([380 780]);
% % 
% % f=f';
% % 
% % %分離したい背景b(λ) テストとしてマクベス3番（水色）
% % b=macbethsp(:,4)';
% % figure;
% % plot(wl,b)
% % ylim([0 1]);
% % xlim([380 780]);
% % 
% % b=b';
% % 
% % %h(λ)とf（λ)の積
% % figure;
% % plot(wl,f.*h)
% % ylim([0 1]);
% % xlim([380 780]);
% % 
% % 
% % %取得した画像g(λ) 81次元、分光感度は全部均一に1のハイパースペクトルかめらと仮定
% % SEKI=f.*h;
% % g=(SEKI)+b;
% % figure;
% % plot(wl,g)
% % ylim([0 1]);
% % xlim([380 780]);
% % ANS=f(21,1);
% % 
% % %g=Axの形にする、
% % A=horzcat(h,eye(81));
% % ans=pinv(A)*g;
% % figure;
% % plot(wl,ans(2:82,1)')
% % ylim([0 1]);
% % xlim([380 780]);
% % 
% % ANS
% % ans(1,1)