%% 程序运行说明
%
% 运行本文件，即启动实验程序，启动时略显卡顿，属正常现象。
% 如需退出，请长按escape键（为保持精度，记录数据时无效，故建议同时按z键和escape键来退出)
% 语句详细说明参见后文注释。
% 参考文献: Statistical learning of multisensory regularities is enhanced in musicians: An MEG study
% 文献作者: Paraskevopoulos et.al(2018)
% 程序原始作者: 程宇昂, 2020/05/04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 信息录入
%包括被试个人信息和显示器信息，必须正确输入，输入错误直接报错退出
clear;
[SubjectInfo,StimulusInfo]=Information_Entry;
ID=str2double(SubjectInfo{1});
Inch=str2double(StimulusInfo{1});
Vdist=str2double(StimulusInfo{2});
if isnan(ID)||isnan(Inch)||isnan(Vdist)
    error('基本信息输入错误!');
end
%% 初始化
KbName('UnifyKeyNames');
Screen('Preference','SkipSyncTests',1);% 退出同步性测试，仅在调试时使用，正式实验请注释。如出现同步性测试问题请先调整硬件设施
Screen('Preference','TextEncodingLocale','UTF-8');
AssertOpenGL;
InitializePsychSound(1);
ListenChar(2);% 监听键盘，如若程序报错退出后出现键盘输入无效，可以按Ctrl+C退出监听
HideCursor;
%% 随机化试次
rng shuffle
traillist=genTrials(1,[3,6,2]);% 第一列1 2 3分别代表auditory,audiovisual,visual deviants，第二列是pattern的序号，第三列为1表示standard先呈现，2表示standard后呈现
traillist(:,4)=NaN;% 如未采集到被试信息，默认为NaN
total=36;
phase1=[ones(1,70);mod(randperm(70),6)+1];% 伪随机，确保每个pattern都会出现
sequence=phase1;
runs=3;
for i=1:runs
    phase2=generatesequence();%伪随机生成phase2序列，详见generatesequence
    sequence=[sequence,phase2];
