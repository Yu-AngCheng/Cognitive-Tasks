function DrawTextAt(win,str,x,y,color)
% 在屏幕中央呈现
width=Screen('TextBounds',win,double(str));
Screen('DrawText',win,double(str),x-width(3)/2,y-width(4)/2,color);
end

