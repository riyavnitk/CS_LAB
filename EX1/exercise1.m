theta = 0:0.1:100;
x = sin(theta);
plot(theta, x); title('Input Signal');
xlabel('\theta'); ylabel('sin(\theta)');
grid on;
figure(2);
y = awgn(x, 10);
plot(y); title('AWGN Channel Output');
xlabel('\theta'); ylabel('AWGN Channel Output on the Signal');