%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Frequency Slice Wavelet Transform, FSWT
%
%   coded by:zhuquanjie 
%   datetime:20140721
%   @guiyang
%   MATLAB CODE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [z] = FSWT_ThreeFigure(data, fs);
%% Fs is sample frequency, f1 is the low frequency, f2 is the high frequency.
% s is the data, like [1;2;3;4;5], one cloum??
%Fs=4000;%% you can change it
s = data;
Fs = fs;
N=length(s);
%N=1000;
s=s-sum(s)/N;%% Please cut the DC part in the signal
%%s0=s; s=s/max(s)+sin(rand(N,1)*2*pi)*0.5;%%s=s.*(1+sin(rand(N,1)*2*pi));
f1=0.;%% you can change it 
f2=500;%% you can change it

%%% [f1,f2] is your observed frequency  range, you can change any scope

k1=fix(f1*N/Fs-0.5);
k2=fix(f2*N/Fs-0.5);
df=1;  %% is a observed frequency  step length
if(k2>N/2+1) k2=N/2+1; end
    
fp= fix(k1:df:k2);   %%  fp if the observed frequency in discrete form

nl=length(fp);

kapa=sqrt(2)/2/0.025;  %%kapa is the time-frequency resolution factor

Tn=512; %% smaple numer in time domain, you can chage it

[A] = GetFSWT(s,Fs,fp,kapa,Tn);   

ss = GetInvFSWT(N,A,fp);%recover the signal from the band of fp;
B=sqrt(A.*conj(A));

mx= max(max(B));
B=fix(B*128/mx);
t= (0:Tn-1)*N/Fs/Tn;

figure;
% %%%%%%%%%%%%%%% 导出图形的参数 %%%%%%%%%%%%%%%%%%
%set(gcf, 'renderer', 'painters');
set(gcf, 'PaperUnits', 'inches');
%set(gcf, 'PaperSize', [4 2]);
set(gcf, 'PaperPositionMode', 'manual');
lan = 2;
if lan==2
    aa = 18/(2.54*lan);
    bb = 12/(2.54*2);
else
    aa = 18/(2.54*lan);
    bb = 12/(2.54*2);
end
set(gcf, 'PaperPosition', [1 1 aa bb]);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(gcf, 'color', 'w');

subplot(2,7,[1 5]);
%plot((0:N-1),s,'r');
%hold on 
plot((0:N-1),ss,'b');
%set(gca,'YDir','normal');
%xlabel('Time /ms', 'FontSize', 10, 'FontName', 'TimesNewRoman');
ylabel('Amplitude (mV)', 'FontSize', 9, 'FontName', 'Arial');
box on;
axis tight;
xlim([0, 3000]);

subplot(2,7,[13 14]);
Y=fft(s,N);
z=Y.*conj(Y);
z=sqrt(z);
z(1)=0;
z(2)=0;
K1=fix(f2*N/Fs);
fp1=[0 : K1-1]/N*Fs;
plot(z(1:K1),fp1, 'b');
%plot(fp1,z(1:K1));
%set(gca,'ydir','normal');
set(gca,'YDir','normal');
set(gca,'YAxisLocation','right');
ylabel('Frequency (Hz)', 'FontSize', 9, 'FontName', 'Arial');
xlabel('S', 'FontSize', 9, 'FontName', 'Arial');
%xlabel('PSD (m^2/ms)', 'FontSize', 9, 'FontName', 'Arial');
box on;
axis tight;
colormap(jet);

subplot(2,7,[8 12]);
image(t*1000,fp*Fs/N,B');
%image(fp*Fs/N,t*1000,B);
set(gca,'ydir','normal');
xlabel('Time (ms)', 'FontSize', 9, 'FontName', 'Arial');
ylabel('Frequency (Hz)', 'FontSize', 9, 'FontName', 'Arial');
box on;
%xlim([0, 3000]);
axis tight;
%grid on;
colormap(jet);

% 保存类型
saveas(gcf, 'figure13_a1', 'fig');
saveas(gcf, ['figure13_a1' '.eps'], 'psc2');
saveas(gcf, ['figure13_a1' '.pdf'], 'pdf');
