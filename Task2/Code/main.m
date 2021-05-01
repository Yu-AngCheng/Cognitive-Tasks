%% ��������˵��
%
% ���б��ļ���������ʵ���������ʱ���Կ��٣�����������
% �����˳����볤��escape����Ϊ���־��ȣ���¼����ʱ�˳���Ч���ʽ���ͬʱ�������escape�����˳�)
% ѵ���׶�����PTB���������ӳ٣���ʽʵ�鲻�ܴ�Ӱ��
% �����ϸ˵���μ�����ע�͡�
% �ο�����: Amplitude-modulated auditory stimuli influence selection of visual spatial frequencies
% ��������: Emily Orchard-Mills, Erik Van der Burg, David Alais
% ����ԭʼ����: ���, 2020/05/16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��Ϣ¼��
%�������Ը�����Ϣ����ʾ����Ϣ��������ȷ���룬�������ֱ�ӱ����˳�
clear;
[SubjectInfo,StimulusInfo]=Information_Entry;
ID=str2double(SubjectInfo{1});% ���Ա��
windowWidth=str2double(StimulusInfo{1})*2.54/sqrt(16^2+9^2)*16;% ��ĻĬ��Ϊ16��9����ظ����Լ���ʾ���ߴ����
Vdist=str2double(StimulusInfo{2});% ��������Ļ�ľ���
if isnan(ID)||isnan(windowWidth)||isnan(Vdist)
    error('������Ϣ�������!');
end
%% ��ʼ�� 
KbName('UnifyKeyNames');
Screen('Preference','SkipSyncTests',1);% �˳�ͬ���Բ��ԣ����ڵ���ʱʹ�ã���ʽʵ����ע�͡������ͬ���Բ����������ȵ���Ӳ����ʩ
Screen('Preference','TextEncodingLocale','UTF-8');
AssertOpenGL;
InitializePsychSound(1);
ListenChar(2);% �������̣��������򱨴��˳�����ּ���������Ч�����԰�Ctrl+C�˳�����
HideCursor;
%% ������Դ�
rng shuffle
trialeach=5;
blocks=1;
triallist=[];
for i=1:blocks
    triallist=[triallist;genTrials(trialeach,[2,2,2,9])];% Ϊ�˱���block=1ʱ��bug
