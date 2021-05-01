function endtime=DrawShapeandPlaySound(ScreenCondition,color,starttime,shapeindex,AudioCondition,frequency,intensity)
% 按照color,shapeindex,frequency和intensity来呈现单个Stimulus
% 参数包括：
%   AudioConditon: 结构体，内含关于声音播放设备的所有基础信息，包括sr，采样率；pahandle，播放设备的句柄
%   ScreenConditon: 结构体, 内含关于显示器设备的所有基础信息以及部分牵涉到显示器像素转换的信息
%                           包括win，显示器句柄；cx，cy，显示器中心位置；slack，刷新时间的一半；
%                           Inch，显示器尺寸；Vdist，距显示屏距离；Pwdith，显示屏横向分辨率
%   starttime: double，为stimulus呈现开始的时刻
%   color: double，stimulus的颜色
%   shapeindex: double，stimulus的形状，具体形状可参考说明文档
%   frequency: double，声音刺激的频率
%   intensity: double，声音刺激的振幅
% 返回值包括：
%   endtime: double，为stimulus呈现结束的时刻

% 每个stimuli呈现时间为400ms

% 原始作者: 程宇昂, 2020/05/04

win=ScreenCondition.win;
slack=ScreenCondition.slack;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;
Inch=ScreenCondition.Inch;
Pwidth=ScreenCondition.Pwidth;
Vdist=ScreenCondition.Vdist;
pahandle=AudioCondition.pahandle;
sr=AudioCondition.sr;
duration=0.40;

% ---------------
% 400ms声音刺激，包括前后各30ms的淡入和淡出
% ---------------
% 构造包络
target=[0.99999;0.25;0];
gain=[0.005;0.0004;0.00075];
time=[0.03,0.34,0.03];
envelope=getADSR(target,gain,time)';
% gatedur=30/1000;
% gate=cos(linspace(-pi/2,0,sr*gatedur));% 前30ms淡入
% offsetgate=fliplr(gate);% 后30ms淡出
% sustain=ones(1,length(tone)-2*length(gate));% 中间保持
% envelope=[gate,sustain,offsetgate];
tone=MakeBeep(frequency,duration,sr);% 注意：不同版本的MakeBeep可能会存在位数不同的情况
tone=tone(1:sr*duration);
tone=envelope.*tone;tone=tone./max(abs(tone));
tone=intensity*repmat(tone,2,1);% 双声道
PsychPortAudio('FillBuffer',pahandle,tone);

% ---------------
% 400ms视觉刺激，共11种形状
% ---------------
black=[0,0,0];
if(shapeindex==1)
    %画两个三角形，边长为2°视角
    R=deg2pix(2,Inch,Pwidth,Vdist);% 三角形边长
    left(1,:)=[cx,cy];
    left(2,:)=[cx-R*cosd(30),cy+R*sind(30)];
    left(3,:)=[cx-R*cosd(30),cy-R*sind(30)];
    right(1,:)=[cx,cy];
    right(2,:)=[cx+R*cosd(30),cy-R*sind(30)];
    right(3,:)=[cx+R*cosd(30),cy+R*sind(30)];
    Screen('FillPoly',win,color,left);
    Screen('FillPoly',win,color,right);
elseif(shapeindex==2)
    %画一个圆上下都是长方形，长方形长为2°视角,宽为0.5°视角，圆半径为0.75°视角
    len=deg2pix(2,Inch,Pwidth,Vdist);% 长
    width=deg2pix(0.5,Inch,Pwidth,Vdist);% 宽
    R=deg2pix(0.75,Inch,Pwidth,Vdist);% 半径
    Circle=[cx-R,cy-R,cx+R,cy+R];
    rect=[0,0,len,width];
    drect1=CenterRectOnPoint(rect,cx,cy-R-width/2);
    drect2=CenterRectOnPoint(rect,cx,cy+R+width/2);
    Screen('FillOval',win,color,Circle);
    Screen('FillRect',win,color,drect1);
    Screen('FillRect',win,color,drect2);
