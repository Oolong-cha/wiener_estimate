function [blockmat,rgb] = window_function

%�u���b�N�̒���
bpl=2;

%�z���g�͓�d���[�v��߂���
%�u���b�N�̔z��@5*5
%�u���b�N���ƂɈقȂ鐄��s�񂪊��蓖�Ă��Ă���
%���𑜓xRGB����ɂ��āA���S�ł���E���̃s�N�Z���Ɋ��蓖�Ă�
blockmat=zeros(10,10);
cnt=0;
for i=2:2:10
    for j=2:2:10
        cnt=cnt+1;
        blockmat(i,j)=cnt;
    end
end
%����̓x�N�g������Ȃ��ăX�J���[�l�����ӂ�
% for i=1:25
%     blockmat(1,i)=i;
% end
% blockmat=reshape(blockmat,5,5)';

%���Ƃ��Ƃ̍��𑜓xRGB�摜�̔z��
%���̃s�N�Z�����ƂɃu���b�N�̐���s����d�ݕt�����Ċ��蓖�Ă�
rgb=zeros(10,10);


%���֐� ����h,w���ϐ� bpl�͈�u���b�N�̒���
% W_height=0.5-0.5*cos((2*pi*h)/(2*bpl));
% W_width=0.5-0.5*cos((2*pi*w)/(2*bpl));
%d�͋����i��Βl�j
function [w_func_ans]=w_func(d,bpl)
    w_func_ans=-(1/bpl)*d+1;    
end

%�[�����͂Ƃ肠��������
%rgb��1���琔���Đ^�񒆂�5,5�̃s�N�Z���ɂ��čl����
%�Ώۂ̃s�N�Z���ɉe����^����u���b�N�̒��S���W�����߁A���������߂�
n1=5;
n2=6;
%����8�s�N�Z���{�������g��9�s�N�Z���̒��ŁA�l�������Ă�����̂��ΏۂɂȂ�
for n1=2:9
    for n2=2:9
        for height_add=-1:1
            for width_add=-1:1
               if blockmat(n1+height_add,n2+width_add)~=0 %�������̍��W�̃s�N�Z���ɒl�������Ă�����
               %�����́Aheight��width���������l�̐�Βl
                    a=blockmat(n1+height_add,n2+width_add)*w_func(abs(height_add),bpl)*w_func(abs(width_add),bpl);
                    rgb(n1,n2)=rgb(n1,n2)+a;
               end
            end
        end
    end
end

end

