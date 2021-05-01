function tone = GenerateTone(AudioCondition,temporalfrequency)
% 生成调幅高斯白噪
% 参数包括：
%   AudioConditon: 结构体，内含关于声音播放设备的所有基础信息，包括sr，采样率；pahandle，播放设备的句柄
%   temporalfrequency: 载波的频率
% 返回值包括：
%   tone: 双声道声音刺激
% 原始作者: 程宇昂, 2020/05/17

pahandle=AudioCondition.pahandle;
sr=AudioCondition.sr;

duration=10;% 生成10s的demo
fpass=3500;% 高通滤波截止
ka=1;% 100%载波
t=0:1/sr:duration-1/sr;
whitenoise=randn(1,sr*duration);
whitenoise=highpass(whitenoise,fpass,sr);
tone=(1+whitenoise).*cos(2*pi*temporalfrequency.*t);
tone=tone./max(abs(tone));
tone=repmat(tone,2,1);
end