elseif(shapeindex==3)
    %上下画两个圆，半径为0.25°视角，竖着一个长方形，长为1.5°视角，宽为0.2°视角
    len=deg2pix(1.5,Inch,Pwidth,Vdist);% 长
    width=deg2pix(0.2,Inch,Pwidth,Vdist);% 宽
    R=deg2pix(0.25,Inch,Pwidth,Vdist);% 半径
    Rect=[cx-width/2,cy-len/2,cx+width/2,cy+len/2];
    circle=[0,0,2*R,2*R];
    dcircle1=CenterRectOnPoint(circle,cx,cy-len/2);
    dcircle2=CenterRectOnPoint(circle,cx,cy+len/2);
    Screen('FillRect',win,color,Rect);
    Screen('FillOval',win,color,dcircle1);
    Screen('FillOval',win,color,dcircle2);
elseif(shapeindex==4)
    %画一个边长为2°视角的正方形,缺四个弧形，再叠绘一个边长0.7°视角的正方形
    Rsquare1=deg2pix(2,Inch,Pwidth,Vdist);% 边长1
    Rsquare2=deg2pix(0.7,Inch,Pwidth,Vdist);% 边长2
    Rect1=[cx-Rsquare1/2,cy-Rsquare1/2,cx+Rsquare1/2,cy+Rsquare1/2];
    Rect2=[cx-Rsquare2/2,cy-Rsquare2/2,cx+Rsquare2/2,cy+Rsquare2/2];
    arc1=[cx-Rsquare1,cy-Rsquare1,cx,cy];
    arc2=[cx,cy-Rsquare1,cx+Rsquare1,cy];
    arc3=[cx-Rsquare1,cy,cx,cy+Rsquare1];
    arc4=[cx,cy,cx+Rsquare1,cy+Rsquare1];
    Screen('FillRect',win,color,Rect1);
    Screen('FillArc',win,black,arc1,90,90);
    Screen('FillArc',win,black,arc2,180,90);
    Screen('FillArc',win,black,arc3,0,90);
    Screen('FillArc',win,black,arc4,270,90);
    Screen('FillRect',win,color,Rect2);
elseif(shapeindex==5)
    %画左边一个宽0.5°视角，长2°视角的长方形，右边长1.5°宽0.7°视角的长方形
    length1=deg2pix(2,Inch,Pwidth,Vdist);% 长1
    width1=deg2pix(0.5,Inch,Pwidth,Vdist);% 宽1
    length2=deg2pix(1.5,Inch,Pwidth,Vdist);% 长2
    width2=deg2pix(0.7,Inch,Pwidth,Vdist);% 宽2
    Rect1=[0,0,width1,length1];
    Rect2=[0,0,length2,width2];
    drect1=CenterRectOnPoint(Rect1,cx-length2/2,cy);%Caution
    drect2=CenterRectOnPoint(Rect2,cx+width1/2,cy);%Caution
    Screen('FillRect',win,color,drect1);
    Screen('FillRect',win,color,drect2);
elseif(shapeindex==6)
    %画左边一个宽0.5°视角，长2°视角的长方形，一个半径为0.3°视角的圆
    length1=deg2pix(2,Inch,Pwidth,Vdist);% 长
    width1=deg2pix(0.5,Inch,Pwidth,Vdist);% 宽
    R=deg2pix(0.3,Inch,Pwidth,Vdist);% 半径
    Rect=[0,0,length1,width1];
    drect=CenterRectOnPoint(Rect,cx,cy+R);
    Circle=[cx-R,cy-R,cx+R,cy+R];
    Screen('FillOval',win,color,Circle);
    Screen('FillRect',win,color,drect);
elseif(shapeindex==7)
    %画一个半径为0.7°视角的圆和一条线
    R=deg2pix(0.7,Inch,Pwidth,Vdist);% 半径
    Rline=deg2pix(2*sqrt(2),Inch,Pwidth,Vdist);
    Circle=[cx-R,cy-R,cx+R,cy+R];
    fromH=cx-Rline/sqrt(2);
    fromV=cy+Rline/sqrt(2);
    toH=cx+Rline/sqrt(2);
    toV=cy-Rline/sqrt(2);
    Screen('FillOval',win,color,Circle);
    Screen('DrawLine',win,color,fromH,fromV,toH,toV,5);
elseif(shapeindex==8)
    %画一个长为1.4°视角，宽为0.3°视角的长方形，和一个高为0.6°视角的等腰RT三角形
    length1=deg2pix(1.4,Inch,Pwidth,Vdist);% 长
    width1=deg2pix(0.3,Inch,Pwidth,Vdist);% 宽
    height=deg2pix(0.6,Inch,Pwidth,Vdist);% 高
    Rect=[0,0,width1,length1];
    drect=CenterRectOnPoint(Rect,cx,cy-height/2);
    triangle(1,:)=[cx-height,cy+length1/2-height/2];
    triangle(2,:)=[cx,cy+height+length1/2-height/2];
    triangle(3,:)=[cx+height,cy+length1/2-height/2];
    Screen('FillRect',win,color,drect);
    Screen('FillPoly',win,color,triangle,1);
