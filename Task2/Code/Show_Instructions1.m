function Show_Instructions1(ScreenCondition,color)
% ���ֱ�Ҫָ������ո���˳�

% �����޸�DrawTextAt���������ŵĲ����޸ĳ��ֵ�����
% ע�ⲻҪ������ǰ��double()�����DrawTextAt����������

% ԭʼ����: ���, 2020/05/04
win=ScreenCondition.win;
slack=ScreenCondition.slack;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;

DrawTextAt(win,'�ڽ�����ʵ���У���Ļ�Ͻ������һЩ��ͬ�ռ�Ƶ�ʵĺڰ״̼�',cx,cy-160,color)
DrawTextAt(win,'ÿ���ڰ״̼�����Χ��һ����ɫ�Ļ���������ȱ��',cx,cy-80,color);
DrawTextAt(win,'���ҽ���һ��ȱ����ˮƽ������ҵģ������ҳ����ڼ�������Ӧ�����Ҽ�ͷ��',cx,cy,color)
DrawTextAt(win,'ͬʱ������������һЩ��������Щ������Ƶ���Ǻͺڰ״̼��Ŀռ�Ƶ����ƥ���',cx,cy+80,color)
DrawTextAt(win,'�������ȫ�̶���ע�ӵ㡣����������ϰ��׼�����˾Ͱ��ո����ʼ',cx,cy+160,color)

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

