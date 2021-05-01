function endtime=Pattern(AudioCondition,ScreenCondition,starttime,category,number)
% 按照category和number在starttime呈现Pattern
% 参数包括：
%   AudioConditon: 结构体，内含关于声音播放设备的所有基础信息，包括sr，采样率；pahandle，播放设备的句柄
%   ScreenConditon: 结构体, 内含关于显示器设备的所有基础信息以及部分牵涉到显示器像素转换的信息
%                           包括win，显示器句柄；cx，cy，显示器中心位置；slack，刷新时间的一半；
%                           Inch，显示器尺寸；Vdist，距显示屏距离；Pwdith，显示屏横向分辨率
%   starttime: double，为pattern呈现开始的时刻
%   category,number: 为pattern的类别和序号，详见说明文档
% 返回值包括：
%   endtime: double，为pattern呈现结束的时刻

% 每1个pattern包括3个stimuli，stimuli之间时间间隔为ISI=150ms
%
% 原始作者: 程宇昂, 2020/05/04

% ---------------
% 视觉刺激的颜色编码，声音刺激的频率编码和振幅编码
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
    127,127,127];% 具体颜色见说明文档
frequency=[261.63;277.18;293.66;311.13;329.63;
    349.23;369.99;392.00;415.30;440.00;493.88];% 分别为C4,C#4,D4,D#4,E4,F4,F#4,G4,G#4,A4,B4的频率
intensity=10.^(linspace(0,-20,11)/20);% 数字音频中0dB最大，*10^(dB/20)指降低dB分贝，故分别指0 -5 -10...-50dB

% ---------------
% Pattern的category和number到shape，color，frequency，intensity的映射关系
% category 1 2 3 4分别对应1 2 3 4行，即standard，audiotory, audiovisual和visual
% number 1 2 3 4 5 6分别对应1-6号pattern，亦即1-3号刺激，4-6号刺激...16-18号刺激
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

ISI=0.15;% 刺激之间的时间间隔为150ms
stinum1=3*number-2;stinum2=3*number-1;stinum3=3*number;%刺激序号

% ---------------
% 呈现第一个视觉刺激
% ---------------
myshape=shapesequence(category,stinum1);
mycolor=color(colorsequence(category,stinum1),:);
myfrequency=frequency(frequencysequence(category,stinum1));
myintensity=intensity(intensitysequence(category,stinum1));
endtime=DrawShapeandPlaySound(ScreenCondition,mycolor,starttime,myshape,AudioCondition,myfrequency,myintensity);

% ---------------
% 呈现第二个视觉刺激
% ---------------
starttime=endtime+ISI;
myshape=shapesequence(category,stinum2);
mycolor=color(colorsequence(category,stinum2),:);
myfrequency=frequency(frequencysequence(category,stinum2));
myintensity=intensity(intensitysequence(category,stinum2));
endtime=DrawShapeandPlaySound(ScreenCondition,mycolor,starttime,myshape,AudioCondition,myfrequency,myintensity);

% ---------------
% 呈现第三个视觉刺激
% ---------------
starttime=endtime+ISI;
myshape=shapesequence(category,stinum3);
mycolor=color(colorsequence(category,stinum3),:);
myfrequency=frequency(frequencysequence(category,stinum3));
myintensity=intensity(intensitysequence(category,stinum3));
endtime=DrawShapeandPlaySound(ScreenCondition,mycolor,starttime,myshape,AudioCondition,myfrequency,myintensity);

end

