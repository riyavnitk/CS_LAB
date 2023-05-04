%16PSK
clc; clear; close all;
N = 2*10^5; % number of symbols
M = 16;
thetaMpsk = [0:M-1]*2*pi/M; % reference phase values

Es_N0_dB  = [0:25]; % multiple Es/N0 values

ipPhaseHat = zeros(1,N);
for ii = 1:length(Es_N0_dB),
    
    % symbol generation
    % ------------------
    ipPhase = randsrc(1,N,thetaMpsk);
    ip = exp(j*ipPhase);   
    s = ip; % normalization of energy to 1
    
    % noise
    % -----
    n = 1/sqrt(2)*[randn(1,N) + j*randn(1,N)]; % white guassian noise, 0dB variance 
    
    y = s + 10^(-Es_N0_dB(ii)/20)*n; % additive white gaussian noise 
    plot(real(y),imag(y),'r*'); hold on;
    plot(real(s),imag(s),'ko','MarkerFaceColor','g','MarkerSize',7); hold off;
    title(['Constellation plots - ideal 16-PSK (green) Vs Noisy y signal for EbN0dB =',num2str(ii),' dB']);
    pause;
    % demodulation
    % ------------
    % finding the phase from [-pi to +pi]
    opPhase = angle(y); 
    % unwrapping the phase i.e. phase less than 0 are 
    % added 2pi
    opPhase(find(opPhase<0)) = opPhase(find(opPhase<0)) + 2*pi;

    % rounding the received phase to the closest 
    % constellation
    ipPhaseHat = 2*pi/M*round(opPhase/(2*pi/M))	;
    % as there is phase ambiguity for phase = 0 and 2*pi,
    % changing all phases reported as 2*pi to 0.
    % this is to enable comparison with the transmitted phase
    ipPhaseHat(find(ipPhaseHat==2*pi)) = 0; 

    % counting errors
    nErr(ii) = size(find([ipPhase- ipPhaseHat]),2); % couting the number of errors
end 
simBer = nErr/N;
theoryBer = erfc(sqrt(10.^(Es_N0_dB/10))*sin(pi/M));


figure
semilogy(Es_N0_dB,theoryBer,'bs-','LineWidth',2);
hold on
semilogy(Es_N0_dB,simBer,'mx-','LineWidth',2);
axis([0 25 10^-5 1])
grid on
legend('theory', 'simulation');
xlabel('Es/No, dB')
ylabel('Symbol Error Rate')
title('Symbol error probability curve for 16-PSK modulation')

