close all;clear all;clc;

%%  audio + white noise
[signal,fs] = audioread('handel.wav');
%sound(signal,fs)

noise = wgn(length(signal), 1, -20);
%sound(noise,fs)

d = signal + noise;
%sound(d,fs)

x = sin(1./(1+exp(-noise)));
%sound(x,fs)

mu =  0.001;
M = 40;
%% LMS
Ns = length(d); %length of desired signal in samples
xx = zeros(M,1); 
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

%sound(y_predicted,fs)