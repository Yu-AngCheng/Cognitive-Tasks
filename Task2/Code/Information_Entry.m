function [SubjectInfo,StimulusInfo] = Information_Entry()
% 信息录入(包括被试个人信息和显示器信息)

% 返回值包括：
%   SubjectInfo: 结构体，内含被试的编号，年龄，利手和性别
%   StimulusInfo: 结构体，内含屏幕的尺寸和离屏幕的距离

% 可以修改prompt来修改希望填入的信息

% 原始作者: 程宇昂, 2020/05/04
prompt={'编号','年龄','利手','性别'};
title='被试信息';
dims=[1,55];
defineput={'999','999','999','999','999'};
SubjectInfo = inputdlg(prompt,title,dims,defineput,'on');

prompt={'屏幕尺寸','离屏幕距离'};
title='视角信息';
dims=[1,55];
defineput={'15.6','57'};
StimulusInfo = inputdlg(prompt,title,dims,defineput,'on');
end
