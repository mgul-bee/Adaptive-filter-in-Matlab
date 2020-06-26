clc;
close all;
clear all;
%% echo cancellation (
[d, fs] = audioread('handel.wav'); % echoes free signal
sound(d,fs)

x = audioread('handel_echo.wav'); % echoes full signal
sound(x,fs)

mu =  0.05; % convergense rate
M = 40; % order of adaptive filter (taps)
%%
%%LMS
Ns = length(d); 
xx = zeros(M,1); 
w1 = zeros(M,1);
y_predicted = zeros(Ns,1);
e = zeros(Ns,1);
tic % timer start
for n = 1:Ns
    xx = [xx(2:M);x(n)];
    y_predicted(n) = w1' * xx; % applying filter and then proceding to check error 
    e(n) = d(n) - y_predicted(n); % calculating error 
    w1 = w1 + mu * e(n) * xx; % (gradient descent or mean square) to calculate new better weights
    w(:,n) = w1; % updating new optimized weights
end
toc %timer stops
sound(y_predicted,fs)
filename = 'handel_echoes_adaptively_filtered.wav';
audiowrite(filename,y_predicted,fs);
[y,Fs] = audioread(filename);

