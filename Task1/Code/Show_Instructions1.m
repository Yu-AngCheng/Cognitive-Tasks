function Show_Instructions1(ScreenCondition,color)
% ���ֱ�Ҫָ������ո���˳�

% �����޸�DrawTextAt���������ŵĲ����޸ĳ��ֵ�����
% ע�ⲻҪ������ǰ��double()�����DrawTextAt����������

% ԭʼ����: ���, 2020/05/04
win=ScreenCondition.win;
slack=ScreenCondition.slack;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;

DrawTextAt(win,'���ã���ӭ�μ�ʵ�飡',cx,cy-160,color)
DrawTextAt(win,'�ڽ�����ʵ���У���Ļ�Ͻ������һЩ��ͬ��ɫ��ͼ��',cx,cy-80,color);
DrawTextAt(win,'����ͼ�����ֵ�ͬʱ�����Ქ��һЩ����',cx,cy,color)
DrawTextAt(win,'��ֻ�輯��ע��ؿ�����',cx,cy+80',color)
DrawTextAt(win,'�����׼�����ˣ����ո����ʼʵ��',cx,cy+160,color)

Screen('Flip',win);
keyspace=KbName('space');
keyescape=KbName('escape');
while 1
    [~,~,keyCode]=KbCheck();
    if keyCode(keyspace)||keyCode(keyescape)
        break;
    end
end
end

