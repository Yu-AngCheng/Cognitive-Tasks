function index=VisualStimulus(ScreenCondition,SetSizeNum,SpatialFrequencyNum,LeftorRight)
% ��Screen�ϻ���target��distractor����������
% ����������
%   ScreenConditon: �ṹ��, �ں�������ʾ���豸�����л�����Ϣ�Լ�����ǣ�浽��ʾ������ת������Ϣ
%                           ����win����ʾ�������cx��cy����ʾ������λ�ã�slack��ˢ��ʱ���һ�룻
%                           windowWidth����ʾ����ȣ�Vdist������ʾ�����룻Pwdith����ʾ������ֱ���
%   SpatialFrequencyNum: �̼��Ŀռ�Ƶ�����
%   SetSizeNum: 1��ʾ��4��distactor��2��ʾ��8��distactor
%   LeftorRight: 1��ʾȱ������ߣ�2��ʾȱ�����ұ�(����target����)
% ����ֵ������
%   index: ͼ�����
% ԭʼ����: ���, 2020/05/17
win=ScreenCondition.win;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;
slack=ScreenCondition.slack;
windowWidth=ScreenCondition.windowWidth;
Pwidth=ScreenCondition.Pwidth;
Vdist=ScreenCondition.Vdist;
% �ܹ��̼�����
SetSize=[5,9];
SetSize=SetSize(SetSizeNum);
% �̼��Ŀռ�λ��
startlocation=rand()*2*pi/SetSize-pi/SetSize;
Location=(0:2*pi/SetSize:2*pi-2*pi/SetSize)+startlocation;
Location=Location(randperm(length(Location)));
TargetLocation=Location(1);DistractorLocation=Location(2:end);
% �̼��Ŀռ�Ƶ��
SpatialFrequency=[0.43,0.87,1.30,1.74,2.17,2.61,3.04,3.48,3.92];
TargetSpatialFrequency=SpatialFrequency(SpatialFrequencyNum);
N=1:9;N=N(N~=SpatialFrequencyNum);SpatialFrequency=SpatialFrequency(N);
SpatialFrequency=SpatialFrequency(randperm(length(SpatialFrequency)));
DistractorFrequency=SpatialFrequency(1:SetSize-1);
% �̼����Ӿ��ߴ�
Circle=deg2pix(6,windowWidth,Pwidth,Vdist);
halflen=deg2pix(0.25,windowWidth,Pwidth,Vdist);
Size=deg2pix(3.5,windowWidth,Pwidth,Vdist);

% �����Ӿ��̼�
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

