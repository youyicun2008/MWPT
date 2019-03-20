
%% 基础参数输入
sampleLen = 1000;  % 波形时间长度（采样点数）
fs = 1000; % 波形的采样频率，Hz
fm = 75;  % 信号的主频（中心频率），Hz
fig = 0;   % 是否画图，0为否，1为是
ap = 0.7;  % 设定子波峰值位置
no = -25;    % 加入白噪，单位db，wgn函数的参数
timeDic = 1000*(0:1/fs:1/fs*(sampleLen-1)); % 转化到ms
%% 生成雷克子波
[OriData, noisedData, noise] = RickerWavelet(sampleLen, fs, fm, ap, no, fig);
waveData = OriData;
%% 计算功率谱
N = length(waveData);%数据长度
%i = 0:N-1;
%t = i/fs;
f = (0:N-1)*fs/N;%横坐标频率的表达式为f=(0:M-1)*Fs/M;??
% 1、原始数据计算
%f=100;%设定正弦信号频率?%生成正弦信号?
waveData2 = fft(waveData,N);%进行fft变换?
mag = abs(waveData2);%求幅值?
%f = (0:N-1)*fs/N;%横坐标频率的表达式为f=(0:M-1)*Fs/M;??
Opower = mag.^2;
% 2、含噪声数据计算
%f=100;%设定正弦信号频率?%生成正弦信号?
noisedData2 = fft(noisedData,N);%进行fft变换?
mag = abs(noisedData2);%求幅值?
%f = (0:N-1)*fs/N;%横坐标频率的表达式为f=(0:M-1)*Fs/M;??
NDpower = mag.^2;
% 3、仅噪声数据计算
%f=100;%设定正弦信号频率?%生成正弦信号?
noise2 = fft(noise,N);%进行fft变换?
mag = abs(noise2);%求幅值?
%f = (0:N-1)*fs/N;%横坐标频率的表达式为f=(0:M-1)*Fs/M;??
Npower = mag.^2;

%% 绘图
h = figure;
titleStr = ['fs = ' num2str(fs) ',' 'fm=' num2str(fm) ',' 'no=' num2str(no), 'sampleLen = ' num2str(sampleLen) ];
suptitle(titleStr);
%set(h,'name','Haar小波变换','Numbertitle','off')
subplot(3,2,1);
plot(timeDic,waveData);
title('Ricker wavelet');xlabel('Time /ms');ylabel('Amplitude /mV');
hold on;
box on;
set(gcf, 'color', 'w');
set(gca, 'FontName', 'Times New Roman');
xlim([1 N]);
subplot(3,2,2);
plot(f(1:length(f)/2), Opower(1:length(f)/2));
title('Ricker wavelet spectrum');
xlabel('Frequency /Hz');
ylabel('Amplitude');
hold on;
box on;xlim([1 fs/2]);
set(gcf, 'color', 'w');
set(gca, 'FontName', 'Times New Roman');

% 含噪声信号
subplot(3,2,3);
plot(timeDic,noisedData);
title('Noise Ricker wavelet');xlabel('Time /ms');ylabel('Amplitude /mV');
hold on;
box on;
set(gcf, 'color', 'w');
set(gca, 'FontName', 'Times New Roman');
xlim([1 N]);
subplot(3,2,4);
plot(f(1:length(f)/2), NDpower(1:length(f)/2));
title('Noise Ricker wavelet');
xlabel('Frequency /Hz');
ylabel('Amplitude');
hold on;
box on;xlim([1 fs/2]);
set(gcf, 'color', 'w');
set(gca, 'FontName', 'Times New Roman');

% 噪声
subplot(3,2,5);
plot(timeDic,noise);
title('Noise');xlabel('Time /ms');ylabel('Amplitude /mV');
hold on;
%grid on;
box on;
set(gcf, 'color', 'w');
set(gca, 'FontName', 'Times New Roman');
xlim([1 N]);
subplot(3,2,6);
plot(f(1:length(f)/2), Npower(1:length(f)/2));
title('Noise spectrum');
xlabel('Frequency /Hz');
ylabel('Amplitude');
box on;
xlim([1 fs/2]);
set(gcf, 'color', 'w');
set(gca, 'FontName', 'Times New Roman');
saveas(gcf, [titleStr '.fig']);
save([['Noised-Ricker-[' titleStr ']'] '.mat'], 'noisedData');
save([['Orignal-Ricker-[' titleStr ']'] '.mat'], 'OriData');

%% 短时傅立叶变换
%clear all  %窗口函数% 
% n1=40;  window=boxcar(n1); w1=window; 
% figure; 
% stem(w1);  % 非平稳信号产生% fs=1000; 
% a=0:1/fs:1; 
% f0=0; 
% f1=150;  
% y1=chirp(a,f0,1,f1); 
% x=y1(1:510);  
% figure; 
% plot(x);  % 短时傅里叶变换%  
% t=1:length(x); 
% n=length(x);  
% [tfr,t,f]=tfrstft(x,t,n,w1,0); 
% contour(t,f,abs(tfr))
