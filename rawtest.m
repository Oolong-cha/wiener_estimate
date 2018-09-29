clear all
%function rawimg=rawtest(filename)
 data=fopen('D:\20180928\450_0_2048x1024_2B_LE_FN1146_FD0_FS0.raw','r');
%  wdata=fopen('D:\0910\white_20_test_BIL_ref_spe\0\white_ref.raw','r');
%  ddata=fopen('D:\0910\white_20_test_BIL_ref_spe\0\dark_ref_object.raw','r');
%  d2data=fopen('D:\0910\white_20_test_BIL_ref_spe\0\dark_ref_white.raw','r');
 raw10bit = fread(data,2048*1024*16,'uint16');
%  wraw10bit = fread(wdata,2048*1024*16,'uint16');
%  draw10bit = fread(ddata,2048*1024*16,'uint16');
%  d2raw10bit = fread(d2data,2048*1024*16,'uint16');
%  raw10bit=(raw10bit-draw10bit)./(wraw10bit-d2raw10bit);
%  a=511/max(raw10bit);
%  raw10bit=a*raw10bit;
%  min(raw10bit)
%   test=fopen('D:\0910\white_20_test_BIL_ref_spe_0.raw','r');
%    test10bit=fread(test,2048*1024*16,'uint16');
%  min(test10bit)
%  min(raw10bit)
%   max(rawnorm)
 % max(raw10bit)

%  for i=1:2048*1024
%      if rawnorm(i)>0.00313
%         rawnorm(i)=1.055.*rawnorm(i)^(1/2.4)-0.055;
%      else
%         rawnorm(i)=12.92.*rawnorm(i);
%      end
%  end
 

%   max(rawnorm)
  rawnorm=reshape(raw10bit,2048,1024)';
  %isoutlier(single(rawnorm(500:550,1000:1050)))
%   mean2(rawnorm(500:550,1000:1050))
% min(reshape(rawnorm(501:550,971:1020),1,2500))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  rawnorm=rawnorm./1023; %ガンマ補正のため正規化して最大値を1へ
%   rawnorm=rawnorm.*255; %
%    rawnorm=uint8(rawnorm);
  sample=rawnorm(501:580,951:1030);
  band1=sample(1:4:80,3:4:80);
  band2=sample(1:4:80,4:4:80);
  band3=sample(1:4:80,1:4:80);
  band4=sample(1:4:80,2:4:80);
  band5=sample(2:4:80,3:4:80);
  band6=sample(2:4:80,4:4:80);
  band7=sample(2:4:80,1:4:80);
  band8=sample(2:4:80,2:4:80);
  band9=sample(3:4:80,3:4:80);
  band10=sample(3:4:80,4:4:80);
  band11=sample(3:4:80,1:4:80);
  band12=sample(3:4:80,2:4:80);
  band13=sample(4:4:80,3:4:80);
  band14=sample(4:4:80,4:4:80);
  band15=sample(4:4:80,1:4:80);
  band16=sample(4:4:80,2:4:80);
  mean=zeros(1,16);
  mean(1,1)=mean2(band1);
  mean(1,2)=mean2(band2);
  mean(1,3)=mean2(band3);
  mean(1,4)=mean2(band4);
  mean(1,5)=mean2(band5);
  mean(1,6)=mean2(band6);
  mean(1,7)=mean2(band7);
  mean(1,8)=mean2(band8);
  mean(1,9)=mean2(band9);
  mean(1,10)=mean2(band10);
  mean(1,11)=mean2(band11);
  mean(1,12)=mean2(band12);
  mean(1,13)=mean2(band13);
  mean(1,14)=mean2(band14);
  mean(1,15)=mean2(band15);
  mean(1,16)=mean2(band16);
  csvwrite('C:\Users\fumin\Documents\大学\分光感度測定\450mean.csv',mean)

fclose(data);
%'D:\mono\480L_toggle_0_2048x1024_2B_LE_FN255_FD0_FS0.raw' toggleしたraw
%'D:\mono\480_0_2048x1024_2B_LE_FN235_FD0_FS0.raw'         toggleしてないraw
  
%'D:\mono\480_BILL_toggle_0.raw'  toggleしたBILの外部保存raw
%'D:\mono\480_BILL_toggle\0\dark_ref_object.raw' 
%'D:\mono\480_BILL_toggle\0\dark_ref_white.raw'  
%'D:\mono\480_BILL_toggle\0\input.raw'  

%'D:\0910\white_over_test_0_2048x1024_2B_LE_FN25_FD0_FS0.raw'
%'D:\0910\white_optimal_test_0_2048x1024_2B_LE_FN181_FD0_FS0.raw'
%'D:\0910\white_optimal_test_ref_0_2048x1024_2B_LE_FN146_FD0_FS0.raw'
%'D:\white_20_test_ref_spe_0_2048x1024_2B_LE_FN584_FD0_FS0.raw'
%'D:\0910\white_20_test_0_2048x1024_2B_LE_FN415_FD0_FS0.raw'
%'D:\0910\white_20_test_ref_spe_0_2048x1024_2B_LE_FN584_FD0_FS0.raw'
%'D:\0910\white_10_test_0_2048x1024_2B_LE_FN339_FD0_FS0.raw'
%'D:\0910\white_10_test_ref_spe_0_2048x1024_2B_LE_FN366_FD0_FS0.raw'
%'D:\0910\white_50_test_0_2048x1024_2B_LE_FN760_FD0_FS0.raw'
%'D:\0910\white_optimal_test_0_2048x1024_2B_LE_FN181_FD0_FS0.raw
%'D:\0910\white_50_test_ref_spe_0_2048x1024_2B_LE_FN746_FD0_FS0.raw'
%製品仕様には10bit ファイル名は2B=16bit 最大値は511(9bit?かと思われたが、他のはそれ以上の値になっていた.でも大体そのあたり付近)
%toggleじゃないやつは真っ白になる　BILは複数出る？
%togglwBILデータにはdarkのrawデータが存在する