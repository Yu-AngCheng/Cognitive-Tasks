function [SubjectInfo,StimulusInfo] = Information_Entry()
% ��Ϣ¼��(�������Ը�����Ϣ����ʾ����Ϣ)

% ����ֵ������
%   SubjectInfo: �ṹ�壬�ں����Եı�ţ����䣬���ֺ��Ա�
%   StimulusInfo: �ṹ�壬�ں���Ļ�ĳߴ������Ļ�ľ���

% �����޸�prompt���޸�ϣ���������Ϣ

% ԭʼ����: ���, 2020/05/04
prompt={'���','����','����','�Ա�'};
title='������Ϣ';
dims=[1,55];
defineput={'999','999','999','999','999'};
SubjectInfo = inputdlg(prompt,title,dims,defineput,'on');

prompt={'��Ļ�ߴ�','����Ļ����'};
title='�ӽ���Ϣ';
dims=[1,55];
defineput={'15.6','57'};
StimulusInfo = inputdlg(prompt,title,dims,defineput,'on');
end
