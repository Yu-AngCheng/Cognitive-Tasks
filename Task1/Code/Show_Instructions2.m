function Show_Instructions2(ScreenCondition,color)
% ���ֱ�Ҫָ������ո���˳�

% �����޸�DrawTextAt���������ŵĲ����޸ĳ��ֵ�����
% ע�ⲻҪ������ǰ��double()�����DrawTextAt����������

% ԭʼ����: ���, 2020/05/04
win=ScreenCondition.win;
slack=ScreenCondition.slack;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;

DrawTextAt(win,'�ܱ�Ǹû��֪ͨ������������һ�����ԡ�',cx,cy-160,color)
DrawTextAt(win,'��Ļ�Ͻ����γ�������̼���ÿ��̼���������ͼ������������',cx,cy-80,color);
DrawTextAt(win,'�������Ϊǰһ����϶�������Ϥ���밴z�������밴m',cx,cy,color)
DrawTextAt(win,'�������Ϊ��࣬������һ�о����ܰ������ɣ�������ԥ',cx,cy+80',color)
DrawTextAt(win,'�������ո����ʼ',cx,cy+160,color)
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