end
%% 正式程序
try
    % ------------------------
    %初始化Screen和PsychPortAudio
    % ------------------------
    sr=48000;% 采样频率48kHz
    latbias=64/sr;
    pahandle=PsychPortAudio('Open',3,[],2,sr);% 注意：此处第三个参数为输出设备序号，大多数电脑为3，如出现故障或报错，可输入audiodevinfo查看output序号
    prelat=PsychPortAudio('LatencyBias',pahandle,latbias);
    postlat=PsychPortAudio('LatencyBias',pahandle);% PsychPortAudio延迟信息，如延迟时间过长，可根据参考信息，换支持asio协议的声卡
    screens=Screen('Screens');
    ScreenNum=max(screens);
    [win,rect]=Screen('OpenWindow',ScreenNum);
    Screen('TextFont',win,'-:lang=zh-cn');
    Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    refresh=Screen('GetFlipInterval',win);slack=refresh/2;% 获取屏幕刷新时间
    wx=rect(3);wy=rect(4);cx=wx/2;cy=wy/2;% 获取屏幕分辨率信息
    black=[0,0,0];white=[255,255,255];
    keyescape=KbName('escape');
    keyz=KbName('z');
    keym=KbName('m');
    % ------------------------
    % 以下保存了所有关于IO设备的信息
    %   AudioConditon: 结构体，内含关于声音播放设备的所有基础信息，包括sr，采样率；pahandle，播放设备的句柄
    %   ScreenConditon: 结构体, 内含关于显示器设备的所有基础信息以及部分牵涉到显示器像素转换的信息
    %                           包括win，显示器句柄；cx，cy，显示器中心位置；slack，刷新时间的一半；
    %                           Inch，显示器尺寸；Vdist，距显示屏距离；Pwdith，显示屏横向分辨率
    % ------------------------
    AudioCondition.pahandle=pahandle;AudioCondition.sr=sr;
    ScreenCondition.win=win;ScreenCondition.cx=cx;ScreenCondition.cy=cy;
    ScreenCondition.slack=slack;ScreenCondition.Inch=Inch;
    ScreenCondition.Vdist=Vdist;ScreenCondition.Pwidth=wx;
    Screen('FillRect',win,black);
    
    % ------------------------
    % 呈现指导语
    % ------------------------
    Show_Instructions1(ScreenCondition,white);
    
    % ------------------------
    % phase 1 & phase 2，只呈现刺激，不要求被试反应
    % phase1: 115.5s + phase2: 3*561s
    % 共计时30min
    % ------------------------
    starttime=GetSecs();
    ISI=0.15;% pattern之间间隔150ms
    for i=1:length(sequence)% 按照随机化试次的顺序，依次呈现pattern
        [~,~,keyCode]=KbCheck();
        if keyCode(keyescape)% 按escape键退出
            break;
        end
        category=sequence(1,i);number=sequence(2,i);
        endtime=Pattern(AudioCondition,ScreenCondition,starttime,category,number);% 详见Pattern
        starttime=endtime+ISI;
    end
    WaitSecs(1);% 间隔1s进入phase3(如不需要可以注释)，注意phase 1和phase 2之间无间隔
    
    
    % ------------------------
    % phase 3，最长时间为226.8s
    % ------------------------
    Show_Instructions2(ScreenCondition,white);% 呈现指导语
    ISI=0.30;% pattern之间间隔300ms
    blank=3.0;% 被试反应时间3s
    
    for i=1:total
        
        % ------------------------
        % 呈现standard和deviant
        % ------------------------
        [~,~,keyCode]=KbCheck();
        if keyCode(keyescape)% 按escape键退出
            break;
        end
        category=traillist(i,1)+1;% 条件1,2,3分别对应auditory,audiovisual,visual deviants，即category 2,3,4
        number=traillist(i,2);
        starttime=GetSecs();
        if(traillist(i,3)==1)% 第三个条件为1，先呈现standard
            endtime=Pattern(AudioCondition,ScreenCondition,starttime,1,number);
            starttime=endtime+ISI;
            endtime=Pattern(AudioCondition,ScreenCondition,starttime,category,number);
        elseif(traillist(i,3)==2)% 第三个条件为2，后呈现standard
            endtime=Pattern(AudioCondition,ScreenCondition,starttime,category,number);
            starttime=endtime+ISI;
            endtime=Pattern(AudioCondition,ScreenCondition,starttime,1,number);
        end
        
        % ------------------------
        % 呈现按键提示并收集按键结果
        % ------------------------
        DrawTextAt(win,'前一个组合对您更熟悉，请按z',cx,cy-30,white);
        DrawTextAt(win,'后一个组合对您更熟悉，请按m',cx,cy+30,white);
        Screen('Flip',win);
        while((GetSecs()-endtime)<=blank)
            [~,~,keyCode]=KbCheck();
            if keyCode(keyz)
                traillist(i,4)=1;% 按z记录为1，表示前一个更熟悉
                break;
            elseif keyCode(keym)
                traillist(i,4)=0;% 按m记录为2，表示后一个更熟悉
                break;
            end
        end
        
    end
    
    % ------------------------
    % 保存数据
    % ------------------------
    if ~(exist('MyData', 'dir'))% 如不存在MyData文件夹则创建MyData文件夹
        mkdir('MyData');
    end
    cd MyData;% 进入MyData文件夹
    save(strcat(SubjectInfo{1},'_',datestr(datetime('now'),'yyyymmddHHMM'),'.mat'),'traillist');% 用被试编号和实验结束时间作为文件名的唯一编码
    cd ..;% 返回上级目录
    
    % ------------------------
    % 合理退出
    % ------------------------
    PsychPortAudio('Close',pahandle);
    sca;
    ListenChar(0);
    ShowCursor;
catch ME %如出现异常错误，此处报错并退出
    sca;
    PsychPortAudio('Close');
    ListenChar(0);
    ShowCursor;
    rethrow(ME);
end