%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  MWPT method
%
% @Guiyang, QUANJIE ZHU, 20141224
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data = importdata('example.mat')
%%%%%%%%%%%%%%%%%%%%%%%  testing    %%%%%%%%%%%%%%%
% data = noisedData;
wname = 'sym6'; % dmey, sym6
wplev = 5;
fs = 1000;
dataLen = length(data);
Wfreq = [20 100];
%aTh=0.3;
%cTh=0.3;
%%%%%%%%%%%%%%%%%%%%%  end of testing  %%%%%%%%%%%

%function newWaveData = WptDenoising_MultiThreshold(data, wname, wplev, fs, Wfreq);
% if nargin==1
%     wname = 'sym6';
%     wplev = 5;
% end

%% 对波形进行判断
[m, n] = size(data);
%dataLen
if m>n
    data = data';
else
    data = data;
end
dataLen = length(data);

%%%%%%%%%%%%%%%%%%%%%  第一部分：小波包去噪   %%%%%%%%%%%
%% 1、小波包分解
t = 1:1:dataLen;
%% 1、小波包分解
%data1 = WptDenoising(data, wname, wplev);
%s1 = data;
tree=wpdec(data,wplev,wname,'shannon');%小波包分解
wptDic = [];
for i=0:(2^wplev-1)
    ss=wprcoef(tree,[wplev,i]);%信号重构
    %nn=length(s1);
    wptDic = [wptDic; ss];
end

%% 2、多阈值去噪模式
%Wfreq = [0 120]; % 设定波形的指定频段
[m, n] = size(wptDic);
temp = 0;
bandFrq = (fs*1/2)/(2^wplev);
NewWptDic = [];
%isemptyDic = [];
for i = 1:m
    tempData = wptDic(i,:);
    % 方法一：ddencmp
    [thr, sorh, keepapp, crit] = ddencmp('den', 'wp', tempData); % 根据信号噪声强度，计算全局阈值
    % 方法二：thselect
    CriterionMatrix = [];
    FrqBandMatrix = [];
    CriterionMatrix = Wfreq(1):1:Wfreq(2); % 判断矩阵
    FrqBandMatrix = floor(bandFrq*(i-1)):1:round(bandFrq*i); % 被判断矩阵
    % 如果两个矩阵的交集为空，则表示矩阵区域内频段为非主频段；反之亦然。
    [c, ia, ib] = intersect(CriterionMatrix, FrqBandMatrix);
    %if  bandFrq*i <= Wfreq(1) |  bandFrq*(i-1) >= Wfreq(2)
    if  isempty(c) == 0
        %thr = thselect(tempData, 'minimaxi'); % minimaxi，固定阈值去噪
        thr = thselect(tempData, 'heursure'); % rigrsure,自适应阈值；heursure,启发式阈值；
    else
        thr = thselect(tempData, 'heursure'); % minimaxi，极小化极大阈值；sqtwolog，固定阈值去噪
    end
    %isemptyDic(i) = isempty(c);
    % 方法三：
    %thr3 = sqrt(2*log(dataLen*log(dataLen)/log(2)));
    % [XD,TREED,PERF0,PERFL2]=wpdencmp(X,SORH,N,'wname',CRIT,PAR,KEEPAPP)
    c2 = wpdencmp(tempData, sorh, wplev, wname, crit, thr, keepapp);
    %c2 = wpdencmp(data, 's', 5, 'sym6', 'sure', thr, 1);
    NewWptDic(i,:) = c2;
end

%if fig ==1
newWaveData = sum(NewWptDic);
[fData, faData] = FFTData(newWaveData, fs);
figure;
subplot(2,1,1);
plot(fData,faData, 'b');
subplot(2,1,2);
plot(newWaveData, 'b');
axis tight;
%end
