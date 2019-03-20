%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                 RickerSignalGen
%
%  所含模块及过程包括:
%   1、输入频率等参数，直接生成雷克子波；
%   2、根据需要添加背景噪声（白噪）。
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% @参考文献：
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% USAGE:
%        [OriData, noisedData, noise] = RickerWavelet(sampleLen, fs, fm, ap, no, fig);
%
% 函数含义：
%   (1) inputData
%       sampleLen = 500;  % 波形时间长度（采样点数）
%       fs = 1000; % 波形的采样频率，Hz
%       fm = 235;  % 信号的主频（中心频率），Hz
%       fig = 1;   % 是否画图，0为否，1为是
%       ap = 0.7;  % 设定子波峰值位置
%       no = -20;    % 加入白噪，单位db，wgn函数的参数
%       [waveData, noisedData] = RickerWavelet(sampleLen, fs, fm, ap, no, fig);
%
%   (2) outputData
%       waveData为原始波形，干净信号
%       noisedData为含背景噪声的波形，污染信号
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% @Yanjiao, QUANJIE ZHU, 20170807
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [OriData, noisedData, noise] = RickerWavelet(sampleLen, fs, fm, ap, no, fig);

%% 0、判断参数是否满足
if nargin<1
    error('输入参数不能少于1个！');
    sampleLen = 1000;
    fs = 1000;
end



%% 1、构造雷克子波
aLoc = round(sampleLen*ap); % 峰值所处位置
dt = 1/fs; % 时间间隔，正常为：dt = 1/fs
tDic = (-aLoc+1):1:(sampleLen-aLoc); %X轴序列
yDic = (1-2*(pi*fm*tDic*dt).^2).*exp(-(pi*fm*tDic*dt).^2);

%for i = 1:sampleLen
%	yDic(i)=exp((-4*pi^2*fm^2/r^2)*i^2*dt^2)*cos(2*pi*f*i*dt); 
%end
% 其中子波中心频率fm=25HZ，子波宽度r=4，子波周期为1/f=0.04s，对应图中40位置，即t=40*1.001=0.04s。能量聚集在首部，开始时就具有最大能量，无积累过程。

%% 2、对x轴校正
newtDic = 1:1:sampleLen;

%注：时间域采样间隔为0.001s，采样点数为2000点，总的时间长度为2s，则频率域采样间隔为0.5hz。

for i=1:sampleLen
    frq(i)=fs/sampleLen*(i-1);%计算频率
    %frq(i)=0.5*(i-1);%计算频率
end
Y=abs(fft(yDic));%fourier变换，取振幅谱

%% 3、组建数据
OriData = yDic;
noise = wgn(1, sampleLen, no); % 产生一个m行n列的高斯白噪声的矩阵，p以dBW为单位指定输出噪声的强度。 
noisedData = OriData + noise;
%noisedData = awgn(waveData, no);
Y2=abs(fft(noisedData));%fourier变换，取振幅谱

%% 5、判断是否绘图
if fig == 1
    figure;
    subplot(4,1,1);
    plot(newtDic,yDic);
    title('Ricker');
    xlabel('时间t（ms）');
    ylabel('幅值A');
    hold on;

    subplot(4,1,2)
    plot(frq,Y);
    title('Ricker子波的振幅谱');
    xlabel('频率f（hz）');
    ylabel('振幅谱');
    hold on;  

    subplot(4,1,3);    
    plot(newtDic,noisedData);
    title('Ricker + Noise');
    xlabel('时间t（ms）');
    ylabel('幅值A');
    hold on;

    subplot(4,1,4)
    plot(frq,Y2);
    title('Ricker+Noise的振幅谱');
    xlabel('频率f（hz）');
    ylabel('振幅谱');
else
    disp('不绘图！');
end
