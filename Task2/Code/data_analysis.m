%% ��������˵��
%
% ���б��ļ�����������ȫ�������ݷ������̣�����Ԥ����������ͳ�ƣ�������飬��һ��������
% �����ϸ˵���μ�����ע�͡�
% �ο�����: Amplitude-modulated auditory stimuli influence selection of visual spatial frequencies
% ��������: Emily Orchard-Mills, Erik Van der Burg, David Alais
% ����ԭʼ����: ���, 2020/05/16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ����Ԥ����
clear
if exist('MyData', 'dir')
    cd MyData;% ����MyData�ļ���
end
load('999_202005172041.mat');
cd ..;% �����ϼ�Ŀ¼

% ��һ�� 5 9��ʾSetSize; �ڶ���1 2�ֱ����notch��������;
% ������1 2�ֱ������/�������̼��������д�����9��spatial frequencyˮƽ
% ������1 2�ֱ��ʾ���԰������ң��������Ƿ�Ӧʱ
idx=~(isnan(triallist(:,6))|isnan(triallist(:,7))); %ȥ��NaN�Դ�
data=triallist(idx,:);
SetSize=data(:,1);Soundpresence=data(:,3);SpatialFrequency=data(:,4);
RT=data(:,7);LeftorRight=data(:,6);
data(:,8)=data(:,6)==data(:,2);Correct=data(:,8);
% ------------------------
% ȥ�����󣬷�Ӧʱ����3����׼���Ӧʱ����10s���Դ�
% ------------------------
[mean,std,gname]=grpstats([RT,Correct],[SetSize,Soundpresence,SpatialFrequency],{'nanmean','nanstd','gname'});
gname=str2double(gname);summary=[gname,mean,std];
sortrows(data,[1,3,4]);idx=ones(length(data),1);
for i=1:length(data)
    setsize=data(i,1);soundpresence=data(i,3);spatialfrequency=data(i,4);
    idxx=(summary(:,1)==setsize)&(summary(:,2)==soundpresence)&(summary(:,3)==spatialfrequency);
    meanRT=summary(idxx,4);stdRT=summary(idxx,6);
    if (abs(RT(i)-meanRT)>3*stdRT)||(RT(i)>10)||(Correct(i)==0)
        idx(i)=0;
    end
