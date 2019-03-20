function [Y1] = GetInvFSWT(N,a,fp)

%% fp : Observation frequency
[Tn,np]=size(a); %% Tn: Time Resample Point Number, np is the length of fp ;  

%%%nl=length(fp); %% Observation frequency length
s1=zeros(N,1);

for  p=1:np;
   sum=0;
   for k=1:Tn; 
       %% if mod(k-1,2)==0 sum=sum+conj(a(k,p)); else  sum=sum-conj(a(k,p));  end   
       sum=sum+conj(a(k,p));
   end
   sum=sum/Tn;
   if fp(p)>0
   s1(fp(p)+1)=sum;
   s1(N-fp(p)+1)=conj(sum);
   end
end
s1(1)=0;
Y1=fft(conj(s1),N)/N;
%%Y1=ifft(s1,N);
Y1=real(Y1);




  
