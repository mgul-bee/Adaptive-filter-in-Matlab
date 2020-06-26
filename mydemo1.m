clc;
close all;
clear all;
%% single frequency signal + white noise
f=[2 3 5]; % frequency of the refernce signal
fs = 8000; %sampling Frequency
T=2; % length of signal in sec
t = 0:1/fs:T-(1/fs); % Time vector of 5 seconds = Fs*5 = 40000 samples
%white Guassian Noise(M,N,P)------{MxN matrix of WGN, P is power in dBW}
A=5; % noise amplitude
noise = A*wgn(1, length(t),-20)'; % 1x40000 noise of power -20dBW
% d is the reference synthesized sinusoid signal(nois free)
d=zeros(length(t),1);
for i=1:1:length(f)
    Q = 2*sin(2*pi*t*f(i))'; 
    d=d+Q;
    clear Q
end
% x is the input signal
x = noise + d; % noisy signal
    
mu =  0.001; % controls the speed of the coefficients(adaptive filter) change.
M = 20; % order of adaptive filter
%%
%%LMS
Ns = length(d); %length of desired signal in samples
xx = zeros(M,1); % intializing 
w1 = zeros(M,1);
y_predicted = zeros(Ns,1);
e = zeros(Ns,1);
tic % timer start
for n = 1:Ns
    xx = [xx(2:M);x(n)];
    y_predicted(n) = w1' * xx;
    e(n) = d(n) - y_predicted(n); % calculating error 
    w1 = w1 + mu * e(n) * xx; % (gradient descent or mean square) to calculate new better weights
    w(:,n) = w1; % updating new optimized weights
end
toc %timer stops
%%
%%plot and compare
figure()
subplot(3,2,1)
plot([1:length(d)]/fs,d);
xlabel('time');
title('d(n)----Desired noise free signal');

subplot(3,2,2)
plot([1:length(noise)]/fs,noise);
xlabel('time');
title('WGN noise');

subplot(3,2,3)
plot([1:length(x)]/fs,x);
xlabel('time');
title('x(n)----Noisy signal');

subplot(3,2,4)
plot([1:length(e)]/fs,e);
xlabel('time');
title('LMS e(n)----decreasing error');

subplot(3,2,5)
plot([1:length(y_predicted)]/fs,y_predicted);
xlabel('time');
title('LMS` predicted y(n)----noise cleared by adaptive filter');

subplot(3,2,6)
stem(1:1:M,w1);
xlabel('coefficients index');
title('final optimized values of coefficeints of adaptive filter');
w1