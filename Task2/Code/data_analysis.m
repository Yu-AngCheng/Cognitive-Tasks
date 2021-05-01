%% 程序运行说明
%
% 运行本文件，即进行了全部的数据分析过程，包括预处理，描述性统计，假设检验，进一步分析等
% 语句详细说明参见后文注释。
% 参考文献: Amplitude-modulated auditory stimuli influence selection of visual spatial frequencies
% 文献作者: Emily Orchard-Mills, Erik Van der Burg, David Alais
% 程序原始作者: 程宇昂, 2020/05/16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 数据预处理
clear
if exist('MyData', 'dir')
    cd MyData;% 进入MyData文件夹
end
load('999_202005172041.mat');
cd ..;% 返回上级目录

% 第一列 5 9表示SetSize; 第二列1 2分别代表notch在左还是右;
% 第三列1 2分别代表有/无声音刺激，第四列代表了9个spatial frequency水平
% 第六列1 2分别表示被试按左还是右，第七列是反应时
idx=~(isnan(triallist(:,6))|isnan(triallist(:,7))); %去除NaN试次
data=triallist(idx,:);
SetSize=data(:,1);Soundpresence=data(:,3);SpatialFrequency=data(:,4);
RT=data(:,7);LeftorRight=data(:,6);
data(:,8)=data(:,6)==data(:,2);Correct=data(:,8);
% ------------------------
% 去除错误，反应时超过3个标准差，反应时超过10s的试次
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
% 试次平均(个人建议不要这么整理数据，但为了和其他同学统一，便如此整理）
[mean,std,gname]=grpstats([RT,Correct],[SetSize,Soundpresence,SpatialFrequency],{'nanmean','nanstd','gname'});
gname=str2double(gname);summary_raw_data=[gname,mean,std];
%% RT描述性统计
% 以下内容为数据分析部分，由于并未用到上述预处理的数据，而是直接用公共数据，故形式上具有断裂
clear
data=xlsread('data.xlsx');
successrate=sum(data(:,6))/length(data)*10;
id=data(:,1);SetSize=data(:,2);Soundpresence=data(:,3);SpatialFrequency=data(:,4);RT=data(:,5);
[mean,std,gname]=grpstats(RT,[SetSize,Soundpresence],{'mean','std','gname'});
gname=str2double(gname);summary=[gname,mean,std];
%% RT假设检验
[p_all,~,~]=anovan(RT,{id,SetSize,Soundpresence,SpatialFrequency},'alpha',0.05,'model',3,'random',1,...
    'varnames',{'id','SetSize','Soundpresence','SpatialFrequency'});
% 对每个spatial frequency单独做方差分析
for i=1:9
    spatialfrequency=0.5*i;
    idx=SpatialFrequency==spatialfrequency;
    [p_separated_for_spatialfrequency(:,i),~,~]=anovan(RT(idx),{id(idx),SetSize(idx),Soundpresence(idx)},'model',2,'random',1,...
        'varnames',{'id','SetSize','Soundpresence'});
end
% 对每个spatial frequency和sound presence单独做方差分析
for i=1:9
    for j=1:2
        idx=(SpatialFrequency==0.5*i)&(Soundpresence==j-1);
        [p_separated_for_spatialfrequency_and_soundpresence(:,i,j),~,~]=anovan(RT(idx),{id(idx),SetSize(idx)},'alpha',0.05/18,'model',1,'random',1,...
            'varnames',{'id','SetSize'});
    end
end
%% 反应时构图
[mean,sem,gname]=grpstats(RT,[SetSize,Soundpresence],{'mean','sem','gname'});
gname=str2double(gname);summary=[gname,mean,sem];
figure
errorbar([2,3],summary([2,4],3),summary([2,4],4),'k-s','MarkerFaceColor','k','MarkerEdgeColor','k');
hold on
errorbar([2,3],summary([1,3],3),summary([1,3],4),'k-o','MarkerFaceColor','w','MarkerEdgeColor','k');
hold off
xlim([1,4]);ylim([1,3.5]);
xticks([2,3]);xticklabels({'5','9'});
xlabel('刺激总数');ylabel('反应时(s)');
grid on;
legend({'有声条件','无声条件'});
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
ylabel(han,'反应时(s)');
xlabel(han,'刺激总数');
sgtitle('视觉空间频率(cycle per cm)');
%% 计算slope
[slope,gname]=grpstats(RT,[id,Soundpresence,SpatialFrequency],{@(x) x,'gname'});
slope=abs(slope(:,2)-slope(:,1))/4;
gname=str2double(gname);slope_data=[gname,slope];
%% slope描述性统计
id=slope_data(:,1);Soundpresence=slope_data(:,2);SpatialFrequency=slope_data(:,3);
[mean,std,gname]=grpstats(slope,[Soundpresence,SpatialFrequency],{'mean','std','gname'});
gname=str2double(gname);summary=[gname,mean,std];
%% slope 构图
figure
errorbar(0.5:0.5:4.5,summary(10:18,3),summary(10:18,4),'k-s','MarkerFaceColor','k','MarkerEdgeColor','k');
hold on
errorbar(0.5:0.5:4.5,summary(1:9,3),summary(1:9,4),'k-o','MarkerFaceColor','w','MarkerEdgeColor','k');
hold off
xlim([0,5]);ylim([0.05,0.45]);
xticks([0 1 2 3 4]);
xlabel('视觉空间频率(cycle per cm)');ylabel('搜索斜率(s item^{-1})');
grid on;
legend({'有声条件','无声条件'});
%% slope假设检验
[p_all_slope,~,stats]=anovan(slope,{id,Soundpresence,SpatialFrequency},'alpha',0.05,'model',2,'random',1,...
    'varnames',{'id','Soundpresence','SpatialFrequency'});
figure
c=multcompare(stats,'CType','bonferroni','Dimension',[2,3]);
% 对sound单独做方差分析(个人拒绝这样数据分析，但和作者统一)
idx=Soundpresence==1;
[p_all_slope_for_sound,~,~]=anovan(slope(idx),{id(idx),SpatialFrequency(idx)},'alpha',0.05,'model',1,'random',1,...
    'varnames',{'id','SpatialFrequency'});