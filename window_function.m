function [all_est_mat] = window_function(M_estmatrix,N1,N2,bpl)
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
tmp=zeros(81,3);
mid_est_mat=zeros(N1,N2,81,3);
for i=(bpl/2)+1:bpl:((N1/bpl)-1)*bpl+((bpl/2)+1)
    for j=(bpl/2)+1:bpl:((N2/bpl)-1)*bpl+((bpl/2)+1)
        cnt=cnt+1;
        tmp(:,:)=M_estmatrix(cnt,:,:);
        mid_est_mat(i,j,:,:)=tmp;
    end
end
clear tmp

%もともとの高解像度RGB画像の配列
%このピクセルごとにブロックの推定行列を重み付けして割り当てる
all_est_mat=zeros(N1,N2,81,3);

%窓関数 距離h,wが変数 bplは一ブロックの長さ
% W_height=0.5-0.5*cos((2*pi*h)/(2*bpl));
% W_width=0.5-0.5*cos((2*pi*w)/(2*bpl));
%dは距離（絶対値）
function [w_func_ans]=w_func(d,bpl)
%     w_func_ans=-(1/bpl)*d+1; 
    w_func_ans=0.5+0.5*cos((pi*d)/(bpl)); 
end

%端っこはとりあえず無視
%対象のピクセルに影響を与えるブロックの中心座標を求め、距離を求める
%自分を中心としたwindowsize*windowsizeのマドの中に、値が入っているものが対象になる
%画像外の外を参照したら飛ばす
%端っこの処理の関係上、重みを正規化する
windowsize=bpl*2-1;
add_number=floor(windowsize/2);

for n1=1:N1
    n1
    for n2=1:N2
        n=0;
        coordinate_mat=ones(4,2);
        weight_mat=zeros(4,1);
%         est_calc_mat=zeros(4,3,81);
        for height_add=-add_number:add_number
            for width_add=-add_number:add_number
                if n1+height_add>0 && n2+width_add >0 && n1+height_add <= N1 && n2+width_add <= N2
                    if mid_est_mat(n1+height_add,n2+width_add,:,:)~=0 %もしこの座標のピクセルに値が入っていたら
                        %座標を保存
                        n=n+1;
                        coordinate_mat(n,1)=n1+height_add;
                        coordinate_mat(n,2)=n2+width_add;
                        %暫定重みを保存
                        a=w_func(abs(height_add),bpl)*w_func(abs(width_add),bpl);
                        weight_mat(n,1)=a;
                        %距離は、heightもwidthも足した値の絶対値
%                         a=mid_est_mat(n1+height_add,n2+width_add,:,:).*w_func(abs(height_add),bpl).*w_func(abs(width_add),bpl);
%                         all_est_mat(n1,n2,:,:)=all_est_mat(n1,n2,:,:)+a;
                    end
                end
            end
        end
        %ローカル内の捜査が終わったので
        %重みの正規化
        weight_mat=weight_mat./sum(weight_mat);
%         weight_mat
        for local=1:4
             all_est_mat(n1,n2,:,:)=mid_est_mat(coordinate_mat(local,1),coordinate_mat(local,2),:,:).*weight_mat(local,1)+all_est_mat(n1,n2,:,:);
        end
    end
end

%端っこの補完

clear mid_est_mat
end

