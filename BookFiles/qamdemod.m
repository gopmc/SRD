% qamdemod.m: modulate and demodulate a complex-valued QAM signal
N=10000; M=20; Ts=.0001; j=sqrt(-1);   % # symbols, oversampling factor
time=Ts*(N*M-1); t=0:Ts:time;          % sampling interval and time vectors
m=pam(N,2,1)+j*pam(N,2,1);             % signals of length N
ps=hamming(M);                         % pulse shape of width M
fc=1000; th=-1.0;                      % carrier freq. and phase

mup=zeros(1,N*M); mup(1:M:end)=m;      % oversample by integer length M
mp=filter(ps,1,mup);                   % convolve pulse shape with data
v=real(mp.*exp(j*(2*pi*fc*t+th)));     % complex carrier

f0=1000; ph=-1.0;                      % freq. and phase of demod
x=v.*exp(-j*(2*pi*f0*t+ph));           % demodulate v
l=50; f=[0,0.2,0.25,1]; a=[1 1 0 0];   % specify filter parameters
b=firpm(l,f,a);                        % design filter
s=filter(b,1,x);                       % s=LPF{x}

figure(1),plotspec(mp,1/M)             % spectrum of message
figure(2),plotspec(v,1/M)              % spectrum of transmitted signal
figure(3),plotspec(x,1/M)              % demodulated signal
figure(4),plotspec(s,1/M)              % demodulated signal after LPF
figure(5),plot(real(mp))               % compare transmitted and received
hold on
plot(real(2*s),'r')                    % real parts
hold off
figure(6),plot(imag(mp(500:1000)))     % compare transmitted and received
hold on
plot(imag(2*s(500+l/2:1000+l/2)),'r')  % imaginary parts
hold off
