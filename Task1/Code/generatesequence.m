function phase2=generatesequence()
% ���������phase2���Դ�

% ����ֵ������
%   phase2: 2*340�ľ���
%           ��һ��Ϊmodality��1,2,3,4�ֱ��ʾstandard��auditory audiovisual, visual
%           �ڶ���Ϊpattern���

% �Դ����б�֤��1.��ȫ��ͬ��pattern�����������֣�2.��ͬ����deviant�����������֣�3.4�������ֵĴ�����ͬ

% ���ɷ�ʽΪ���������Ʒ������������ķ�ʽ���ɣ���������Ϊ��������

% ԭʼ����: ���, 2020/05/04
flag=false;
while ~flag
    phase2(1,1)=randi(4);phase2(2,1)=randi(6);% ����Ʒ�����ʼ״̬
    N_category=[85,85,85,85];% ��������3��ÿһ���Ĵ̼����ִ�����ͬ����Ϊ85��
    I=[1 2 3 4];
    A=[1 2 3 4 5 6];
    N_category(phase2(1,1))=N_category(phase2(1,1))-1;
    for i=2:340
        flag=true;
        if phase2(1,i-1)==1% ���ǰһ����standard����ֻ���ڷ�0��������ѡȡ1����𼴿�
            temp=I(N_category>0);
            t=randi(length(temp));
            phase2(1,i)=temp(t);
            N_category(temp(t))=N_category(temp(t))-1;
            if sum(N_category==0)==3 && N_category(1)==0% ��������������ֻʣ��һ��deviant���򱾴�����ʧ�ܣ����¿�ʼ 
                flag=false;
                break;
            end
            if phase2(1,i)==1
                temp=A(A~=phase2(2,i-1));% ǰһ����standard������Ҳ��standard����Ϊ������������2��pattern����費ͬ
                t=randi(5);
                phase2(2,i)=temp(t);
            else
                phase2(2,i)=randi(6);% ǰһ����standard�����β���standard��������pattern��������ͬ
            end
        else %���ǰһ������standard����Ϊdeviant�����һ��������ͬһ����deviant
            temp=I((I~=phase2(1,i-1))&(N_category>0));% �ڳ�ȥǰһ�������ڷ�0��������ѡȡһ�����
            t=randi(length(temp));
            phase2(1,i)=temp(t);
            N_category(temp(t))=N_category(temp(t))-1;
            if sum(N_category==0)==3 && N_category(1)==0% ��������������ֻʣ��һ��deviant���򱾴�����ʧ�ܣ����¿�ʼ 
                flag=false;
                break;
            end
            phase2(2,i)=randi(6);% ���ڲ�Ϊͬһ��𣬹�pattern��������ȫ��ͬ�����ѡȡ����
        end
    end
end
end