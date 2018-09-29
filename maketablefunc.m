function maketablefunc(N1,N2,bpl)
%----変数-----
%ブロックごとに割り当てられている推定行列:M_estmatrix
%高解像度RGB画像の高さ幅:N1,N2
%1ブロックごとのピクセル長:bpl
%rgb画像:grgb
%分光画像:sp81
%低解像度分光画像のいちピクセルの一辺の長さ:L 例えば2なら解像度が半分になる
%RGB画像の分割ブロックの一辺の長さk
%重み付け関数p

%暫定で、RGBの座標系でブロック中心にブロック番号が含まれている配列をつくる
%  bpl=4;
%  N1=8;
%  N2=8;
%中心ブロック数
tic
numberofblock=(N1/bpl)*(N2/bpl);
cnt=0;
mid_est_mat=zeros(N1,N2);
for i=(bpl/2)+1:bpl:((N1/bpl)-1)*bpl+((bpl/2)+1)
    for j=(bpl/2)+1:bpl:((N2/bpl)-1)*bpl+((bpl/2)+1)
        cnt=cnt+1;
        mid_est_mat(i,j)=cnt;
    end
end

%もともとの高解像度RGB画像の配列
%このピクセルごとにそれぞれのブロック中心の番号と、重みを記録する
all_est_mat=zeros(N1,N2,4,2);

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
    for n2=1:N2
        n=0;
%         coordinate_mat=ones(4,2);
        weight_mat=zeros(4,2);
%         est_calc_mat=zeros(4,3,81);
        for height_add=-add_number:add_number
            for width_add=-add_number:add_number
                if n1+height_add>0 && n2+width_add >0 && n1+height_add <= N1 && n2+width_add <= N2
                    if mid_est_mat(n1+height_add,n2+width_add,:,:)~=0 %もしこの座標のピクセルに値が入っていたら
                        %ブロック番号を保存
                        n=n+1;
                        weight_mat(n,1)=mid_est_mat(n1+height_add,n2+width_add,:,:);
                        %暫定重みを保存、２こめ
                        a=w_func(abs(height_add),bpl)*w_func(abs(width_add),bpl);
                        weight_mat(n,2)=a;
                   end
                end
            end
        end
        %ローカル内の捜査が終わったので
        %重みの正規化
        weight_mat(:,2)=weight_mat(:,2)./sum(weight_mat(:,2));
        all_est_mat(n1,n2,:,:)=weight_mat;
%         weight_mat
%         for local=1:
%              all_est_mat(n1,n2,local)=weight_mat(local,1);
%         end
    end
end

all_est_mat=reshape(all_est_mat,N1*N2,4,2);
% blocktmp=zeros(1,4);
% blocktmp(1,1)=1;
% blocktmp(1,2)=2;
% blocktmp(1,3)=3;
% blocktmp(1,4)=4;
% a=all_est_mat.*blocktmp;
dir='C:\Users\fumin\Documents\wiener_estimate\';
rootname = 'bpl'; % ファイル名に使用する文字列
underbar='_';
ext='.csv';
filename = [dir,num2str(N1),underbar,num2str(N2),rootname, num2str(bpl),ext]; % ファイル名の作成
csvwrite(filename,all_est_mat);
toc
clear all
end

