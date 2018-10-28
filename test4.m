for k=1:5
    count = num2str(k);
    height=1024;
    width=1280;
    filename = ['D:\spimage\ebajapan\',count,'-1.nh7'];
    whiteboard=['D:\spimage\ebajapan\white1(10f,22g).nh7'];
    dark=['D:\spimage\ebajapan\dark1(10f,22g).nh7'];
    sp151=nh7read(filename);
    tmpsp81=sp151(:,:,7:87); %81バンド分光イメージ(入力画像)
    wh151=nh7read(whiteboard);
    wh81=wh151(:,:,7:87); %81バンド分光イメージ(ホワイトボード)
    dk151=nh7read(dark);
    dk81=dk151(:,:,7:87);
     tmpsp81=tmpsp81-dk81;
     wh81=wh81-dk81;
    tmpsp81=reshape(tmpsp81,height*width,81);
    sp81=zeros(height*width,81);
    tmpwh81=reshape(wh81,height*width,81);
    whmid=sum(tmpwh81)./(height*width);
    sp81=tmpsp81./whmid;
    sp81(sp81>1.0)=1.0;
    sp81=sp81*4095;
    savename = ['D:\spimage\ebajapan\',count,'-1.bin'];
     binwrite(savename,sp81);
 end

clear all
for ill=1:3
    for i=1:5
        cstr = num2str(i);
        cstrill = num2str(ill);
        filename = ['D:\spimage\ebajapan\',cstr,'-1.bin'];
        sp81=binread(filename,0);
     [estimatedimg,estimatedimgfrom16,estimatedimgfrom19]=program_realimg(sp81,ill);
          filename1 = ['D:\spimage\markov2\w_',cstr,'-1_ill',cstrill,'_markov_fromrgb.bin'];
          filename2 = ['D:\spimage\markov2\w_',cstr,'-1_ill',cstrill,'_markov_from16.bin'];
           filename3 = ['D:\spimage\markov2\w_',cstr,'-1_ill',cstrill,'_markov_from19.bin'];
           binwrite(filename1,estimatedimg);
          binwrite(filename2,estimatedimgfrom16);
          binwrite(filename3,estimatedimgfrom19);
    end
end
beep
% A=[1 2 3 ; 4 5 6 ; 7 8 9];
% % fileID = fopen('test.bin','w');
% %  fwrite(fileID,A,'double')
% %  fclose(fileID)
%  data=fopen('test.bin','r');
%  tmp=fread(data,[3,3],'double');
%  fclose(data)