function pixs=deg2pix(Degree,ScreenWidth,Pwidth,Vdist)
% �ӽ�����ת��(�Ѹ���)
    Pixpercm=Pwidth/ScreenWidth;
    pixs=2*tand(Degree/2)*Vdist*Pixpercm;
    pixs=round(pixs);
end