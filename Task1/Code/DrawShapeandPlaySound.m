function endtime=DrawShapeandPlaySound(ScreenCondition,color,starttime,shapeindex,AudioCondition,frequency,intensity)
% ����color,shapeindex,frequency��intensity�����ֵ���Stimulus
% ����������
%   AudioConditon: �ṹ�壬�ں��������������豸�����л�����Ϣ������sr�������ʣ�pahandle�������豸�ľ��
%   ScreenConditon: �ṹ��, �ں�������ʾ���豸�����л�����Ϣ�Լ�����ǣ�浽��ʾ������ת������Ϣ
%                           ����win����ʾ�������cx��cy����ʾ������λ�ã�slack��ˢ��ʱ���һ�룻
%                           Inch����ʾ���ߴ磻Vdist������ʾ�����룻Pwdith����ʾ������ֱ���
%   starttime: double��Ϊstimulus���ֿ�ʼ��ʱ��
%   color: double��stimulus����ɫ
%   shapeindex: double��stimulus����״��������״�ɲο�˵���ĵ�
%   frequency: double�������̼���Ƶ��
%   intensity: double�������̼������
% ����ֵ������
%   endtime: double��Ϊstimulus���ֽ�����ʱ��

% ÿ��stimuli����ʱ��Ϊ400ms

% ԭʼ����: ���, 2020/05/04

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
% 400ms�����̼�������ǰ���30ms�ĵ���͵���
% ---------------
% �������
target=[0.99999;0.25;0];
gain=[0.005;0.0004;0.00075];
time=[0.03,0.34,0.03];
envelope=getADSR(target,gain,time)';
% gatedur=30/1000;
% gate=cos(linspace(-pi/2,0,sr*gatedur));% ǰ30ms����
% offsetgate=fliplr(gate);% ��30ms����
% sustain=ones(1,length(tone)-2*length(gate));% �м䱣��
% envelope=[gate,sustain,offsetgate];
tone=MakeBeep(frequency,duration,sr);% ע�⣺��ͬ�汾��MakeBeep���ܻ����λ����ͬ�����
tone=tone(1:sr*duration);
tone=envelope.*tone;tone=tone./max(abs(tone));
tone=intensity*repmat(tone,2,1);% ˫����
PsychPortAudio('FillBuffer',pahandle,tone);

% ---------------
% 400ms�Ӿ��̼�����11����״
% ---------------
black=[0,0,0];
if(shapeindex==1)
    %�����������Σ��߳�Ϊ2���ӽ�
    R=deg2pix(2,Inch,Pwidth,Vdist);% �����α߳�
    left(1,:)=[cx,cy];
    left(2,:)=[cx-R*cosd(30),cy+R*sind(30)];
    left(3,:)=[cx-R*cosd(30),cy-R*sind(30)];
    right(1,:)=[cx,cy];
    right(2,:)=[cx+R*cosd(30),cy-R*sind(30)];
    right(3,:)=[cx+R*cosd(30),cy+R*sind(30)];
    Screen('FillPoly',win,color,left);
    Screen('FillPoly',win,color,right);
elseif(shapeindex==2)
    %��һ��Բ���¶��ǳ����Σ������γ�Ϊ2���ӽ�,��Ϊ0.5���ӽǣ�Բ�뾶Ϊ0.75���ӽ�
    len=deg2pix(2,Inch,Pwidth,Vdist);% ��
    width=deg2pix(0.5,Inch,Pwidth,Vdist);% ��
    R=deg2pix(0.75,Inch,Pwidth,Vdist);% �뾶
    Circle=[cx-R,cy-R,cx+R,cy+R];
    rect=[0,0,len,width];
    drect1=CenterRectOnPoint(rect,cx,cy-R-width/2);
    drect2=CenterRectOnPoint(rect,cx,cy+R+width/2);
    Screen('FillOval',win,color,Circle);
    Screen('FillRect',win,color,drect1);
    Screen('FillRect',win,color,drect2);
elseif(shapeindex==3)
    %���»�����Բ���뾶Ϊ0.25���ӽǣ�����һ�������Σ���Ϊ1.5���ӽǣ���Ϊ0.2���ӽ�
    len=deg2pix(1.5,Inch,Pwidth,Vdist);% ��
    width=deg2pix(0.2,Inch,Pwidth,Vdist);% ��
    R=deg2pix(0.25,Inch,Pwidth,Vdist);% �뾶
    Rect=[cx-width/2,cy-len/2,cx+width/2,cy+len/2];
    circle=[0,0,2*R,2*R];
    dcircle1=CenterRectOnPoint(circle,cx,cy-len/2);
    dcircle2=CenterRectOnPoint(circle,cx,cy+len/2);
    Screen('FillRect',win,color,Rect);
    Screen('FillOval',win,color,dcircle1);
    Screen('FillOval',win,color,dcircle2);
