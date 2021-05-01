%% 程序运行说明
%
% 运行本文件，即启动实验程序，启动时略显卡顿，属正常现象。
% 如需退出，请长按escape键（为保持精度，记录数据时退出无效，故建议同时按左键和escape键来退出)
% 训练阶段由于PTB启动略有延迟，正式实验不受此影响
% 语句详细说明参见后文注释。
% 参考文献: Amplitude-modulated auditory stimuli influence selection of visual spatial frequencies
% 文献作者: Emily Orchard-Mills, Erik Van der Burg, David Alais
% 程序原始作者: 程宇昂, 2020/05/16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 信息录入
%包括被试个人信息和显示器信息，必须正确输入，输入错误直接报错退出
clear;
[SubjectInfo,StimulusInfo]=Information_Entry;
ID=str2double(SubjectInfo{1});% 被试编号
windowWidth=str2double(StimulusInfo{1})*2.54/sqrt(16^2+9^2)*16;% 屏幕默认为16比9，务必根据自己显示屏尺寸调整
Vdist=str2double(StimulusInfo{2});% 被试离屏幕的距离
if isnan(ID)||isnan(windowWidth)||isnan(Vdist)
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
trialeach=5;
blocks=1;
triallist=[];
for i=1:blocks
    triallist=[triallist;genTrials(trialeach,[2,2,2,9])];% 为了避免block=1时的bug
