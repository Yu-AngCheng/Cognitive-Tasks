function DrawTextAt(win,str,x,y,color)
% ����Ļ�������
width=Screen('TextBounds',win,double(str));
Screen('DrawText',win,double(str),x-width(3)/2,y-width(4)/2,color);
end

