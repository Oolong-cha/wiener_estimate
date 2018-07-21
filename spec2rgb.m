function [grgb,grgb_norm]=spec2rgb(sp81,ill81,rgb81,height,width)
%引数:分光反射率、照明光、分光感度特性(rgb）,height,width

%照明光と分光感度の積
g=zeros(height,width,81);


for i=1:height
    i
    for j=1:width
        tempsp(1,:)=sp81(i,j,:);
        tempg=tempsp.*ill81;
        g(i,j,:)=tempg;
    end
end

clear tempsp
clear tempg

%配列確保
gr=zeros(height,width,81);
gg=zeros(height,width,81);
gb=zeros(height,width,81);


r81=rgb81(1,:);
g81=rgb81(2,:);
b81=rgb81(3,:);

for i=1:height
    i
    for j=1:width
        tempg2(1,:)=g(i,j,:);
        tempgr=tempg2.*r81;
        tempgg=tempg2.*g81;
        tempgb=tempg2.*b81;
        gr(i,j,:)=tempgr;
        gg(i,j,:)=tempgg;
        gb(i,j,:)=tempgb;
    end
end


clear g
clear tempr
clear tempg
clear tempb
clear tempg2

% %配列確保
grsum=zeros(height,width);
ggsum=zeros(height,width);
gbsum=zeros(height,width);

%積分
for i=1:height
    i
    for j=1:width
        grsum(i,j)=sum(gr(i,j,:));
        ggsum(i,j)=sum(gg(i,j,:));
        gbsum(i,j)=sum(gb(i,j,:));        
    end
end

clear gr
clear gg 
clear gb

%配列確保
grgb=zeros(height,width,3);
grgb(:,:,1)=grsum(:,:);
grgb(:,:,2)=ggsum(:,:);
grgb(:,:,3)=gbsum(:,:);

clear grsum
clear ggsum
clear gbsum

%輝度正規化
ref=ones(1,81); %全ての反射率が1の分光反射率を作製
refillg=ref.*ill81.*g81;
refillgsum=sum(refillg);
k=1.0/refillgsum;
grgb_norm=k.*grgb;
grgb_norm(grgb_norm>1)=1.0;

     refillr=ref.*ill81.*r81;
     refillrsum=sum(refillr);
     refillb=ref.*ill81.*b81;
     refillbsum=sum(refillb);
     
     refillrsumnom=refillrsum.*k;
     refillbsumnom=refillbsum.*k;
     refillgsumnom=refillgsum/refillgsum;
     
     refill=[refillrsumnom;refillgsumnom;refillbsumnom];
     gain=[refill(2,1)/refill(1,1) ...
         1.0 ...
         refill(2,1)/refill(3,1)];
     for i=1:height
         for j=1:width
             tempgsrgb(1,:)=grgb_norm(i,j,:);
             grgb_norm(i,j,:)=gain.*tempgsrgb(1,:);
         end
     end
     
clear r81
clear g81
clear b81
end

