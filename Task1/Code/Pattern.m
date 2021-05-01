function endtime=Pattern(AudioCondition,ScreenCondition,starttime,category,number)
% ����category��number��starttime����Pattern
% ����������
%   AudioConditon: �ṹ�壬�ں��������������豸�����л�����Ϣ������sr�������ʣ�pahandle�������豸�ľ��
%   ScreenConditon: �ṹ��, �ں�������ʾ���豸�����л�����Ϣ�Լ�����ǣ�浽��ʾ������ת������Ϣ
%                           ����win����ʾ�������cx��cy����ʾ������λ�ã�slack��ˢ��ʱ���һ�룻
%                           Inch����ʾ���ߴ磻Vdist������ʾ�����룻Pwdith����ʾ������ֱ���
%   starttime: double��Ϊpattern���ֿ�ʼ��ʱ��
%   category,number: Ϊpattern��������ţ����˵���ĵ�
% ����ֵ������
%   endtime: double��Ϊpattern���ֽ�����ʱ��

% ÿ1��pattern����3��stimuli��stimuli֮��ʱ����ΪISI=150ms
%
% ԭʼ����: ���, 2020/05/04

% ---------------
% �Ӿ��̼�����ɫ���룬�����̼���Ƶ�ʱ�����������
% ---------------
color=...
    [192,0,0;
    160,81,16;
    132,140,142;
    255,192,0;
    175,170,105;
    0,176,80;
    70,181,211;
    173,173,219;
    0,32,96;
    112,48,160;
    127,127,127];% ������ɫ��˵���ĵ�
frequency=[261.63;277.18;293.66;311.13;329.63;
    349.23;369.99;392.00;415.30;440.00;493.88];% �ֱ�ΪC4,C#4,D4,D#4,E4,F4,F#4,G4,G#4,A4,B4��Ƶ��
intensity=10.^(linspace(0,-20,11)/20);% ������Ƶ��0dB���*10^(dB/20)ָ����dB�ֱ����ʷֱ�ָ0 -5 -10...-50dB

% ---------------
% Pattern��category��number��shape��color��frequency��intensity��ӳ���ϵ
% category 1 2 3 4�ֱ��Ӧ1 2 3 4�У���standard��audiotory, audiovisual��visual
% number 1 2 3 4 5 6�ֱ��Ӧ1-6��pattern���༴1-3�Ŵ̼���4-6�Ŵ̼�...16-18�Ŵ̼�
% ---------------
shapesequence=...
    [1	2	3	4	3	5	6	7	3	3	8	7	8	1	9	10	11	4;
    1	2	3	4	3	5	6	7	3	3	8	7	8	1	9	10	11	4;
    1	2	8	4	3	1	6	7	10	3	8	4	8	1	6	10	11	3;
    1	2	3	4	3	5	6	7	3	3	8	7	8	1	9	10	11	4];
colorsequence=...
    [1	10	4	1	4	7	8	5	4	4	6	5	6	1	9	7	11	1;
    1	10	4	1	4	7	8	5	4	4	6	5	6	1	9	7	11	1;
    1	10	4	1	4	7	8	5	4	4	6	5	6	1	9	7	11	1;
    1	10	6	1	4	2	8	5	1	4	6	7	6	1	7	7	11	8];
frequencysequence=...
    [1	2	3	10	3	11	4	5	3	3	6	5	6	1	7	8	9	10;
    1	2	3	10	3	11	4	5	3	3	6	5	6	1	7	8	9	10;
    1	2	6	10	3	1	4	5	8	3	6	10	6	1	4	8	9	3;
    1	2	3	10	3	11	4	5	3	3	6	5	6	1	7	8	9	10];
intensitysequence=...
    [4	5	2	1	2	3	6	7	2	2	8	7	8	4	9	10	11	1
    4	5	8	1	2	4	6	7	10	2	8	1	8	4	6	10	11	6
    4	5	2	1	2	3	6	7	2	2	8	7	8	4	9	10	11	1
    4	5	2	1	2	3	6	7	2	2	8	7	8	4	9	10	11	1];

ISI=0.15;% �̼�֮���ʱ����Ϊ150ms
stinum1=3*number-2;stinum2=3*number-1;stinum3=3*number;%�̼����

% ---------------
% ���ֵ�һ���Ӿ��̼�
% ---------------
myshape=shapesequence(category,stinum1);
mycolor=color(colorsequence(category,stinum1),:);
myfrequency=frequency(frequencysequence(category,stinum1));
myintensity=intensity(intensitysequence(category,stinum1));
endtime=DrawShapeandPlaySound(ScreenCondition,mycolor,starttime,myshape,AudioCondition,myfrequency,myintensity);

% ---------------
% ���ֵڶ����Ӿ��̼�
% ---------------
starttime=endtime+ISI;
myshape=shapesequence(category,stinum2);
mycolor=color(colorsequence(category,stinum2),:);
myfrequency=frequency(frequencysequence(category,stinum2));
myintensity=intensity(intensitysequence(category,stinum2));
endtime=DrawShapeandPlaySound(ScreenCondition,mycolor,starttime,myshape,AudioCondition,myfrequency,myintensity);

% ---------------
% ���ֵ������Ӿ��̼�
% ---------------
starttime=endtime+ISI;
myshape=shapesequence(category,stinum3);
mycolor=color(colorsequence(category,stinum3),:);
myfrequency=frequency(frequencysequence(category,stinum3));
myintensity=intensity(intensitysequence(category,stinum3));
endtime=DrawShapeandPlaySound(ScreenCondition,mycolor,starttime,myshape,AudioCondition,myfrequency,myintensity);

end

