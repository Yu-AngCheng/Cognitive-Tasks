%% ��������˵��
%
% ���б��ļ���������ʵ���������ʱ���Կ��٣�����������
% �����˳����볤��escape����Ϊ���־��ȣ���¼����ʱ��Ч���ʽ���ͬʱ��z����escape�����˳�)
% �����ϸ˵���μ�����ע�͡�
% �ο�����: Statistical learning of multisensory regularities is enhanced in musicians: An MEG study
% ��������: Paraskevopoulos et.al(2018)
% ����ԭʼ����: ���, 2020/05/04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��Ϣ¼��
%�������Ը�����Ϣ����ʾ����Ϣ��������ȷ���룬�������ֱ�ӱ����˳�
clear;
[SubjectInfo,StimulusInfo]=Information_Entry;
ID=str2double(SubjectInfo{1});
Inch=str2double(StimulusInfo{1});
Vdist=str2double(StimulusInfo{2});
if isnan(ID)||isnan(Inch)||isnan(Vdist)
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
traillist=genTrials(1,[3,6,2]);% ��һ��1 2 3�ֱ����auditory,audiovisual,visual deviants���ڶ�����pattern����ţ�������Ϊ1��ʾstandard�ȳ��֣�2��ʾstandard�����
traillist(:,4)=NaN;% ��δ�ɼ���������Ϣ��Ĭ��ΪNaN
total=36;
phase1=[ones(1,70);mod(randperm(70),6)+1];% α�����ȷ��ÿ��pattern�������
sequence=phase1;
runs=3;
for i=1:runs
    phase2=generatesequence();%α�������phase2���У����generatesequence
    sequence=[sequence,phase2];
end
%% ��ʽ����
try
    % ------------------------
    %��ʼ��Screen��PsychPortAudio
    % ------------------------
    sr=48000;% ����Ƶ��48kHz
    latbias=64/sr;
    pahandle=PsychPortAudio('Open',3,[],2,sr);% ע�⣺�˴�����������Ϊ����豸��ţ����������Ϊ3������ֹ��ϻ򱨴�������audiodevinfo�鿴output���
    prelat=PsychPortAudio('LatencyBias',pahandle,latbias);
    postlat=PsychPortAudio('LatencyBias',pahandle);% PsychPortAudio�ӳ���Ϣ�����ӳ�ʱ��������ɸ��ݲο���Ϣ����֧��asioЭ�������
    screens=Screen('Screens');
    ScreenNum=max(screens);
    [win,rect]=Screen('OpenWindow',ScreenNum);
    Screen('TextFont',win,'-:lang=zh-cn');
    Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    refresh=Screen('GetFlipInterval',win);slack=refresh/2;% ��ȡ��Ļˢ��ʱ��
    wx=rect(3);wy=rect(4);cx=wx/2;cy=wy/2;% ��ȡ��Ļ�ֱ�����Ϣ
    black=[0,0,0];white=[255,255,255];
    keyescape=KbName('escape');
    keyz=KbName('z');
    keym=KbName('m');
    % ------------------------
    % ���±��������й���IO�豸����Ϣ
    %   AudioConditon: �ṹ�壬�ں��������������豸�����л�����Ϣ������sr�������ʣ�pahandle�������豸�ľ��
    %   ScreenConditon: �ṹ��, �ں�������ʾ���豸�����л�����Ϣ�Լ�����ǣ�浽��ʾ������ת������Ϣ
    %                           ����win����ʾ�������cx��cy����ʾ������λ�ã�slack��ˢ��ʱ���һ�룻
    %                           Inch����ʾ���ߴ磻Vdist������ʾ�����룻Pwdith����ʾ������ֱ���
    % ------------------------
    AudioCondition.pahandle=pahandle;AudioCondition.sr=sr;
    ScreenCondition.win=win;ScreenCondition.cx=cx;ScreenCondition.cy=cy;
    ScreenCondition.slack=slack;ScreenCondition.Inch=Inch;
    ScreenCondition.Vdist=Vdist;ScreenCondition.Pwidth=wx;
    Screen('FillRect',win,black);
    
    % ------------------------
    % ����ָ����
    % ------------------------
    Show_Instructions1(ScreenCondition,white);
    
    % ------------------------
    % phase 1 & phase 2��ֻ���ִ̼�����Ҫ���Է�Ӧ
    % phase1: 115.5s + phase2: 3*561s
    % ����ʱ30min
    % ------------------------
    starttime=GetSecs();
    ISI=0.15;% pattern֮����150ms
    for i=1:length(sequence)% ����������Դε�˳�����γ���pattern
        [~,~,keyCode]=KbCheck();
        if keyCode(keyescape)% ��escape���˳�
            break;
        end
        category=sequence(1,i);number=sequence(2,i);
        endtime=Pattern(AudioCondition,ScreenCondition,starttime,category,number);% ���Pattern
        starttime=endtime+ISI;
    end
    WaitSecs(1);% ���1s����phase3(�粻��Ҫ����ע��)��ע��phase 1��phase 2֮���޼��
    
    
    % ------------------------
    % phase 3���ʱ��Ϊ226.8s
    % ------------------------
    Show_Instructions2(ScreenCondition,white);% ����ָ����
    ISI=0.30;% pattern֮����300ms
    blank=3.0;% ���Է�Ӧʱ��3s
    
    for i=1:total
        
        % ------------------------
        % ����standard��deviant
        % ------------------------
        [~,~,keyCode]=KbCheck();
        if keyCode(keyescape)% ��escape���˳�
            break;
        end
        category=traillist(i,1)+1;% ����1,2,3�ֱ��Ӧauditory,audiovisual,visual deviants����category 2,3,4
        number=traillist(i,2);
        starttime=GetSecs();
        if(traillist(i,3)==1)% ����������Ϊ1���ȳ���standard
            endtime=Pattern(AudioCondition,ScreenCondition,starttime,1,number);
            starttime=endtime+ISI;
            endtime=Pattern(AudioCondition,ScreenCondition,starttime,category,number);
        elseif(traillist(i,3)==2)% ����������Ϊ2�������standard
            endtime=Pattern(AudioCondition,ScreenCondition,starttime,category,number);
            starttime=endtime+ISI;
            endtime=Pattern(AudioCondition,ScreenCondition,starttime,1,number);
        end
        
        % ------------------------
        % ���ְ�����ʾ���ռ��������
        % ------------------------
        DrawTextAt(win,'ǰһ����϶�������Ϥ���밴z',cx,cy-30,white);
        DrawTextAt(win,'��һ����϶�������Ϥ���밴m',cx,cy+30,white);
        Screen('Flip',win);
        while((GetSecs()-endtime)<=blank)
            [~,~,keyCode]=KbCheck();
            if keyCode(keyz)
                traillist(i,4)=1;% ��z��¼Ϊ1����ʾǰһ������Ϥ
                break;
            elseif keyCode(keym)
                traillist(i,4)=0;% ��m��¼Ϊ2����ʾ��һ������Ϥ
                break;
            end
        end
        
    end
    
    % ------------------------
    % ��������
    % ------------------------
    if ~(exist('MyData', 'dir'))% �粻����MyData�ļ����򴴽�MyData�ļ���
        mkdir('MyData');
    end
    cd MyData;% ����MyData�ļ���
    save(strcat(SubjectInfo{1},'_',datestr(datetime('now'),'yyyymmddHHMM'),'.mat'),'traillist');% �ñ��Ա�ź�ʵ�����ʱ����Ϊ�ļ�����Ψһ����
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