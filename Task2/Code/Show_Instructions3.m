function Show_Instructions3(ScreenCondition,color)
% ���ֱ�Ҫָ������ո���˳�

% �����޸�DrawTextAt���������ŵĲ����޸ĳ��ֵ�����
% ע�ⲻҪ������ǰ��double()�����DrawTextAt����������

% ԭʼ����: ���, 2020/05/04
win=ScreenCondition.win;
slack=ScreenCondition.slack;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;

DrawTextAt(win,'��Ϣһ�£�',cx,cy,color)
DrawTextAt(win,'�����׼�����ˣ��밴�ո������',cx,cy+80,color)
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

