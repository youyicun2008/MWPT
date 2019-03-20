function [a] = GetFSWT(s,Fs,fp,kapa,Tn)

%% Tn: Time Resample Point Number
%% fp : Observed frequency range

N=length(s);  %%% Original Point Number

Y = fft(s,N); %% FFT 
Y(1)=0; %% cut the constant part

nl=length(fp); %% Observation frequency length

a=zeros(Tn,nl);
s1=zeros(Tn,1);

TNN=fix(Tn/2);
k0=0;

for  p=1:nl;
   s1=s1*0;  
   k0=0;
  for k=1:Tn;
     s1(k)=0;
     if fp(p)==0 continue;end;
     m=fp(p)+k-1-TNN;
    if m>=0 &&  abs(k-1-TNN)<.5*TNN && m<N 
     ct=kapa*(k-1-TNN)/fp(p);
      s1(k)=Y(m+1)/(1+ct*ct);
     %s1(k)=Y(m+1)*exp(-ct*ct/2);  %%% Here you can use your Frequency slice function.
     end;
  end
   s1(1)=0;
   s1=conj(s1);
   Y1=fft(s1,Tn);
   for k=1:Tn; if mod(k-1,2)==1 Y1(k)=-Y1(k); end;  end  
   a(:,p)=Y1;
end