end
idx=logical(idx);clean_data=data(idx,:);
Correct=clean_data(:,8);RT=clean_data(:,7);SetSize=clean_data(:,1);Soundpresence=clean_data(:,3);SpatialFrequency=clean_data(:,4);
% �Դ�ƽ��(���˽��鲻Ҫ��ô�������ݣ���Ϊ�˺�����ͬѧͳһ�����������
[mean,std,gname]=grpstats([RT,Correct],[SetSize,Soundpresence,SpatialFrequency],{'nanmean','nanstd','gname'});
gname=str2double(gname);summary_raw_data=[gname,mean,std];
%% RT������ͳ��
% ��������Ϊ���ݷ������֣����ڲ�δ�õ�����Ԥ��������ݣ�����ֱ���ù������ݣ�����ʽ�Ͼ��ж���
clear
data=xlsread('data.xlsx');
successrate=sum(data(:,6))/length(data)*10;
id=data(:,1);SetSize=data(:,2);Soundpresence=data(:,3);SpatialFrequency=data(:,4);RT=data(:,5);
[mean,std,gname]=grpstats(RT,[SetSize,Soundpresence],{'mean','std','gname'});
gname=str2double(gname);summary=[gname,mean,std];
%% RT�������
[p_all,~,~]=anovan(RT,{id,SetSize,Soundpresence,SpatialFrequency},'alpha',0.05,'model',3,'random',1,...
    'varnames',{'id','SetSize','Soundpresence','SpatialFrequency'});
% ��ÿ��spatial frequency�������������
for i=1:9
    spatialfrequency=0.5*i;
    idx=SpatialFrequency==spatialfrequency;
    [p_separated_for_spatialfrequency(:,i),~,~]=anovan(RT(idx),{id(idx),SetSize(idx),Soundpresence(idx)},'model',2,'random',1,...
        'varnames',{'id','SetSize','Soundpresence'});
end
% ��ÿ��spatial frequency��sound presence�������������
for i=1:9
    for j=1:2
        idx=(SpatialFrequency==0.5*i)&(Soundpresence==j-1);
        [p_separated_for_spatialfrequency_and_soundpresence(:,i,j),~,~]=anovan(RT(idx),{id(idx),SetSize(idx)},'alpha',0.05/18,'model',1,'random',1,...
            'varnames',{'id','SetSize'});
    end
end
%% ��Ӧʱ��ͼ
[mean,sem,gname]=grpstats(RT,[SetSize,Soundpresence],{'mean','sem','gname'});
gname=str2double(gname);summary=[gname,mean,sem];
figure
errorbar([2,3],summary([2,4],3),summary([2,4],4),'k-s','MarkerFaceColor','k','MarkerEdgeColor','k');
hold on
errorbar([2,3],summary([1,3],3),summary([1,3],4),'k-o','MarkerFaceColor','w','MarkerEdgeColor','k');
hold off
xlim([1,4]);ylim([1,3.5]);
xticks([2,3]);xticklabels({'5','9'});
xlabel('�̼�����');ylabel('��Ӧʱ(s)');
grid on;
legend({'��������','��������'});
fig=figure;
% set(gcf,'units','norm','pos',[.2 .2 .6 .45],'paperpositionmode','auto');
[mean,sem,gname]=grpstats(RT,[SetSize,Soundpresence,SpatialFrequency],{'mean','sem','gname'});
gname=str2double(gname);summary=[gname,mean,sem];
for i=1:9
    subplot(1,9,i);
    spatialfrequency=0.5*i;
    temp=summary(summary(:,3)==spatialfrequency,[1 2 4 5]);
    errorbar([2,3],temp([2,4],3),temp([2,4],4),'k-s','MarkerFaceColor','k','MarkerEdgeColor','k');
    hold on
    errorbar([2,3],temp([1,3],3),temp([1,3],4),'k-o','MarkerFaceColor','w','MarkerEdgeColor','k');
    hold off
    xlim([1.5,3.5]);ylim([1,3.5]);
    xticks([2,3]);xticklabels({'5','9'});yticks([1.0,2.0,3.0,4.0,5.0]);
    grid on;
    title(num2str(spatialfrequency));
end
han=axes(fig,'visible','off');
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'��Ӧʱ(s)');
xlabel(han,'�̼�����');
sgtitle('�Ӿ��ռ�Ƶ��(cycle per cm)');
%% ����slope
[slope,gname]=grpstats(RT,[id,Soundpresence,SpatialFrequency],{@(x) x,'gname'});
slope=abs(slope(:,2)-slope(:,1))/4;
gname=str2double(gname);slope_data=[gname,slope];
%% slope������ͳ��
id=slope_data(:,1);Soundpresence=slope_data(:,2);SpatialFrequency=slope_data(:,3);
[mean,std,gname]=grpstats(slope,[Soundpresence,SpatialFrequency],{'mean','std','gname'});
gname=str2double(gname);summary=[gname,mean,std];
%% slope ��ͼ
figure
errorbar(0.5:0.5:4.5,summary(10:18,3),summary(10:18,4),'k-s','MarkerFaceColor','k','MarkerEdgeColor','k');
hold on
errorbar(0.5:0.5:4.5,summary(1:9,3),summary(1:9,4),'k-o','MarkerFaceColor','w','MarkerEdgeColor','k');
hold off
xlim([0,5]);ylim([0.05,0.45]);
xticks([0 1 2 3 4]);
xlabel('�Ӿ��ռ�Ƶ��(cycle per cm)');ylabel('����б��(s item^{-1})');
grid on;
legend({'��������','��������'});
%% slope�������
[p_all_slope,~,stats]=anovan(slope,{id,Soundpresence,SpatialFrequency},'alpha',0.05,'model',2,'random',1,...
    'varnames',{'id','Soundpresence','SpatialFrequency'});
figure
c=multcompare(stats,'CType','bonferroni','Dimension',[2,3]);
% ��sound�������������(���˾ܾ��������ݷ�������������ͳһ)
idx=Soundpresence==1;
[p_all_slope_for_sound,~,~]=anovan(slope(idx),{id(idx),SpatialFrequency(idx)},'alpha',0.05,'model',1,'random',1,...
    'varnames',{'id','SpatialFrequency'});