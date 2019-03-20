function wtspecdecom(data,fz,Fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% wavelet transform for specdom
%%%  This programm is used to do the spectrum decomposition of the seismic data with the
%%%  wavelet transform. With it you can get the single frequency section of the seismic 
%    profile 

%%%%%%%%%%　written by LU Jiaotong in China University of Petroleum beijing,
%%%%%%%%%%  date: 6/10/2011
%%% Input-- 
%             data----the input seismic data profile(should be 2d)
%             fz------ the domain frequency used to generate the single
%             frequency section, it can be a array or a scalar; and the
%             value should between(1,100)Hz;
%             Fs---- sample frequency such as 1000HZ

%%%%%%%%%%%   This programme need the third party software such as tftb-0.2
%             which can be download from the Rice University,
%             or wigb fuction

%%%%%%%%%%%   Attention: This programm is just for scientific research
%             purpose, you cannot distribute it without the author's
%             permission. Anyone who uses it in your research, should
%             mention it in your publish.
%%%%%%%%%%%   So enjoy it,enjoy the fun of the game of Mathematics transform

%%%%%%%%%%%   Any question can contact: ljiaotong@126.com


if (nargin==0 || nargin>3)
   disp('Error: you must input at least one variable!!')
    
elseif (nargin==1)
    
    fz=30;   %%%% display domain frequency 30 HZ single freuqncy section
    Fs=1000;
end

if (nargin==2)
   
    Fs=1000;
    
end

if (min(fz)<0 || max(fz)>100)
    
    disp('Error: the fz should between 0 and 100 Hz')   
end

if Fs<100
    
    disp('Attention: are you sure the sample frequcny like this??')
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% get the part of the profile

dd=data;   %%%%%%%%%%%%% u can change it 
[m,n]=size(dd);
tt=(1:m)/Fs; 
figure,
wigb(dd,1,1:n,tt);  %%%%%% local profile
xlabel('Trace');
ylabel('Time[s]');
title('Seismic profile');


C=cell(1,n);
%%%%%%%%%%%%%%%%%%%%%%%$%%%%%%%%%%% frequency division processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% do wavelet transform to the section
tic
for i=1:n
    
     s=dd(:,i);
     [tf,t,f]=tfrscalo(s,1:m,0,0.001,0.1,100);
     ff=Fs*f;
     [TT,FF]=meshgrid(...
     t,ff(1):(ff(end)-ff(1))/(100-1):ff(end)...
     );
     ZZ=interp2(t,ff,tf,TT,FF);
     C(1,i)={ZZ};
     
end
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% get the sigle frequency section
%fz=15:5:55;                 %%%%%%%% main frequncy of sfs
len=length(fz);
sf=cell(1,len);
sf2=zeros(m,n);
mm=zeros(1,len);
for j=1:len
for i=1:n
   
    D=C{1,i};
    sf2(:,i)=D(fz(j),:)';
    
end
  mm(j)=max(max(sf2));
  sf(1,j)={sf2};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% plot the single Frequency
mm2=max(mm);      %%%%%%%%%%%%%% aim to normalization the enengy of the SFS
figure,
for j=1:len
    sf3=sf{1,j};
    if len<3
    subplot(1,len,j)      %%　u can change it with your favoriate
    imagesc(1:n,tt,sf3/mm2);
    xlabel('Trace');
    ylabel('Time[s]');
    title(['Single frequency section--',int2str(fz(j)),'Hz']);
    colorbar;
    elseif len==4
    subplot(2,2,j)      %%　u can change it with your favoriate
    imagesc(1:n,tt,sf3/mm2);
    xlabel('Trace');
    ylabel('Time[s]');
    title(['Single frequency section--',int2str(fz(j)),'Hz']);
    colorbar;  
    elseif mod(len,3)==0
    subplot(len/3,3,j)      %%　u can change it with your favoriate
    imagesc(1:n,tt,sf3/mm2);
    xlabel('Trace');
    ylabel('Time[s]');
    title(['Single frequency section--',int2str(fz(j)),'Hz']);
    colorbar;  
    else
    subplot(mod(len,3),3,j)      %%　u can change it with your favoriate
    imagesc(1:n,tt,sf3/mm2);
    xlabel('Trace');
    ylabel('Time[s]');
    title(['Single frequency section--',int2str(fz(j)),'Hz']);
    colorbar;     
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%% do smooth the section using the 2d interpolate
% [tra,tim]=meshgrid(1:n,1:m);
% [Tra,Tim]=meshgrid(1:0.5:n,1:m);
% 
% SF=interp2(tra,tim,sf,Tra,Tim);
% figure,
% imagesc(1:0.5:n,tt,SF);
% xlabel('Trace');
% ylabel('Time[ms]');
% title(['Sigle frequency section---',int2str(fz),'Hz']);

end










