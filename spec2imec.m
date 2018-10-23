function [gimec,gimec_norm]=spec2imec(sp81,ill81,imec81)

gimec=horzcat(sum(sp81.*ill81.*imec81(1,:),2),sum(sp81.*ill81.*imec81(2,:),2), ...
             sum(sp81.*ill81.*imec81(3,:),2),sum(sp81.*ill81.*imec81(4,:),2), ...
             sum(sp81.*ill81.*imec81(5,:),2),sum(sp81.*ill81.*imec81(6,:),2), ...
             sum(sp81.*ill81.*imec81(7,:),2),sum(sp81.*ill81.*imec81(8,:),2), ...
             sum(sp81.*ill81.*imec81(9,:),2),sum(sp81.*ill81.*imec81(10,:),2), ...
             sum(sp81.*ill81.*imec81(11,:),2),sum(sp81.*ill81.*imec81(12,:),2), ...
             sum(sp81.*ill81.*imec81(13,:),2),sum(sp81.*ill81.*imec81(14,:),2), ...
             sum(sp81.*ill81.*imec81(15,:),2),sum(sp81.*ill81.*imec81(16,:),2));
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


