function brwread
clear all
% 
% data=fopen('D:\20181009\4700003no.brw','r');
% raw10bit = fread(data,'uint8');
% raw10bit(1,1);
% %  raw10bit=raw10bit(1:2304000,:);
%   raw10bit=raw10bit(54:2304053,:);
% rawnorm=reshape(raw10bit,1920,1200)';
%   rawnorm=rawnorm./1023; %ƒKƒ“ƒ}•â³‚Ì‚½‚ß³‹K‰»‚µ‚ÄÅ‘å’l‚ğ1‚Ö
%    rawnorm=rawnorm.*255; %
%     rawnorm=uint8(rawnorm);
mean=zeros(81,3);

for i=1:98
    cstr = num2str([i].','%02d');
    filename = ['D:\20181012\img00',cstr,'.tif'];
    image=imread(filename);
    sample=image(650:739,950:1039);
    R=sample(2:2:80,2:2:80);
    B=sample(1:2:80,1:2:80);
    G=horzcat(sample(2:2:80,1:2:80),sample(1:2:80,2:2:80));
    mean(i,1)=mean2(R);
    mean(i,2)=mean2(G);
    mean(i,3)=mean2(B);
end
  
  
  csvwrite('C:\Users\fumin\Documents\‘åŠw\Baumer\rgbspectralsensotovoty1.csv',mean)

% figure
% imshow(R);
% figure
% imshow(B);
% figure
% imshow(G);
% A=[1 2 3 4; 5 6 7 8; 9 10 11 12;13 14 15 16]
% A(2:2:4,1:2:4)
% A(1:2:4,2:2:4)
end