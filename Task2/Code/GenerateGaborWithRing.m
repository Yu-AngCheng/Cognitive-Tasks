function pic = GenerateGaborWithRing(ScreenCondition,SpatialFrequency,TargetorNonTarget,LeftorRight)
% 生成带环带缺口的Gabor刺激
% 参数包括：
%   ScreenConditon: 结构体, 内含关于显示器设备的所有基础信息以及部分牵涉到显示器像素转换的信息
%                           包括win，显示器句柄；cx，cy，显示器中心位置；slack，刷新时间的一半；
%                           windowWidth，显示器宽度；Vdist，距显示屏距离；Pwdith，显示屏横向分辨率
%   SpatialFrequency: 刺激的空间频率
%   TargetorNonTarget: 1表示是target，2表示是distractor
%   LeftorRight: 1表示缺口在左边，2表示缺口在右边(仅对target成立)
% 返回值包括：
%   pic: uint8，为Gabor刺激的图片
% 原始作者: 程宇昂, 2020/05/17

win=ScreenCondition.win;
slack=ScreenCondition.slack;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;
windowWidth=ScreenCondition.windowWidth;
Pwidth=ScreenCondition.Pwidth;
Vdist=ScreenCondition.Vdist;

% ---------------
% 视觉刺激基础参数
% ---------------
Sigma=deg2pix(0.37,windowWidth,Pwidth,Vdist);
Contrast=0.73;
Phase=rand()*2*pi;
Period=deg2pix(1/SpatialFrequency,windowWidth,Pwidth,Vdist);
AngleFromHorizon=pi/2;
notch=2;
RingSizeInner=deg2pix(1.45,windowWidth,Pwidth,Vdist);
RingSizeOuter=deg2pix(1.55,windowWidth,Pwidth,Vdist);
RingSizeMiddle=deg2pix(1.5,windowWidth,Pwidth,Vdist);
Size=deg2pix(3.5,windowWidth,Pwidth,Vdist);

% ---------------
% Gabor
% ---------------
[X,Y]=meshgrid(1:Size);
x0=Size/2;y0=Size/2;
X=X-x0;Y=Y-y0;
Gaussian=exp((X.^2+Y.^2)/(-2*Sigma*Sigma));
pic=(sin((sin(AngleFromHorizon)*X+cos(AngleFromHorizon)*Y)*2*pi/Period+Phase)*Contrast.*Gaussian+1)/2;

% ---------------
% Ring
% ---------------
sd=(RingSizeOuter-RingSizeInner)/2;
Ring=exp(((sqrt(X.^2+Y.^2)-RingSizeMiddle).^2)/(-2*sd*sd))/2+0.5;

% ---------------
% Notch
% ---------------
if(TargetorNonTarget==1)% 是target
    if(LeftorRight==1)% 左边
        idx=abs(atan2d(Y,X))>180-notch;
    else
        idx=abs(atan2d(Y,X))<0+notch;
    end
else
    rng shuffle;
    LeftorRight=rand()>0.5;
    upperorlower=((rand()>0.5)*2-1)*15;
    if(LeftorRight==1)% 左边
        if (upperorlower==15)
            idx=abs(atan2d(Y,X)-165)<notch;
        else
            idx=abs(atan2d(Y,X)+165)<notch;
        end
    else
        idx=abs(atan2d(Y,X)+upperorlower)<notch;
    end
end
Ring(idx)=0.5;

% ---------------
% 合并，并生成uint8格式的图片
% ---------------
idxx=X.^2+Y.^2>RingSizeInner^2;
pic(idxx)=Ring(idxx);
pic=repmat(pic,1,1,3);
pic=uint8(pic*255);

end
