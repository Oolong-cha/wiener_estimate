function [gxyz,gxyz_norm]=spec2xyz(sp81,ill81,xyz81,height,width)
%マクベスの分光反射率と照明光のスペクトルの積

%配列確保
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

x81=xyz81(1,:);
y81=xyz81(2,:);
z81=xyz81(3,:);

%配列確保
gx=zeros(height,width,81);
gy=zeros(height,width,81);
gz=zeros(height,width,81);

for i=1:height
    i
    for j=1:width
        tempg2(1,:)=g(i,j,:);
        tempgx=tempg2.*x81;
        tempgy=tempg2.*y81;
        tempgz=tempg2.*z81;
        gx(i,j,:)=tempgx;
        gy(i,j,:)=tempgy;
        gz(i,j,:)=tempgz;
    end
end

clear g
clear tempg2
clear tempgx
clear tempgy
clear tempgz

clear x81
clear z81


%配列確保
gxsum=zeros(height,width);
gysum=zeros(height,width);
gzsum=zeros(height,width);

%積分
for i=1:height
    i
    for j=1:width
        gxsum(i,j)=sum(gx(i,j,:));
        gysum(i,j)=sum(gy(i,j,:));
        gzsum(i,j)=sum(gz(i,j,:));        
    end
end
%配列確保
gxyz=zeros(height,width,3);


gxyz(:,:,1)=gxsum(:,:);
gxyz(:,:,2)=gysum(:,:);
gxyz(:,:,3)=gzsum(:,:);

clear gxsum
clear gysum
clear gzsum

ref=ones(1,81);
refilly=ref.*ill81.*y81;
refillysum=sum(refilly);
k=1.0/refillysum;
gxyz_norm=k.*gxyz;
gxyz_norm(gxyz_norm>1)=1.0;
% gxyz_norm=gxyz;

end
