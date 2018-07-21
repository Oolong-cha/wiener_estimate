clear all


K1=32;
K2=32;
M1=16;
M2=16;
p=0.5
k=0
m=0
K=K1*K2;


bpl=M1/K1;
k_midh=bpl/2;
k_midw=bpl/2;
k_midh_cont=k_midh;
for k1=0:K1-1
    k_midw_cont=k_midw;
    for k2=0:K2-1  
        for m1=0:M1-1
            for m2=0:M2-1
                m=m+1;
                d=sqrt((k_midh_cont-m1)^2+(k_midw_cont-m2)^2);
%                 a(m,1)=(p^d)^2;
                a(k+1,m1+1,m2+1)=d;
            end
        end
        k_midw_cont=k_midw_cont+bpl;  
        m=0;
        k=k+1;
%         A(:,k)=a(:,1)./(sum(a(:,1)));
    end
    k_midh_cont=k_midh_cont+bpl;
end
