function [simulatedSER, theoreticalSER]= simulateMPSK(M,N,EbN0dB,Rc)
k=log2(M);
EsN0dB = EbN0dB+10*log10(k); 
dataSym=ceil(M.*rand(N,1));
I = 1/sqrt(2)*cos((dataSym-1)/M*2*pi); 
Q = 1/sqrt(2)*sin((dataSym-1)/M*2*pi);
m_psk = (I+1i*Q);
s_i=zeros(1,M);s_q=zeros(1,M);
for i=1:1:M
    s_i(i)= 1/sqrt(2)*cos((i-1)/M*2*pi);
    s_q(i)= 1/sqrt(2)*sin((i-1)/M*2*pi); 
end
simulatedSER = zeros(1,length(EsN0dB));
index=1;
for x=EsN0dB,
    EsN0lin = 10.^(x/10);
    noiseSigma = 1/sqrt(2)*sqrt(1/(2*Rc*EsN0lin));
    noise = noiseSigma*(randn(length(m_psk),1)+1i*randn(length(m_psk),1));
    received = m_psk + noise;
    r_i = real(received);
    r_q = imag(received);
    r_i_repmat = repmat(r_i,1,M);
    r_q_repmat = repmat(r_q,1,M);
    distance = zeros(length(r_i),M); 
    minDistIndex=zeros(length(r_i),1);
    for j=1:1:length(r_i)
        distance(j,:) = (r_i_repmat(j,:)-s_i).^2+(r_q_repmat(j,:)-s_q).^2;
        [dummy,minDistIndex(j)]=min(distance(j,:));
    end
    y = minDistIndex;
    simulatedSER(index) = sum(y~=dataSym)/N;
    index=index+1;
end
EbN0lin = 10.^(EbN0dB/10);
theoreticalSER = log10(erfc(sqrt(EbN0lin*k)*sin(pi/M)));