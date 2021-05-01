function pixs=deg2pix(Degree,Inch,Pwidth,Vdist)
    ScreenWidth=Inch*2.54/sqrt(16^2+9^2)*16;
    Pixpercm=Pwidth/ScreenWidth;
    pixs=2*tand(Degree/2)*Vdist*Pixpercm;
    pixs=round(pixs);
end