elseif(shapeindex==4)
    %��һ���߳�Ϊ2���ӽǵ�������,ȱ�ĸ����Σ��ٵ���һ���߳�0.7���ӽǵ�������
    Rsquare1=deg2pix(2,Inch,Pwidth,Vdist);% �߳�1
    Rsquare2=deg2pix(0.7,Inch,Pwidth,Vdist);% �߳�2
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
    %�����һ����0.5���ӽǣ���2���ӽǵĳ����Σ��ұ߳�1.5���0.7���ӽǵĳ�����
    length1=deg2pix(2,Inch,Pwidth,Vdist);% ��1
    width1=deg2pix(0.5,Inch,Pwidth,Vdist);% ��1
    length2=deg2pix(1.5,Inch,Pwidth,Vdist);% ��2
    width2=deg2pix(0.7,Inch,Pwidth,Vdist);% ��2
    Rect1=[0,0,width1,length1];
    Rect2=[0,0,length2,width2];
    drect1=CenterRectOnPoint(Rect1,cx-length2/2,cy);%Caution
    drect2=CenterRectOnPoint(Rect2,cx+width1/2,cy);%Caution
    Screen('FillRect',win,color,drect1);
    Screen('FillRect',win,color,drect2);
elseif(shapeindex==6)
    %�����һ����0.5���ӽǣ���2���ӽǵĳ����Σ�һ���뾶Ϊ0.3���ӽǵ�Բ
    length1=deg2pix(2,Inch,Pwidth,Vdist);% ��
    width1=deg2pix(0.5,Inch,Pwidth,Vdist);% ��
    R=deg2pix(0.3,Inch,Pwidth,Vdist);% �뾶
    Rect=[0,0,length1,width1];
    drect=CenterRectOnPoint(Rect,cx,cy+R);
    Circle=[cx-R,cy-R,cx+R,cy+R];
    Screen('FillOval',win,color,Circle);
    Screen('FillRect',win,color,drect);
elseif(shapeindex==7)
    %��һ���뾶Ϊ0.7���ӽǵ�Բ��һ����
    R=deg2pix(0.7,Inch,Pwidth,Vdist);% �뾶
    Rline=deg2pix(2*sqrt(2),Inch,Pwidth,Vdist);
    Circle=[cx-R,cy-R,cx+R,cy+R];
    fromH=cx-Rline/sqrt(2);
    fromV=cy+Rline/sqrt(2);
    toH=cx+Rline/sqrt(2);
    toV=cy-Rline/sqrt(2);
    Screen('FillOval',win,color,Circle);
    Screen('DrawLine',win,color,fromH,fromV,toH,toV,5);
elseif(shapeindex==8)
    %��һ����Ϊ1.4���ӽǣ���Ϊ0.3���ӽǵĳ����Σ���һ����Ϊ0.6���ӽǵĵ���RT������
    length1=deg2pix(1.4,Inch,Pwidth,Vdist);% ��
    width1=deg2pix(0.3,Inch,Pwidth,Vdist);% ��
    height=deg2pix(0.6,Inch,Pwidth,Vdist);% ��
    Rect=[0,0,width1,length1];
    drect=CenterRectOnPoint(Rect,cx,cy-height/2);
    triangle(1,:)=[cx-height,cy+length1/2-height/2];
    triangle(2,:)=[cx,cy+height+length1/2-height/2];
    triangle(3,:)=[cx+height,cy+length1/2-height/2];
    Screen('FillRect',win,color,drect);
    Screen('FillPoly',win,color,triangle,1);
elseif(shapeindex==9)
    %��һ����Ϊ2���ӽǣ���Ϊ0.2���ӽǵĳ����Σ�����������Ϊ0.7���ӽǣ���Ϊ0.2���ӽǵĵ���������
    len=deg2pix(2,Inch,Pwidth,Vdist);% ��
    width=deg2pix(0.2,Inch,Pwidth,Vdist);% ��
    height=deg2pix(0.7,Inch,Pwidth,Vdist);% ��
    base=deg2pix(0.2,Inch,Pwidth,Vdist);% ��
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
    %��һ���뾶Ϊ0.2���ӽǵ�Բ����Ϊ1���ӽǵĵ���RT�������Լ������߶�
    R=deg2pix(0.2,Inch,Pwidth,Vdist);% �뾶
    height=deg2pix(1.0,Inch,Pwidth,Vdist);% ��
    Circle=[cx-2*R,cy-2*R,cx+2*R,cy+2*R];
    triangle(1,:)=[cx,cy];
    triangle(2,:)=[cx-height,cy+height];
    triangle(3,:)=[cx+height,cy+height];
    Screen('FillOval',win,color,Circle);
    Screen('FillPoly',win,color,triangle);
    Screen('DrawLine',win,color,cx-height,cy+height,cx+height,cy-height);
    Screen('DrawLine',win,color,cx+height,cy+height,cx-height,cy-height);
elseif(shapeindex==11)
    %��һ���뾶Ϊ0.2���ӽǵ�Բ����һ�������
    R=deg2pix(0.2,Inch,Pwidth,Vdist);% Բ
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
% ������ʱ
% ---------------
PsychPortAudio('Start',pahandle,1,starttime);
endtime=Screen('Flip',win,starttime-slack);
starttime=endtime;
Screen('FillRect',win,black);
endtime=Screen('Flip',win,starttime+duration-slack);
PsychPortAudio('Stop', pahandle,1);

end

