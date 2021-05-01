function Show_Instructions2(ScreenCondition,color)
% 呈现必要指导语，按空格键退出

% 可以修改DrawTextAt函数中引号的部分修改出现的文字
% 注意不要在文字前加double()的命令，DrawTextAt中已作更改

% 原始作者: 程宇昂, 2020/05/04
win=ScreenCondition.win;
slack=ScreenCondition.slack;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;

DrawTextAt(win,'接下来是正式实验，请您集中精力又快又准的反应',cx,cy-80,color);
DrawTextAt(win,'请注意，接下来的实验中将没有正确或错误的反馈',cx,cy,color)
DrawTextAt(win,'请您务必全程盯着注视点。如果您准备好了，请按空格键继续',cx,cy+80,color)
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