end
% ��һ��1 2�ֱ����set sizeΪ5��9���ڶ���1 2�ֱ����notch�������ң�
% ������1 2�ֱ������/�������̼��������д�����9��spatial frequencyˮƽ
triallist(:,[6,7])=NaN;% ��δ�ɼ���������Ϣ��Ĭ��ΪNaN
blocktotal=trialeach*2*2*2*9;
%% ��ʽ����
try
    % ------------------------
    %��ʼ��Screen��PsychPortAudio 
    % ------------------------
    black=[0,0,0];white=[255,255,255];gray=[128,128,128];% �ڰ׻���ɫ����
    sr=48000;% ����Ƶ��48kHz
    latbias=64/sr;
    pahandle=PsychPortAudio('Open',3,[],2,sr);% ע�⣺�˴��ڶ�������Ϊ����豸��ţ����������Ϊ3������ֹ��ϻ򱨴�������audiodevinfo�鿴output���
    prelat=PsychPortAudio('LatencyBias',pahandle,latbias);
    postlat=PsychPortAudio('LatencyBias',pahandle);% PsychPortAudio�ӳ���Ϣ�����ӳ�ʱ��������ɸ��ݲο���Ϣ����֧��asioЭ�������
    screens=Screen('Screens');
    ScreenNum=max(screens);
    [win,rect]=Screen('OpenWindow',ScreenNum,gray);
    Screen('TextFont',win,'-:lang=zh-cn');
    Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    refresh=Screen('GetFlipInterval',win);slack=refresh/2;% ��ȡ��Ļˢ��ʱ��
    wx=rect(3);wy=rect(4);cx=wx/2;cy=wy/2;Pwidth=wx;% ��ȡ��Ļ�ֱ�����Ϣ
    keyescape=KbName('escape');keyLeftArrow=KbName('LeftArrow');keyRightArrow=KbName('RightArrow');
    % ------------------------
    % ���±��������й���IO�豸����Ϣ
    %   AudioConditon: �ṹ�壬�ں��������������豸�����л�����Ϣ������sr�������ʣ�pahandle�������豸�ľ��
    %   ScreenConditon: �ṹ��, �ں�������ʾ���豸�����л�����Ϣ�Լ�����ǣ�浽��ʾ������ת������Ϣ
    %                           ����win����ʾ�������cx��cy����ʾ������λ�ã�slack��ˢ��ʱ���һ�룻
    %                           windowWidth����ʾ����ȣ�Vdist������ʾ�����룻Pwdith����ʾ������ֱ���
    % ------------------------
    AudioCondition.pahandle=pahandle;AudioCondition.sr=sr;
    ScreenCondition.win=win;ScreenCondition.cx=cx;ScreenCondition.cy=cy;
    ScreenCondition.slack=slack;ScreenCondition.Vdist=Vdist;
    ScreenCondition.Pwidth=wx;ScreenCondition.windowWidth=windowWidth;
    
    % ------------------------
    % ��ϰblock����15��trial
    % ------------------------
    Show_Instructions1(ScreenCondition,white);
    for i=1:15
        % ------------------------
        % ��escape���˳�
        % ------------------------
        [~,~,keyCode]=KbCheck();
        if keyCode(keyescape)
            break;
        end
        
        num=randi(blocktotal);% ���ȡһ������
        halflen=deg2pix(0.25,windowWidth,Pwidth,Vdist);
        duration=1.75;durationforsound=1.5;
        % ------------------------
        % ע�ӵ����1750ms
        % ------------------------
        Screen('DrawLine', win, [255,255,255], cx-halflen, cy, cx+halflen, cy, 2);
        Screen('DrawLine', win, [255,255,255], cx, cy-halflen, cx, cy+halflen, 2);
        endtime=Screen('Flip',win);
        starttime=endtime+duration;
        
        % ------------------------
        % �����̼�
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
        % �ռ��������
        % ------------------------
        while(1)
            [~,~,keyCode]=KbCheck();
            if keyCode(keyLeftArrow)
                if LeftorRight==1
                    DrawTextAt(win,'��ϲ������ȷ��',cx,cy,white);
                    Screen('Flip',win);
                else
                    DrawTextAt(win,'��Ǹ������',cx,cy,white);
                    Screen('Flip',win);
                end
                break;
            elseif keyCode(keyRightArrow)
                if LeftorRight==1
                    DrawTextAt(win,'��Ǹ������',cx,cy,white);
                    Screen('Flip',win);
                else
                    DrawTextAt(win,'��ϲ������ȷ��',cx,cy,white);
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
    % ��ʽblock��ÿ��block360��trial
    % ------------------------ 
     Show_Instructions2(ScreenCondition,white);
    for j=0:blocks-1
        for i=1:blocktotal
            % ------------------------
            % ��escape���˳�
            % ------------------------        
            [~,~,keyCode]=KbCheck();
            if keyCode(keyescape)% ��escape���˳�
                break;
            end
            
            num=j*blocktotal+i;
            halflen=deg2pix(0.25,windowWidth,Pwidth,Vdist);
            duration=1.75;durationforsound=1.5;
            % ------------------------
            % ע�ӵ����1750ms
            % ------------------------
            Screen('DrawLine', win, [255,255,255], cx-halflen, cy, cx+halflen, cy, 2);
            Screen('DrawLine', win, [255,255,255], cx, cy-halflen, cx, cy+halflen, 2);
            endtime=Screen('Flip',win);
            starttime=endtime+duration;
            
            % ------------------------
            % �����̼�
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
            % �ռ�����¼�������
            % ------------------------
            while(1)
                [~,secs,keyCode]=KbCheck();
                if keyCode(keyLeftArrow)
                    triallist(num,6)=1;% ���������¼1����ʾ��Ϊnotch����
                    triallist(num,7)=secs-starttime;% ��¼��Ӧʱ
                    break;
                elseif keyCode(keyRightArrow)
                    triallist(num,6)=2;% ���Ҽ�����¼2����ʾ��Ϊnotch����
                    triallist(num,7)=secs-starttime;% ��¼��Ӧʱ
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
    % ��������
    % ------------------------
    if ~(exist('MyData', 'dir'))% �粻����MyData�ļ����򴴽�MyData�ļ���
        mkdir('MyData');
    end
    cd MyData;% ����MyData�ļ���
    SpatialFrequency=[0.43,0.87,1.30,1.74,2.17,2.61,3.04,3.48,3.92];
    triallist(:,4)=SpatialFrequency(triallist(:,4));triallist(:,1)=4*triallist(:,1)+1;
    save(strcat(SubjectInfo{1},'_',datestr(datetime('now'),'yyyymmddHHMM'),'.mat'),'triallist');% �ñ��Ա�ź�ʵ�����ʱ����Ϊ�ļ�����Ψһ����
    cd ..;% �����ϼ�Ŀ¼
    
    % ------------------------
    % �����˳�
    % ------------------------
    PsychPortAudio('Close',pahandle);
    sca;
    ListenChar(0);
    ShowCursor;
catch ME %������쳣���󣬴˴������˳�
    sca;
    PsychPortAudio('Close');
    ListenChar(0);
    ShowCursor;
    rethrow(ME);
end