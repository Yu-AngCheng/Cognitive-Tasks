function phase2=generatesequence()
% 随机化生成phase2的试次

% 返回值包括：
%   phase2: 2*340的矩阵，
%           第一行为modality，1,2,3,4分别表示standard，auditory audiovisual, visual
%           第二行为pattern序号

% 试次序列保证：1.完全相同的pattern不会连续出现，2.相同类别的deviant不会连续出现，3.4种类别出现的次数相同

% 生成方式为逐个以马尔科夫链条件独立的方式生成，限制条件为上述三点

% 原始作者: 程宇昂, 2020/05/04
flag=false;
while ~flag
    phase2(1,1)=randi(4);phase2(2,1)=randi(6);% 马尔科夫链初始状态
    N_category=[85,85,85,85];% 限制条件3，每一类别的刺激出现次数相同，均为85次
    I=[1 2 3 4];
    A=[1 2 3 4 5 6];
    N_category(phase2(1,1))=N_category(phase2(1,1))-1;
    for i=2:340
        flag=true;
        if phase2(1,i-1)==1% 如果前一个是standard，则只需在非0类别中随机选取1个类别即可
            temp=I(N_category>0);
            t=randi(length(temp));
            phase2(1,i)=temp(t);
            N_category(temp(t))=N_category(temp(t))-1;
            if sum(N_category==0)==3 && N_category(1)==0% 如果本次生成完后，只剩下一种deviant，则本次生成失败，重新开始 
                flag=false;
                break;
            end
            if phase2(1,i)==1
                temp=A(A~=phase2(2,i-1));% 前一个是standard，本次也是standard，则为满足限制条件2，pattern序号需不同
                t=randi(5);
                phase2(2,i)=temp(t);
            else
                phase2(2,i)=randi(6);% 前一个是standard，本次不是standard，则两个pattern不可能相同
            end
        else %如果前一个不是standard，即为deviant，则后一个不能是同一类别的deviant
            temp=I((I~=phase2(1,i-1))&(N_category>0));% 在除去前一个类别后，在非0类别中随机选取一个类别
            t=randi(length(temp));
            phase2(1,i)=temp(t);
            N_category(temp(t))=N_category(temp(t))-1;
            if sum(N_category==0)==3 && N_category(1)==0% 如果本次生成完后，只剩下一种deviant，则本次生成失败，重新开始 
                flag=false;
                break;
            end
            phase2(2,i)=randi(6);% 由于不为同一类别，故pattern不可能完全相同，随机选取即可
        end
    end
end
end