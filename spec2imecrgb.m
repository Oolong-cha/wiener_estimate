% % function [gimec]=spec2imec
% function spec2imecrgb
% macbethsp=csvread('../data/macbeth.csv'); %マクベス分光反射率データ
% sp81=macbethchart(macbethsp,8,4); %分光画像作成
% tempsize=size(sp81);
% height=tempsize(1,1);
% width=tempsize(1,2);
% sp81=reshape(sp81,height*width,81); %一次元へ
% 
% 
% %光源データの読み込み(ill)、補完
% ill_401=csvread('../data/d65.csv');
% ill81=(ill_401(1:5:401,2))';
% % ill186=(ill_401(86:271,2))';
% % ill81=ill186(:,1:5:186);
% % ill81=ones(1,38).*100;
% 
% %----------------------------------------------------------------------
% %IMECカメラ分光感度読み込み
% spec=csvread('../data/imecRGB.csv');
% imecrgb81=spec(:,2:20)';
% %--------------------------------------------------------------------
% wl81=465:5:650; %波長の配列 38ch
% 
% gimec=horzcat(sum(sp81.*ill81.*imecrgb81(1,:),2),sum(sp81.*ill81.*imecrgb81(2,:),2), ...
%              sum(sp81.*ill81.*imecrgb81(3,:),2),sum(sp81.*ill81.*imecrgb81(4,:),2), ...
%              sum(sp81.*ill81.*imecrgb81(5,:),2),sum(sp81.*ill81.*imecrgb81(6,:),2), ...
%              sum(sp81.*ill81.*imecrgb81(7,:),2),sum(sp81.*ill81.*imecrgb81(8,:),2), ...
%              sum(sp81.*ill81.*imecrgb81(9,:),2),sum(sp81.*ill81.*imecrgb81(10,:),2), ...
%              sum(sp81.*ill81.*imecrgb81(11,:),2),sum(sp81.*ill81.*imecrgb81(12,:),2), ...
%              sum(sp81.*ill81.*imecrgb81(13,:),2),sum(sp81.*ill81.*imecrgb81(14,:),2), ...
%              sum(sp81.*ill81.*imecrgb81(15,:),2),sum(sp81.*ill81.*imecrgb81(16,:),2), ...
%              sum(sp81.*ill81.*imecrgb81(17,:),2),sum(sp81.*ill81.*imecrgb81(18,:),2), ...
%              sum(sp81.*ill81.*imecrgb81(19,:),2));
% 
%  %imecで得られた16バンド画像をもとに色再現（XYZ-RGB)
% 
% 
% 
% % imshow3Dfull(reshape(gimec_norm,height,width,16));
% 
% %XYZ等色関数の読み込み、変換
% %https://www.waveformlighting.com/tech/color-matching-function-x-y-z-values-by-wavelength-csv-excel-format
% xyz401=csvread('../data/xyz.csv');
% xyz81=(xyz401(1:5:401,2:4))';
% % csvwrite('Ax.csv',xyz81);
% 
% %xyzへの変換行列をもとめる
% T=xyz81.*ill81;
% H=imecrgb81.*ill81;
% A=T*H'*(H*H')^(-1);
% test=A*imecrgb81;
% % csvwrite('A.csv',test);
% 
%  gxyz=horzcat(sum(gimec.*A(1,:),2),sum(gimec.*A(2,:),2),sum(gimec.*A(3,:),2));
% 
% 
% xyz2srgbmat=[ 3.2404542 -1.5371385 -0.4985314;...
%              -0.9692660  1.8760108  0.0415560;...
%               0.0556434 -0.2040259  1.0572252];
% %XYZ値からRGB値へ         
% ref=ones(1,81);
% refilly=ref.*ill81.*test(2,:);
% refillysum=sum(refilly);
% k=1.0/refillysum;
% gimec_norm=k.*gxyz;
% gimec_norm(gimec_norm>1)=1.0;
% 
% % ref=ones(1,81); %全ての反射率が1の分光反射率を作製
% % refillg=ref.*ill81.*test(2,:);
% % refillgsum=sum(refillg);
% % k=1.0/refillgsum;
% % gimec_norm=k.*gxyz;
% % gimec_norm(gimec_norm>1)=1.0;
% % 
% %      refillr=ref.*ill81.*test(1,:);
% %      refillrsum=sum(refillr);
% %      refillb=ref.*ill81.*test(3,:);
% %      refillbsum=sum(refillb);
% %      
% %      refillrsumnom=refillrsum.*k;
% %      refillbsumnom=refillbsum.*k;
% %      refillgsumnom=refillgsum/refillgsum;
% %      
% %      refill=[refillrsumnom;refillgsumnom;refillbsumnom];
% %      gain=[refill(2,1)/refill(1,1) ...
% %          1.0 ...
% %          refill(2,1)/refill(3,1)];
% %      
% %      gimec_norm=gimec_norm.*gain;
% % 
% % 
% 
% 
% gxyz_srgb=(xyz2srgbmat*gimec_norm')';
% % test1=reshape(gxyz_srgb,height,width,3);
% % 
% % R=test1(43,6,1);
% % G=test1(43,6,2);
% % B=test1(43,6,3);
% %  gxyz_srgb(:,1)=gxyz_srgb(:,1)./R;
% %  gxyz_srgb(:,2)=gxyz_srgb(:,2)./G;
% %  gxyz_srgb(:,3)=gxyz_srgb(:,3)./B;
% %------------------
% 
% %-------------------
% imshow(reshape(gxyz_srgb,height,width,3)*1.5);
% 
% end
% 
% 
function [gimec,gimec_norm]=spec2imecrgb(sp81,ill81,imec81)

gimec=horzcat(sum(sp81.*ill81.*imec81(1,:),2),sum(sp81.*ill81.*imec81(2,:),2), ...
             sum(sp81.*ill81.*imec81(3,:),2),sum(sp81.*ill81.*imec81(4,:),2), ...
             sum(sp81.*ill81.*imec81(5,:),2),sum(sp81.*ill81.*imec81(6,:),2), ...
             sum(sp81.*ill81.*imec81(7,:),2),sum(sp81.*ill81.*imec81(8,:),2), ...
             sum(sp81.*ill81.*imec81(9,:),2),sum(sp81.*ill81.*imec81(10,:),2), ...
             sum(sp81.*ill81.*imec81(11,:),2),sum(sp81.*ill81.*imec81(12,:),2), ...
             sum(sp81.*ill81.*imec81(13,:),2),sum(sp81.*ill81.*imec81(14,:),2), ...
             sum(sp81.*ill81.*imec81(15,:),2),sum(sp81.*ill81.*imec81(16,:),2), ...
             sum(sp81.*ill81.*imec81(17,:),2),sum(sp81.*ill81.*imec81(18,:),2), ...
             sum(sp81.*ill81.*imec81(19,:),2));
gimec_norm=gimec;
% 正規化？？？？
% %XYZ値からRGB値へ         
% ref=ones(1,81);
% refilly=ref.*ill81.*test(2,:);
% refillysum=sum(refilly);
% k=1.0/refillysum;
% gimec_norm=k.*gxyz;
% gimec_norm(gimec_norm>1)=1.0;
% 
% % ref=ones(1,81); %全ての反射率が1の分光反射率を作製
% refillg=ref.*ill81.*test(2,:);
% refillgsum=sum(refillg);
% k=1.0/refillgsum;
% gimec_norm=k.*gxyz;
% gimec_norm(gimec_norm>1)=1.0;


end
