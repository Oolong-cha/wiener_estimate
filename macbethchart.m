function macbeth=macbethchart(macbethsp,square,gap)

%マクベスチャート作製関数 引数：(csvデータ,square,gap)

macbeth=zeros(gap*5+square*4,gap*7+square*6,81);
macbethpatch=zeros(square,square,81);

for m=1:4
    for n=1:6
        for i=1:square
            for j=1:square
                  macbethpatch(i,j,:)=macbethsp(:,n+(m-1)*6+1)';  
            end
        end
        macbeth(gap+(square+gap)*(m-1)+1:gap+(square+gap)*(m-1)+1+square-1,gap+(square+gap)*(n-1)+1:gap+(square+gap)*(n-1)+1+square-1,:)=macbethpatch;
    end
end

end