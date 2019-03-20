%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   导出傅里叶变换后的结果，供绘图使用
%
%  所含模块包括：
%   1、利用傅里叶变换求取信号的频谱结果
%
% @Yanjiao, QUANJIE ZHU, 20170815
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fData, faData] = FFTData(data, fs);

%x = data;
N=length(data);
%Fs=1000;
Y = fft(data, N); %做FFT变换
Ayy = abs(Y); %取模
Ayy=Ayy/(N/2);   %换算成实际的幅度
Ayy(1)=Ayy(1)/2;
F=([1:N]-1)*fs/N; %换算成实际的频率值

fData = F(1:N/2);
faData = Ayy(1:N/2);
