function Show_Instructions3(ScreenCondition,color)
% 呈现必要指导语，按空格键退出

% 可以修改DrawTextAt函数中引号的部分修改出现的文字
% 注意不要在文字前加double()的命令，DrawTextAt中已作更改

% 原始作者: 程宇昂, 2020/05/04
win=ScreenCondition.win;
slack=ScreenCondition.slack;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;

DrawTextAt(win,'休息一下！',cx,cy,color)
DrawTextAt(win,'如果您准备好了，请按空格键继续',cx,cy+80,color)
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

