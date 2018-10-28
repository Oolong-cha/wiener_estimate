function [grgb,grgb_norm]=spec2rgb(sp81,ill81,rgb81)
%引数:分光反射率、照明光、分光感度特性(rgb）,height,width

grgb=horzcat(sum(sp81.*ill81.*rgb81(1,:),2),sum(sp81.*ill81.*rgb81(2,:),2),sum(sp81.*ill81.*rgb81(3,:),2));

%輝度正規化
ref=ones(1,81); %全ての反射率が1の分光反射率を作製
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
     
     grgb_norm=grgb_norm.*gain;

end

