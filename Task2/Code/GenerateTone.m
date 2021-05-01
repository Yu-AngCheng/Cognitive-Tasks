function tone = GenerateTone(AudioCondition,temporalfrequency)
% ���ɵ�����˹����
% ����������
%   AudioConditon: �ṹ�壬�ں��������������豸�����л�����Ϣ������sr�������ʣ�pahandle�������豸�ľ��
%   temporalfrequency: �ز���Ƶ��
% ����ֵ������
%   tone: ˫���������̼�
% ԭʼ����: ���, 2020/05/17

pahandle=AudioCondition.pahandle;
sr=AudioCondition.sr;

duration=10;% ����10s��demo
fpass=3500;% ��ͨ�˲���ֹ
ka=1;% 100%�ز�
t=0:1/sr:duration-1/sr;
whitenoise=randn(1,sr*duration);
whitenoise=highpass(whitenoise,fpass,sr);
tone=(1+whitenoise).*cos(2*pi*temporalfrequency.*t);
tone=tone./max(abs(tone));
tone=repmat(tone,2,1);
end

