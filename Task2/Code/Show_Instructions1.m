function Show_Instructions1(ScreenCondition,color)
% 呈现必要指导语，按空格键退出

% 可以修改DrawTextAt函数中引号的部分修改出现的文字
% 注意不要在文字前加double()的命令，DrawTextAt中已作更改

% 原始作者: 程宇昂, 2020/05/04
win=ScreenCondition.win;
slack=ScreenCondition.slack;
cx=ScreenCondition.cx;
cy=ScreenCondition.cy;

DrawTextAt(win,'在接下来实验中，屏幕上将会出现一些不同空间频率的黑白刺激',cx,cy-160,color)
DrawTextAt(win,'每个黑白刺激的周围有一个白色的环，环上有缺口',cx,cy-80,color);
DrawTextAt(win,'有且仅有一个缺口是水平朝左或朝右的，请您找出并在键盘上相应按左右箭头键',cx,cy,color)
DrawTextAt(win,'同时，您还会听到一些声音，这些声音的频率是和黑白刺激的空间频率相匹配的',cx,cy+80,color)
DrawTextAt(win,'请您务必全程盯着注视点。接下来是练习，准备好了就按空格键开始',cx,cy+160,color)

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

