function pixs=deg2pix(Degree,ScreenWidth,Pwidth,Vdist)
% 视角像素转换(已更新)
    Pixpercm=Pwidth/ScreenWidth;
    pixs=2*tand(Degree/2)*Vdist*Pixpercm;
    pixs=round(pixs);
end