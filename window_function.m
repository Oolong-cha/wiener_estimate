function [all_est_mat] = window_function(M_estmatrix,N1,N2,bpl)
%----�ϐ�-----
%�u���b�N���ƂɊ��蓖�Ă��Ă��鐄��s��:M_estmatrix
%���𑜓xRGB�摜�̍�����:N1,N2
%1�u���b�N���Ƃ̃s�N�Z����:bpl
%rgb�摜:grgb
%�����摜:sp81
%��𑜓x�����摜�̂����s�N�Z���̈�ӂ̒���:L �Ⴆ��2�Ȃ�𑜓x�������ɂȂ�
%RGB�摜�̕����u���b�N�̈�ӂ̒���k
%�d�ݕt���֐�p

%�b��ŁARGB�̍��W�n�Ńu���b�N���S�ɐ���s�񂪊܂܂�Ă���z�������
%����s��ƍ��W�s��ŕ������烁�����ւ点��
%�u���b�N���ƂɈقȂ鐄��s�񂪊��蓖�Ă��Ă���
%���𑜓xRGB����ɂ��āA���S�ł���E���̃s�N�Z���Ɋ��蓖�Ă�
% bpl=4;
% N1=20;
% N2=20;
cnt=0;
tmp=zeros(81,3);
mid_est_mat=zeros(N1,N2,81,3)
for i=(bpl/2)+1:bpl:((N1/bpl)-1)*bpl+((bpl/2)+1)
    for j=(bpl/2)+1:bpl:((N2/bpl)-1)*bpl+((bpl/2)+1)
        cnt=cnt+1;
        tmp(:,:)=M_estmatrix(cnt,:,:);
        mid_est_mat(i,j,:,:)=tmp;
    end
end
clear tmp

%���Ƃ��Ƃ̍��𑜓xRGB�摜�̔z��
%���̃s�N�Z�����ƂɃu���b�N�̐���s����d�ݕt�����Ċ��蓖�Ă�
all_est_mat=zeros(N1,N2,81,3);


%���֐� ����h,w���ϐ� bpl�͈�u���b�N�̒���
% W_height=0.5-0.5*cos((2*pi*h)/(2*bpl));
% W_width=0.5-0.5*cos((2*pi*w)/(2*bpl));
%d�͋����i��Βl�j
function [w_func_ans]=w_func(d,bpl)
    w_func_ans=-(1/bpl)*d+1;    
end

%�[�����͂Ƃ肠��������
%�Ώۂ̃s�N�Z���ɉe����^����u���b�N�̒��S���W�����߁A���������߂�
%����8�s�N�Z���{�������g��9�s�N�Z���̒��ŁA�l�������Ă�����̂��ΏۂɂȂ�
%�摜�O�̊O���Q�Ƃ������΂�
%�[�����̏����̊֌W��A�d�݂𐳋K������
windowsize=bpl*2-1;
add_number=floor(windowsize/2);
for n1=1:N1
    for n2=1:N2
        for height_add=-add_number:add_number
            for width_add=-add_number:add_number
                if n1+height_add>0 && n2+width_add >0 && n1+height_add <= N1 && n2+width_add <= N2
                    if mid_est_mat(n1+height_add,n2+width_add)~=0 %�������̍��W�̃s�N�Z���ɒl�������Ă�����
                      %�����́Aheight��width���������l�̐�Βl
                        a=mid_est_mat(n1+height_add,n2+width_add,:,:).*w_func(abs(height_add),bpl).*w_func(abs(width_add),bpl);
                        all_est_mat(n1,n2,:,:)=all_est_mat(n1,n2,:,:)+a;
                    end
                end
            end
        end
    end
end

%�[�����̕⊮

clear mid_est_mat
end

