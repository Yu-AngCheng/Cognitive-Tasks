function Show_Instructions2(ScreenCondition,color)
% ���ֱ�Ҫָ������ո���˳�

% �����޸�DrawTextAt���������ŵĲ����޸ĳ��ֵ�����
% ע�ⲻҪ������ǰ��double()�����DrawTextAt����������

% ԭʼ����: ���, 2020/05/04
win=ScreenCondition.win;
slack=ScreenCondition.slack;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;

DrawTextAt(win,'����������ʽʵ�飬�������о����ֿ���׼�ķ�Ӧ',cx,cy-80,color);
DrawTextAt(win,'��ע�⣬��������ʵ���н�û����ȷ�����ķ���',cx,cy,color)
DrawTextAt(win,'�������ȫ�̶���ע�ӵ㡣�����׼�����ˣ��밴�ո������',cx,cy+80,color)
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