end
% 第一列1 2分别代表set size为5和9，第二列1 2分别代表notch在左还是右，
% 第三列1 2分别代表有/无声音刺激，第四列代表了9个spatial frequency水平
triallist(:,[6,7])=NaN;% 如未采集到被试信息，默认为NaN
blocktotal=trialeach*2*2*2*9;
%% 正式程序
try
    % ------------------------
    %初始化Screen和PsychPortAudio 
    % ------------------------
    black=[0,0,0];white=[255,255,255];gray=[128,128,128];% 黑白灰颜色编码
    sr=48000;% 采样频率48kHz
    latbias=64/sr;
    pahandle=PsychPortAudio('Open',3,[],2,sr);% 注意：此处第二个参数为输出设备序号，大多数电脑为3，如出现故障或报错，可输入audiodevinfo查看output序号
    prelat=PsychPortAudio('LatencyBias',pahandle,latbias);
    postlat=PsychPortAudio('LatencyBias',pahandle);% PsychPortAudio延迟信息，如延迟时间过长，可根据参考信息，换支持asio协议的声卡
    screens=Screen('Screens');
    ScreenNum=max(screens);
    [win,rect]=Screen('OpenWindow',ScreenNum,gray);
    Screen('TextFont',win,'-:lang=zh-cn');
    Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    refresh=Screen('GetFlipInterval',win);slack=refresh/2;% 获取屏幕刷新时间
    wx=rect(3);wy=rect(4);cx=wx/2;cy=wy/2;Pwidth=wx;% 获取屏幕分辨率信息
    keyescape=KbName('escape');keyLeftArrow=KbName('LeftArrow');keyRightArrow=KbName('RightArrow');
    % ------------------------
    % 以下保存了所有关于IO设备的信息
    %   AudioConditon: 结构体，内含关于声音播放设备的所有基础信息，包括sr，采样率；pahandle，播放设备的句柄
    %   ScreenConditon: 结构体, 内含关于显示器设备的所有基础信息以及部分牵涉到显示器像素转换的信息
    %                           包括win，显示器句柄；cx，cy，显示器中心位置；slack，刷新时间的一半；
    %                           windowWidth，显示器宽度；Vdist，距显示屏距离；Pwdith，显示屏横向分辨率
    % ------------------------
    AudioCondition.pahandle=pahandle;AudioCondition.sr=sr;
    ScreenCondition.win=win;ScreenCondition.cx=cx;ScreenCondition.cy=cy;
    ScreenCondition.slack=slack;ScreenCondition.Vdist=Vdist;
    ScreenCondition.Pwidth=wx;ScreenCondition.windowWidth=windowWidth;
    
    % ------------------------
    % 练习block，共15个trial
    % ------------------------
    Show_Instructions1(ScreenCondition,white);
    for i=1:15
        % ------------------------
        % 按escape键退出
        % ------------------------
        [~,~,keyCode]=KbCheck();
        if keyCode(keyescape)
            break;
        end
        
        num=randi(blocktotal);% 随机取一个条件
        halflen=deg2pix(0.25,windowWidth,Pwidth,Vdist);
        duration=1.75;durationforsound=1.5;
        % ------------------------
        % 注视点呈现1750ms
        % ------------------------
        Screen('DrawLine', win, [255,255,255], cx-halflen, cy, cx+halflen, cy, 2);
        Screen('DrawLine', win, [255,255,255], cx, cy-halflen, cx, cy+halflen, 2);
        endtime=Screen('Flip',win);
        starttime=endtime+duration;
        
        % ------------------------
        % 视听刺激
        % ------------------------
        SetSizeNum=triallist(num,1);SpatialFrequencyNum=triallist(num,4);LeftorRight=triallist(num,2);
        index=VisualStimulus(ScreenCondition,SetSizeNum,SpatialFrequencyNum,LeftorRight);
        if(triallist(num,3)==1)
            soundtime=endtime+durationforsound;
            SpatialFrequency=[0.43,0.87,1.30,1.74,2.17,2.61,3.04,3.48,3.92];
            temporalfrequency=1.8*SpatialFrequency(SpatialFrequencyNum)+1.6;
            tone=GenerateTone(AudioCondition,temporalfrequency);
            PsychPortAudio('FillBuffer',pahandle,tone);
            PsychPortAudio('Start',pahandle,0,soundtime);
        end
        endtime=Screen('Flip',win,starttime-slack);
        % ------------------------
        % 收集按键结果
        % ------------------------
        while(1)
            [~,~,keyCode]=KbCheck();
            if keyCode(keyLeftArrow)
                if LeftorRight==1
                    DrawTextAt(win,'恭喜您，正确！',cx,cy,white);
                    Screen('Flip',win);
                else
                    DrawTextAt(win,'抱歉，错误！',cx,cy,white);
                    Screen('Flip',win);
                end
                break;
            elseif keyCode(keyRightArrow)
                if LeftorRight==1
                    DrawTextAt(win,'抱歉，错误！',cx,cy,white);
                    Screen('Flip',win);
                else
                    DrawTextAt(win,'恭喜您，正确！',cx,cy,white);
                    Screen('Flip',win);                    
                end
                break;
            end
        end
        if(triallist(num,3)==1)
            PsychPortAudio('Stop',pahandle);
        end
        WaitSecs(0.8);
        Screen('Close',index);
    end
    
   
    % ------------------------
    % 正式block，每个block360个trial
    % ------------------------ 
     Show_Instructions2(ScreenCondition,white);
    for j=0:blocks-1
        for i=1:blocktotal
            % ------------------------
            % 按escape键退出
            % ------------------------        
            [~,~,keyCode]=KbCheck();
            if keyCode(keyescape)% 按escape键退出
                break;
            end
            
            num=j*blocktotal+i;
            halflen=deg2pix(0.25,windowWidth,Pwidth,Vdist);
            duration=1.75;durationforsound=1.5;
            % ------------------------
            % 注视点呈现1750ms
            % ------------------------
            Screen('DrawLine', win, [255,255,255], cx-halflen, cy, cx+halflen, cy, 2);
            Screen('DrawLine', win, [255,255,255], cx, cy-halflen, cx, cy+halflen, 2);
            endtime=Screen('Flip',win);
            starttime=endtime+duration;
            
            % ------------------------
            % 视听刺激
            % ------------------------
            SetSizeNum=triallist(num,1);SpatialFrequencyNum=triallist(num,4);LeftorRight=triallist(num,2);
            index=VisualStimulus(ScreenCondition,SetSizeNum,SpatialFrequencyNum,LeftorRight);
            if(triallist(num,3)==1)
                soundtime=endtime+durationforsound;
                SpatialFrequency=[0.43,0.87,1.30,1.74,2.17,2.61,3.04,3.48,3.92];
                temporalfrequency=1.8*SpatialFrequency(SpatialFrequencyNum)+1.6;
                tone=GenerateTone(AudioCondition,temporalfrequency);
                PsychPortAudio('FillBuffer',pahandle,tone);
                PsychPortAudio('Start',pahandle,0,soundtime);
            end   
            endtime=Screen('Flip',win,starttime-slack);
            % ------------------------
            % 收集并记录按键结果
            % ------------------------
            while(1)
                [~,secs,keyCode]=KbCheck();
                if keyCode(keyLeftArrow)
                    triallist(num,6)=1;% 按左键，记录1，表示认为notch在左
                    triallist(num,7)=secs-starttime;% 记录反应时
                    break;
                elseif keyCode(keyRightArrow)
                    triallist(num,6)=2;% 按右键，记录2，表示认为notch在右
                    triallist(num,7)=secs-starttime;% 记录反应时
                    break; 
                end
            end
            if(triallist(num,3)==1)
                PsychPortAudio('Stop',pahandle);
            end
            Screen('Close',index); 
        end
        if(j~=blocks-1)
            Show_Instructions3(ScreenCondition,white);
        end
    end
    
    % ------------------------
    % 保存数据
    % ------------------------
    if ~(exist('MyData', 'dir'))% 如不存在MyData文件夹则创建MyData文件夹
        mkdir('MyData');
    end
    cd MyData;% 进入MyData文件夹
    SpatialFrequency=[0.43,0.87,1.30,1.74,2.17,2.61,3.04,3.48,3.92];
    triallist(:,4)=SpatialFrequency(triallist(:,4));triallist(:,1)=4*triallist(:,1)+1;
    save(strcat(SubjectInfo{1},'_',datestr(datetime('now'),'yyyymmddHHMM'),'.mat'),'triallist');% 用被试编号和实验结束时间作为文件名的唯一编码
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