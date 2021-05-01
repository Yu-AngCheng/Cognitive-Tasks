function pic = GenerateGaborWithRing(ScreenCondition,SpatialFrequency,TargetorNonTarget,LeftorRight)
% ���ɴ�����ȱ�ڵ�Gabor�̼�
% ����������
%   ScreenConditon: �ṹ��, �ں�������ʾ���豸�����л�����Ϣ�Լ�����ǣ�浽��ʾ������ת������Ϣ
%                           ����win����ʾ�������cx��cy����ʾ������λ�ã�slack��ˢ��ʱ���һ�룻
%                           windowWidth����ʾ����ȣ�Vdist������ʾ�����룻Pwdith����ʾ������ֱ���
%   SpatialFrequency: �̼��Ŀռ�Ƶ��
%   TargetorNonTarget: 1��ʾ��target��2��ʾ��distractor
%   LeftorRight: 1��ʾȱ������ߣ�2��ʾȱ�����ұ�(����target����)
% ����ֵ������
%   pic: uint8��ΪGabor�̼���ͼƬ
% ԭʼ����: ���, 2020/05/17

win=ScreenCondition.win;
slack=ScreenCondition.slack;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;
windowWidth=ScreenCondition.windowWidth;
Pwidth=ScreenCondition.Pwidth;
Vdist=ScreenCondition.Vdist;

% ---------------
% �Ӿ��̼���������
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
if(TargetorNonTarget==1)% ��target
    if(LeftorRight==1)% ���
        idx=abs(atan2d(Y,X))>180-notch;
    else
        idx=abs(atan2d(Y,X))<0+notch;
    end
else
    rng shuffle;
    LeftorRight=rand()>0.5;
    upperorlower=((rand()>0.5)*2-1)*15;
    if(LeftorRight==1)% ���
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
% �ϲ���������uint8��ʽ��ͼƬ
% ---------------
idxx=X.^2+Y.^2>RingSizeInner^2;
pic(idxx)=Ring(idxx);
pic=repmat(pic,1,1,3);
pic=uint8(pic*255);

end
