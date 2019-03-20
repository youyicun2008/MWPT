
%% ������������
sampleLen = 1000;  % ����ʱ�䳤�ȣ�����������
fs = 1000; % ���εĲ���Ƶ�ʣ�Hz
fm = 75;  % �źŵ���Ƶ������Ƶ�ʣ���Hz
fig = 0;   % �Ƿ�ͼ��0Ϊ��1Ϊ��
ap = 0.7;  % �趨�Ӳ���ֵλ��
no = -25;    % ������룬��λdb��wgn�����Ĳ���
timeDic = 1000*(0:1/fs:1/fs*(sampleLen-1)); % ת����ms
%% �����׿��Ӳ�
[OriData, noisedData, noise] = RickerWavelet(sampleLen, fs, fm, ap, no, fig);
waveData = OriData;
%% ���㹦����
N = length(waveData);%���ݳ���
%i = 0:N-1;
%t = i/fs;
f = (0:N-1)*fs/N;%������Ƶ�ʵı��ʽΪf=(0:M-1)*Fs/M;??
% 1��ԭʼ���ݼ���
%f=100;%�趨�����ź�Ƶ��?%���������ź�?
waveData2 = fft(waveData,N);%����fft�任?
mag = abs(waveData2);%���ֵ?
%f = (0:N-1)*fs/N;%������Ƶ�ʵı��ʽΪf=(0:M-1)*Fs/M;??
Opower = mag.^2;
% 2�����������ݼ���
%f=100;%�趨�����ź�Ƶ��?%���������ź�?
noisedData2 = fft(noisedData,N);%����fft�任?
mag = abs(noisedData2);%���ֵ?
%f = (0:N-1)*fs/N;%������Ƶ�ʵı��ʽΪf=(0:M-1)*Fs/M;??
NDpower = mag.^2;
% 3�����������ݼ���
%f=100;%�趨�����ź�Ƶ��?%���������ź�?
noise2 = fft(noise,N);%����fft�任?
mag = abs(noise2);%���ֵ?
%f = (0:N-1)*fs/N;%������Ƶ�ʵı��ʽΪf=(0:M-1)*Fs/M;??
Npower = mag.^2;

%% ��ͼ
h = figure;
titleStr = ['fs = ' num2str(fs) ',' 'fm=' num2str(fm) ',' 'no=' num2str(no), 'sampleLen = ' num2str(sampleLen) ];
suptitle(titleStr);
%set(h,'name','HaarС���任','Numbertitle','off')
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

% �������ź�
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

% ����
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

%% ��ʱ����Ҷ�任
%clear all  %���ں���% 
% n1=40;  window=boxcar(n1); w1=window; 
% figure; 
% stem(w1);  % ��ƽ���źŲ���% fs=1000; 
% a=0:1/fs:1; 
% f0=0; 
% f1=150;  
% y1=chirp(a,f0,1,f1); 
% x=y1(1:510);  
% figure; 
% plot(x);  % ��ʱ����Ҷ�任%  
% t=1:length(x); 
% n=length(x);  
% [tfr,t,f]=tfrstft(x,t,n,w1,0); 
% contour(t,f,abs(tfr))