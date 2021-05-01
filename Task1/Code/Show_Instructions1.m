function Show_Instructions1(ScreenCondition,color)
% 呈现必要指导语，按空格键退出

% 可以修改DrawTextAt函数中引号的部分修改出现的文字
% 注意不要在文字前加double()的命令，DrawTextAt中已作更改

% 原始作者: 程宇昂, 2020/05/04
win=ScreenCondition.win;
slack=ScreenCondition.slack;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;

DrawTextAt(win,'您好，欢迎参加实验！',cx,cy-160,color)
DrawTextAt(win,'在接下来实验中，屏幕上将会呈现一些不同颜色的图案',cx,cy-80,color);
DrawTextAt(win,'伴随图案出现的同时，还会播放一些声音',cx,cy,color)
DrawTextAt(win,'您只需集中注意地看和听',cx,cy+80',color)
DrawTextAt(win,'如果您准备好了，按空格键开始实验',cx,cy+160,color)

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

