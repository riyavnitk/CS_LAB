clc; clear all; close all;
N=10000; 
EbN0dB = -6:2:12;
M=16; 
refArray =1/sqrt(10)*[-3-3j,-3-1j,-3+3j,-3+1j,-1-3j,-1-1j,-1+3j,-1+1j,3-3j,3-1j,3+3j,3+1j,1-3j,1- 1j,1+3j,1+1j];
symErrSimulated = zeros(1,length(EbN0dB));
k=log2(M);
EsN0dB = EbN0dB + 10*log10(k);
data=ceil(M.*rand(N,1))-1;
s=refArray(data+1); 
refI = real(refArray); 
refQ = imag(refArray);
index=1;
figure(1);
subplot(1,2,1);
plot(real(s),imag(s),'r*');
title('Constellation diagram for Transmitted Symbols'); 
xlabel('Inphase component');
ylabel('Quadrature component');
subplot(1,2,2);
for x=EsN0dB,
    noiseVariance = 1/(10.^(x/10));
    noiseSigma = sqrt(noiseVariance/2);
    noise = noiseSigma*(randn(size(s))+1i*randn(size(s)));
    received = s + noise;
    r_i = real(received);
    r_q = imag(received);
    r_i_repmat = repmat(r_i,M,1);
    r_q_repmat = repmat(r_q,M,1);
    plot(r_i,r_q,'*');
    title(['Constellation diagram for Received Symbols Eb/N0=' num2str(x-10*log10(k)) 'dB']);
    xlabel('Inphase component');
    ylabel('Quadrature component');
    pause;
    distance = zeros(M,N); 
    minDistIndex=zeros(N,1);
    for j=1:N
        distance(:,j) = (r_i_repmat(:,j)-refI').^2+(r_q_repmat(:,j)-refQ').^2;
        [dummy,minDistIndex(j)]=min(distance(:,j));
    end
    y = minDistIndex - 1;
    dataCap = y;
    symErrSimulated(1,index) = sum(dataCap~=data)/N;
    index = index + 1;
end
EbN0lin = 10.^(EbN0dB/10);
symErrTheory = 2*(1-1/sqrt(M))*erfc(sqrt(3/2*k*EbN0lin/(M-1)));
figure(2);
semilogy(EbN0dB,symErrTheory,'r-');hold on; 
semilogy(EbN0dB,symErrSimulated,'b*'); 
legend('16QAM-Theory','16QAM-Sim'); xlabel('Eb/N0(dB)');
ylabel('Symbol Error Rate (Ps)'); grid on;

