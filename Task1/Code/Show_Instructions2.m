function Show_Instructions2(ScreenCondition,color)
% 呈现必要指导语，按空格键退出

% 可以修改DrawTextAt函数中引号的部分修改出现的文字
% 注意不要在文字前加double()的命令，DrawTextAt中已作更改

% 原始作者: 程宇昂, 2020/05/04
win=ScreenCondition.win;
slack=ScreenCondition.slack;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;

DrawTextAt(win,'很抱歉没有通知您，接下来是一个测试。',cx,cy-160,color)
DrawTextAt(win,'屏幕上将依次出现两组刺激，每组刺激包括三个图案和三个声音',cx,cy-80,color);
DrawTextAt(win,'如果您认为前一个组合对您更熟悉，请按z，否则请按m',cx,cy,color)
DrawTextAt(win,'如果您认为差不多，按您第一感觉尽管按键即可，不必犹豫',cx,cy+80',color)
DrawTextAt(win,'请您按空格键开始',cx,cy+160,color)
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

