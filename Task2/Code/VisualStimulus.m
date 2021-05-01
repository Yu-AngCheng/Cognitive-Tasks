function index=VisualStimulus(ScreenCondition,SetSizeNum,SpatialFrequencyNum,LeftorRight)
% 在Screen上绘制target和distractor，返回其句柄
% 参数包括：
%   ScreenConditon: 结构体, 内含关于显示器设备的所有基础信息以及部分牵涉到显示器像素转换的信息
%                           包括win，显示器句柄；cx，cy，显示器中心位置；slack，刷新时间的一半；
%                           windowWidth，显示器宽度；Vdist，距显示屏距离；Pwdith，显示屏横向分辨率
%   SpatialFrequencyNum: 刺激的空间频率序号
%   SetSizeNum: 1表示是4个distactor，2表示是8个distactor
%   LeftorRight: 1表示缺口在左边，2表示缺口在右边(仅对target成立)
% 返回值包括：
%   index: 图案句柄
% 原始作者: 程宇昂, 2020/05/17
win=ScreenCondition.win;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;
slack=ScreenCondition.slack;
windowWidth=ScreenCondition.windowWidth;
Pwidth=ScreenCondition.Pwidth;
Vdist=ScreenCondition.Vdist;
% 总共刺激个数
SetSize=[5,9];
SetSize=SetSize(SetSizeNum);
% 刺激的空间位置
startlocation=rand()*2*pi/SetSize-pi/SetSize;
Location=(0:2*pi/SetSize:2*pi-2*pi/SetSize)+startlocation;
Location=Location(randperm(length(Location)));
TargetLocation=Location(1);DistractorLocation=Location(2:end);
% 刺激的空间频率
SpatialFrequency=[0.43,0.87,1.30,1.74,2.17,2.61,3.04,3.48,3.92];
TargetSpatialFrequency=SpatialFrequency(SpatialFrequencyNum);
N=1:9;N=N(N~=SpatialFrequencyNum);SpatialFrequency=SpatialFrequency(N);
SpatialFrequency=SpatialFrequency(randperm(length(SpatialFrequency)));
DistractorFrequency=SpatialFrequency(1:SetSize-1);
% 刺激的视觉尺寸
Circle=deg2pix(6,windowWidth,Pwidth,Vdist);
halflen=deg2pix(0.25,windowWidth,Pwidth,Vdist);
Size=deg2pix(3.5,windowWidth,Pwidth,Vdist);

% 绘制视觉刺激
Screen('DrawLine', win, [255,255,255], cx-halflen, cy, cx+halflen, cy, 2);
Screen('DrawLine', win, [255,255,255], cx, cy-halflen, cx, cy+halflen, 2);
targetpicture=GenerateGaborWithRing(ScreenCondition,TargetSpatialFrequency,1,LeftorRight);
target=Screen('MakeTexture',win,targetpicture);
picrect=[1,1,Size,Size];
drect=CenterRectOnPoint(picrect,cx+Circle*cos(TargetLocation),cy+Circle*sin(TargetLocation));
Screen('DrawTexture',win,target,[],drect);
index=target;
for i=1:SetSize-1
    distractorpicture=GenerateGaborWithRing(ScreenCondition,DistractorFrequency(i),0,LeftorRight);
    drect=CenterRectOnPoint(picrect,cx+Circle*cos(DistractorLocation(i)),cy+Circle*sin(DistractorLocation(i)));
    distractor(i)=Screen('MakeTexture',win,distractorpicture);
    Screen('DrawTexture',win,distractor(i),[],drect);
end
index=[index,distractor];
end

