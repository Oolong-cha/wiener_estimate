
for ill=1:3
    for i=5:5
        cstr = num2str(i);
        cstrill = num2str(ill);
%         filename = ['C:\Users\fumin\Documents\Ebajapan\',cstr,'-1.nh7'];
        filename='C:\Users\fumin\Documents\Ebajapan\5-1(10f,22g).nh7'
    %      [estimatedimg,p_estimatedimg]=program_realimg(filename);
     [estimatedimg,estimatedimgfrom16,estimatedimgfrom19]=program_realimg(filename,ill);
          filename1 = ['D:\spimage\markov2\w_',cstr,'-1_ill',cstrill,'_markov_fromrgb.csv'];
          filename2 = ['D:\spimage\markov2\w_',cstr,'-1_ill',cstrill,'_markov_from16.csv'];
           filename3 = ['D:\spimage\markov2\w_',cstr,'-1_ill',cstrill,'_markov_from19.csv'];
           csvwrite(filename1,estimatedimg);
          csvwrite(filename2,estimatedimgfrom16);
          csvwrite(filename3,estimatedimgfrom19);
    end
end

%piecewise、をimecでやったのもつくる？
%マルコフ


% macbethsp=csvread('../data/macbeth.csv');
% macbeth1=macbethsp(1:80,2:25);
% macbeth1_2=macbethsp(2:81,2:25);
% A=corr2(macbeth1,macbeth1_2);
% R=zeros(81,81);
% for i=1:81
%     x=ones(1,(82-i))*A^(i-1);
%     R=diag(x,(i-1))+R;
% end
% R=R+R'-eye(81,81);
% csvwrite('../data/macbeth_markov_corr.csv',R);

% v = [1 1 1 1 1];
% diag(v,2)


% % a=csvread('C:\Users\fumin\Documents\wiener_estimate\w_4-1.csv');
% % b=reshape(a,1024,1280,81);
% % imshow(b(:,:,41));
% % %   
% % a=csvread('C:\Users\fumin\Documents\data\imec_spectralsensitivity_400to1000_1nm.csv');
% % b=a(1:5:381,2:17);
% % hokanzero=zeros(4,16);
% % imec81=vertcat(hokanzero,b);
% % csvwrite('test.csv',imec81);
% % 
%  A=[1 2 3;...
%      4 5 6;...
%      7 8 9];
% % B=[1 2 3];


% a=reshape(estimatedimgfromrgb,height,width,81);
% b=reshape(p_estimatedimg,height,width,81);
% a16=reshape(estimatedimgfrom16,height,width,81);
% a19=reshape(estimatedimgfrom19,height,width,81);




%%%%%%%RMSEマップ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear all
% 
% sp81=csvread('D:\spimage\originalimage\4-1.csv'); %original img
% estimatedimgfromrgb=csvread('D:\spimage\markov\rgb\w_4-1_ill1_markov_fromrgb.csv');
% estimatedimgfrom16=csvread('D:\spimage\markov\16band\w_4-1_ill1_markov_from16.csv');
% estimatedimgfrom19=csvread('D:\spimage\markov\19band\w_4-1_ill1_markov_from19.csv');
% 
% 
% % %rmse
% %%%%%%%%%%%%%XYZ値でRMSEマップをつくる
%     ill_401=csvread('../data/d65.csv');
%      ill81=(ill_401(1:5:401,2))';
%      xyz401=csvread('../data/xyz.csv');
% xyz81=xyz401(1:5:401,2:4)';
% xyz_sp81=spec2xyz(sp81,ill81,xyz81);
% xyz_estimatedimgfromrgb=spec2xyz(estimatedimgfromrgb,ill81,xyz81);
% xyz_estimatedimgfrom16=spec2xyz(estimatedimgfrom16,ill81,xyz81);
% xyz_estimatedimgfrom19=spec2xyz(estimatedimgfrom19,ill81,xyz81);
% 
% % estimatedimgfromrgb
% % rmse_maprgb=sqrt(sum((estimatedimgfromrgb-sp81).^2,2)./81);
% % % rmse_mapp_estimatedimg=sqrt(sum((p_estimatedimg-sp81).^2,2)./81);
% % rmse_mapestimatedimgfrom16=sqrt(sum((estimatedimgfrom16-sp81).^2,2)./81);
% % rmse_mapestimatedimgfrom19=sqrt(sum((estimatedimgfrom19-sp81).^2,2)./81);
% 
% rmse_maprgb=sqrt(sum((xyz_estimatedimgfromrgb-xyz_sp81).^2,2)./3);
% % rmse_mapp_estimatedimg=sqrt(sum((p_estimatedimg-sp81).^2,2)./81);
% rmse_mapestimatedimgfrom16=sqrt(sum((xyz_estimatedimgfrom16-xyz_sp81).^2,2)./3);
% rmse_mapestimatedimgfrom19=sqrt(sum((xyz_estimatedimgfrom19-xyz_sp81).^2,2)./3);
% 
% 
% 
% height=1024;
% width=1280;
% max(rmse_maprgb)
% figure
% subplot(2,2,1)
%  imagesc(reshape(rmse_maprgb,height,width),[0,250]);
%  title('fromrgb')
%  colorbar;
%   subplot(2,2,2)
%  imagesc(reshape(rmse_mapestimatedimgfrom16,height,width),[0,250]);
%  title('from16')
%  colorbar;
%   subplot(2,2,3)
%  imagesc(reshape(rmse_mapestimatedimgfrom19,height,width),[0,250]);
%  title('from19')
%  colorbar;
% 
% 
% 

