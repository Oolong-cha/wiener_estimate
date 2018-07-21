function gammahosei=gammahosei(g_norm,height,width)

for i=1:height
         for j=1:width
            tempg_norm(1,:)=g_norm(i,j,:);
            for k=1:3
                if tempg_norm(1,k)>0.00313
                    gammahosei(i,j,k)=1.055.*tempg_norm(1,k)^(1/2.4)-0.055;
                else
                    gammahosei(i,j,k)=12.92.*tempg_norm(1,k);
                end
            end
         end
end
end