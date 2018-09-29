function [estimatedspecimg]=piecewise_wiener_estimation(ill81,rgb81,grgb,sp81,height,width,L,k)

%----�ϐ�-----
%�Ɩ����������x:ill81
%�f�W�^���J�����������x:rgb81
%rgb�摜:grgb
%�����摜:sp81
%��𑜓x�����摜�̂����s�N�Z���̈�ӂ̒���:L �Ⴆ��2�Ȃ�𑜓x�������ɂȂ�
%RGB�摜�̕����u���b�N�̈�ӂ̒���k

N1=height;
N2=width;

%��𑜓x�����摜�̍쐬
M1=N1/L;
M2=N2/L;
M=M1*M2; %�����摜��f��
low_sp81=zeros(M1,M2,81);
R=zeros(81,M);
m=0;
m1=0;
m2=0;
for i=1:L:N1
    m1=m1+1;
    for j=1:L:N2
        m=m+1;
        m2=m2+1;
        low_sp81(m1,m2,:)=sum(sum(sp81(i:i+(L-1),j:j+(L-1),:)))./(L*L);
        R(:,m)=low_sp81(m1,m2,:);
        R(:,m)=R(:,m)';
    end
    m2=0;
end

% imshow3Dfull(low_sp81);
%lowsp81�͕����摜�@R�͈ꎟ���̔z��@�Ă�����rehape�ł�����񂶂�Ȃ��H
clear low_sp81
%RGB�摜��K�u���b�N�ɕ������� k����u���b�N�̃s�N�Z����
K1=N1/k;
K2=N2/k;
K=K1*K2; %�u���b�N��

%����s��̍쐬
%�d�݂Â��s���v�f�Ɏ��s��̍쐬
A=zeros(M,K);
a=zeros(M,1);
k_cont=0;
m=0;

%�d�ݕt���֐�p
bpl_rgb_block=N1/K1;
p=nthroot(0.1,bpl_rgb_block);
p
%block_pixels_low
bpl_sp_block=M1/K1;
k_midh=bpl_sp_block/2;
k_midw=bpl_sp_block/2;
k_midh_cont=k_midh;
for k1=0:K1-1
    k_midw_cont=k_midw;
    for k2=0:K2-1  
        for m1=0:M1-1
            for m2=0:M2-1
                m=m+1;
                d=sqrt((k_midh_cont-m1)^2+(k_midw_cont-m2)^2);
                a(m,1)=(p^d)^2;
            end
        end
        k_midw_cont=k_midw_cont+bpl_sp_block;  
        m=0;
        k_cont=k_cont+1;
        A(:,k_cont)=a(:,1)./(sum(a(:,1)));
    end
    k_midh_cont=k_midh_cont+bpl_sp_block;
end

clear a

%estimation matrix�����
C=zeros(K,81,81);
for i=1:K
    %i
   C(i,:,:)=R*diag(A(:,i))*R'; 
end

for i=1:3
    S=rgb81(i,:);
    for j=1:81
        H(i,j)=S(1,j).*ill81(1,j);
    end
end

M_estmatrix=zeros(K,81,3);
tempC=zeros(81,81);
for i=1:K
    tempC(:,:)=C(i,:,:);
    M_estmatrix(i,:,:)=tempC*H'*inv(H*tempC*H');
end


%window function
% all_est_mat=window_function(M_estmatrix,N1,N2,bpl_rgb_block);
% 
% estimatedspecimg=zeros(height,width,81);
% for i=1:height
%     for j=1:width
%         vtemp=grgb(i,j,:);
%         esttmp=all_est_mat(i,j,:,:);
%         v(:,1)=vtemp;
%         est(:,:)=esttmp;
%         r_est=est*v;
%         r_est(r_est>1)=1;
%         estimatedspecimg(i,j,:)=r_est;
%     end
% end

%csv�ł��
dir='C:\Users\fumin\Documents\wiener_estimate\';
rootname = 'bpl'; % �t�@�C�����Ɏg�p���镶����
underbar='_';
ext='.csv';
filename = [dir,num2str(N1),underbar,num2str(N2),rootname, num2str(bpl_rgb_block),ext]; 
all_coor_weight=csvread(filename); %*8�łł�
all_coor_weight=reshape(all_coor_weight,N1*N2,4,2);
estimatedspecimg=zeros(height*width,81);
for n=1:N1*N2
    for local=1:4
        if all_coor_weight(n,local,1)~=0
            tmp(:,:)=M_estmatrix(all_coor_weight(n,local,1),:,:);
            tmp2=all_coor_weight(n,local,2);
            estimatedspecimg(n,:)=sum(tmp.*tmp2.*grgb(n,:),2)'+estimatedspecimg(n,:); %�����Z�I�Ō�̍��Y���ƍŌ�̒l�ɂȂ����Ⴄ
    end
end

% n=1;
% 
% for i=1:height
%     tempn=n;
%     %n=����s��ԍ�
%     i
%     for j=1:width
%         vtemp=grgb(i,j,:);
%         esttmp=M_estmatrix(n,:,:);
%         v(:,1)=vtemp;
%         est(:,:)=esttmp;
%         r_est=est*v;
%         r_est(r_est>1)=1;
%         estimatedspecimg(i,j,:)=r_est;
%         if mod(j,k)==0
%             n=n+1;
%         end
%     end
%     if mod(i,k)==0
% %         n=n+1;
%     else
%         n=tempn;
%     end
% end

end