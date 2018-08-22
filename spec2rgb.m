function [grgb,grgb_norm]=spec2rgb(sp81,ill81,rgb81,height,width)
%����:�������˗��A�Ɩ����A�������x����(rgb�j,height,width

%�Ɩ����ƕ������x�̐�
g=zeros(height*width,81);
g=sp81.*ill81;

%�z��m��
grgb=horzcat(sum(g.*rgb81(1,:),2),sum(g.*rgb81(2,:),2),sum(g.*rgb81(3,:),2));


%�P�x���K��
ref=ones(1,81); %�S�Ă̔��˗���1�̕������˗����쐻
refillg=ref.*ill81.*rgb81(2,:);
refillgsum=sum(refillg);
k=1.0/refillgsum;
grgb_norm=k.*grgb;
grgb_norm(grgb_norm>1)=1.0;

     refillr=ref.*ill81.*rgb81(1,:);
     refillrsum=sum(refillr);
     refillb=ref.*ill81.*rgb81(3,:);
     refillbsum=sum(refillb);
     
     refillrsumnom=refillrsum.*k;
     refillbsumnom=refillbsum.*k;
     refillgsumnom=refillgsum/refillgsum;
     
     refill=[refillrsumnom;refillgsumnom;refillbsumnom];
     gain=[refill(2,1)/refill(1,1) ...
         1.0 ...
         refill(2,1)/refill(3,1)];
     
     grgb_norm=grgb_norm.*gain

grgb=reshape(grgb,height,width,3);
grgb_norm=reshape(grgb_norm,height,width,3);



end

