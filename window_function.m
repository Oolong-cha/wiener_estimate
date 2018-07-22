function [blockmat,rgb] = window_function
% window_function(M_estmatrix,N1,N2,bpl)
%----変数-----
%ブロックごとに割り当てられている推定行列:M_estmatrix
%高解像度RGB画像の高さ幅:N1,N2
%1ブロックごとのピクセル長:bpl
%rgb画像:grgb
%分光画像:sp81
%低解像度分光画像のいちピクセルの一辺の長さ:L 例えば2なら解像度が半分になる
%RGB画像の分割ブロックの一辺の長さk
%重み付け関数p

%暫定で、RGBの座標系でブロック中心に推定行列が含まれている配列をつくる
%推定行列と座標行列で分けたらメモリへらせる
%ブロックごとに異なる推定行列が割り当てられている
%高解像度RGBを基準にして、中心である右下のピクセルに割り当てる
% bpl=4;
% N1=20;
% N2=20;
cnt=0;
blockmat=zeros(N1,N2)
for i=(bpl/2)+1:bpl:((N1/bpl)-1)*bpl+((bpl/2)+1)
    for j=(bpl/2)+1:bpl:((N2/bpl)-1)*bpl+((bpl/2)+1)
        cnt=cnt+1;
        blockmat(i,j)=M_estmatrix(cnt,:,:);
    end
end


%ホントは二重ループやめたい
%ブロックの配列　5*5
%ブロックごとに異なる推定行列が割り当てられている
%高解像度RGBを基準にして、中心である右下のピクセルに割り当てる
% blockmat=zeros(10,10);
% cnt=0;
% for i=2:2:10
%     for j=2:2:10
%         cnt=cnt+1;
%         blockmat(i,j)=cnt;
%     end
% end
%今回はベクトルじゃなくてスカラー値をわりふる
% for i=1:25
%     blockmat(1,i)=i;
% end
% blockmat=reshape(blockmat,5,5)';

%もともとの高解像度RGB画像の配列
%このピクセルごとにブロックの推定行列を重み付けして割り当てる
rgb=zeros(10,10);


%窓関数 距離h,wが変数 bplは一ブロックの長さ
% W_height=0.5-0.5*cos((2*pi*h)/(2*bpl));
% W_width=0.5-0.5*cos((2*pi*w)/(2*bpl));
%dは距離（絶対値）
function [w_func_ans]=w_func(d,bpl)
    w_func_ans=-(1/bpl)*d+1;    
end

%端っこはとりあえず無視
%rgbで1から数えて真ん中の5,5のピクセルについて考える
%対象のピクセルに影響を与えるブロックの中心座標を求め、距離を求める
n1=5;
n2=6;
%周囲8ピクセル＋自分自身の9ピクセルの中で、値が入っているものが対象になる
for n1=2:9
    for n2=2:9
        for height_add=-1:1
            for width_add=-1:1
               if blockmat(n1+height_add,n2+width_add)~=0 %もしこの座標のピクセルに値が入っていたら
               %距離は、heightもwidthも足した値の絶対値
                    a=blockmat(n1+height_add,n2+width_add)*w_func(abs(height_add),bpl)*w_func(abs(width_add),bpl);
                    rgb(n1,n2)=rgb(n1,n2)+a;
               end
            end
        end
    end
end

end