elseif(shapeindex==9)
    %画一个长为2°视角，宽为0.2°视角的长方形，和两个个高为0.7°视角，底为0.2°视角的等腰三角形
    len=deg2pix(2,Inch,Pwidth,Vdist);% 长
    width=deg2pix(0.2,Inch,Pwidth,Vdist);% 宽
    height=deg2pix(0.7,Inch,Pwidth,Vdist);% 高
    base=deg2pix(0.2,Inch,Pwidth,Vdist);% 底
    Rect=[0,0,width,len];
    drect=CenterRectOnPoint(Rect,cx,cy);
    left(1,:)=[cx-width/2,cy-len/2+base];
    left(2,:)=[cx-width/2,cy-len/2];
    left(3,:)=[cx-width/2-height,cy-len/2+base/2];
    right(1,:)=[cx+width/2,cy+len/2];
    right(2,:)=[cx+width/2,cy+len/2-base];
    right(3,:)=[cx+width/2+height,cy+len/2-base/2];
    Screen('FillRect',win,color,drect);
    Screen('FillPoly',win,color,left);
    Screen('FillPoly',win,color,right);
    
elseif(shapeindex==10)
    %画一个半径为0.2°视角的圆，高为1°视角的等腰RT三角形以及两条线段
    R=deg2pix(0.2,Inch,Pwidth,Vdist);% 半径
    height=deg2pix(1.0,Inch,Pwidth,Vdist);% 高
    Circle=[cx-2*R,cy-2*R,cx+2*R,cy+2*R];
    triangle(1,:)=[cx,cy];
    triangle(2,:)=[cx-height,cy+height];
    triangle(3,:)=[cx+height,cy+height];
    Screen('FillOval',win,color,Circle);
    Screen('FillPoly',win,color,triangle);
    Screen('DrawLine',win,color,cx-height,cy+height,cx+height,cy-height);
    Screen('DrawLine',win,color,cx+height,cy+height,cx-height,cy-height);
elseif(shapeindex==11)
    %画一个半径为0.2°视角的圆，和一个多边形
    R=deg2pix(0.2,Inch,Pwidth,Vdist);% 圆
    Circle=[cx-R-R/sqrt(2),cy-R+R/sqrt(2),cx+R-R/sqrt(2),cy+R++R/sqrt(2)];
    len=deg2pix(2,Inch,Pwidth,Vdist);
    width=deg2pix(0.2,Inch,Pwidth,Vdist);
    height=deg2pix(0.5,Inch,Pwidth,Vdist);
    base=height*cosd(75)/sind(75)*2;
    poly(1,:)=[cx-len/2*cosd(45)-width/2*cosd(45),cy-len/2*cosd(45)+width/2*cosd(45)];
    poly(2,:)=[cx+len/2*cosd(45)-width/2*cosd(45),cy+len/2*cosd(45)+width/2*cosd(45)];
    poly(3,:)=[cx+len/2*cosd(45)+width/2*cosd(45),cy+len/2*cosd(45)-width/2*cosd(45)];
    poly(4,:)=[poly(3,1)+height/sind(75)*cosd(60),poly(3,2)-height/sind(75)*sind(60)];
    poly(5,:)=[poly(3,1)-base*sind(45),poly(3,2)-base*sind(45)];
    poly(8,:)=[cx-len/2*cosd(45)+width/2*cosd(45),cy-len/2*cosd(45)-width/2*cosd(45)];
    poly(7,:)=[poly(8,1)+height/sind(75)*cosd(30),poly(8,2)-height/sind(75)*sind(30)];
    poly(6,:)=[poly(8,1)+base*cosd(45),poly(8,2)+base*cosd(45)];
    Screen('FillOval',win,color,Circle);
    Screen('FillPoly',win,color,poly);
end

% ---------------
% 视听锁时
% ---------------
PsychPortAudio('Start',pahandle,1,starttime);
endtime=Screen('Flip',win,starttime-slack);
starttime=endtime;
Screen('FillRect',win,black);
endtime=Screen('Flip',win,starttime+duration-slack);
PsychPortAudio('Stop', pahandle,1);

end

