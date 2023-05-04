theta = 0:0.1:100;
x = sin(theta);
plot(theta, x); title('Input Signal');
xlabel('\theta'); ylabel('sin(\theta)');
grid on;
figure(2);
y = raylrnd(x);
plot(y); title('Rayleigh Channel Output');
xlabel('\theta'); ylabel('Rayleigh Channel Output on the Signal');