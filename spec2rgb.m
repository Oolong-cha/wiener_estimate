function [grgb,grgb_norm]=spec2rgb(sp81,ill81,rgb81)
%ø:ªõ½Ë¦AÆ¾õAªõ´xÁ«(rgbj,height,width

grgb=horzcat(sum(sp81.*ill81.*rgb81(1,:),2),sum(sp81.*ill81.*rgb81(2,:),2),sum(sp81.*ill81.*rgb81(3,:),2));

%Px³K»
ref=ones(1,81); %SÄÌ½Ë¦ª1Ìªõ½Ë¦ðì»
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

