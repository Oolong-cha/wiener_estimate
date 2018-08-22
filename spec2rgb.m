function [grgb,grgb_norm]=spec2rgb(sp81,ill81,rgb81,height,width)
%ø:ªõ½Ë¦AÆ¾õAªõ´xÁ«(rgbj,height,width

%Æ¾õÆªõ´xÌÏ
%g=zeros(height,width,81);
g=zeros(height*width,81);

g=sp81.*ill81;


% for i=1:height
%     %i
%     for j=1:width
%         tempsp(1,:)=sp81(i,j,:);
%         tempg=tempsp.*ill81;
%         g(i,j,:)=tempg;
%     end
% end

% clear tempsp
% clear tempg

%zñmÛ
gr=zeros(height,width,81);
gg=zeros(height,width,81);
gb=zeros(height,width,81);


r81=rgb81(1,:);
g81=rgb81(2,:);
b81=rgb81(3,:);

grgb=horzcat(sum(g.*r81,2),sum(g.*g81,2),sum(g.*b81,2));

grgb=reshape(grgb,height,width,3);
% for i=1:height
%     %i
%     for j=1:width
%         tempg2(1,:)=g(i,j,:);
%         tempgr=tempg2.*r81;
%         tempgg=tempg2.*g81;
%         tempgb=tempg2.*b81;
%         gr(i,j,:)=tempgr;
%         gg(i,j,:)=tempgg;
%         gb(i,j,:)=tempgb;
%     end
% end

% 
% clear g
% clear tempr
% clear tempg
% clear tempb
% clear tempg2

% %zñmÛ
% grsum=zeros(height,width);
% ggsum=zeros(height,width);
% gbsum=zeros(height,width);
% 
% %Ïª
% for i=1:height
%     %i
%     for j=1:width
%         grsum(i,j)=sum(gr(i,j,:));
%         ggsum(i,j)=sum(gg(i,j,:));
%         gbsum(i,j)=sum(gb(i,j,:));        
%     end
% end
% 
% clear gr
% clear gg 
% clear gb
% 
% %zñmÛ
% grgb=zeros(height,width,3);
% grgb(:,:,1)=grsum(:,:);
% grgb(:,:,2)=ggsum(:,:);
% grgb(:,:,3)=gbsum(:,:);
% 
% clear grsum
% clear ggsum
% clear gbsum

%Px³K»
ref=ones(1,81); %SÄÌ½Ë¦ª1Ìªõ½Ë¦ðì»
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

