% As requested, clean at start
clear all; close all; clc;

% Define vars
% Continous signal simulation
CONTINOUS_SAMPLE_RATE = 16e3;
DELTA_TIME = 1/CONTINOUS_SAMPLE_RATE;

% Create a time vector for 1 second
time_vector = 0:DELTA_TIME:1-DELTA_TIME;

%% Question 1
% A single frequency of 2pi*250 signal's Fourier Trasnform:

frequencies = (-300:0.5:300);
omega_0 = 2*pi*250;
omega_from_f = 2*pi*frequencies;
Xf1 = (1/(2j)) * ( ...
    1./(2 + 1j*(omega_from_f - omega_0)) - ...
    1./(2 + 1j*(omega_from_f + omega_0)) );

figure;
subplot(3,1,1);
plot(frequencies, abs(Xf1));
xlabel('Frequency (Hz)');
ylabel('|F\{x(t)\}|');
title('Magnitude of Fourier Transform of x(t)=sin(\omega_0 t) e^{-2t} u(t)');
grid on;


%% Question 2
% Define frequencies of signals
omega_1 = 2*pi*250;
omega_2 = 2*pi*315;
omega_3 = 2*pi*375;
omega_4 = 2*pi*500;
freqs = [omega_1, omega_2, omega_3, omega_4]; % Assign to a vector

% Then set the value by frequency for each second
% Create a matrix - each row for a different frequency
single_func = sin(freqs.' * time_vector).*exp(-2*time_vector);
% Concatenate the rows so each frequency plays for 1 second sequentially
x2 = reshape(single_func.', 1, []);

% Play sound: each frequency lasts 1 second, sampling rate SAMPLE_RATE
%soundsc(x2, CONTINOUS_SAMPLE_RATE);


%% Question 3
% Calculate time range
x2_index_range = floor(2.99/DELTA_TIME):1:floor(3.01/DELTA_TIME);
x2_time_range = x2_index_range * DELTA_TIME;
% Plot the time range twice with titles
figure;
subplot(2,1,1);
plot(x2_time_range, x2(x2_index_range), ":");
xlabel('Time (s)');
ylabel('Amplitude');
title('Signal x(t) over 2.99 to 3.01 s');
grid on;

subplot(2,1,2);
plot(x2_time_range, x2(x2_index_range), ":");
xlabel('Time (s)');
ylabel('Amplitude');
title('Signal x(t) over 2.99 to 3.01 s');
grid on;


%% Question 4
% Define vars for discrete signal sampling
DISCRETE_SAMPLE_RATE = 2e3;
DOWNSAMPLE_RATIO = CONTINOUS_SAMPLE_RATE / DISCRETE_SAMPLE_RATE;
DISCRETE_DELTA = 1 / DISCRETE_SAMPLE_RATE;

% Ensure downsample ratio is integer
DOWNSAMPLE_RATIO = round(DOWNSAMPLE_RATIO);

% Use downsample to create "discrete" signal
x4 = downsample(x2, DOWNSAMPLE_RATIO);

% Create time vector for x4
N4 = length(x4);
time_x4 = (0:N4-1) * DISCRETE_DELTA;

% Compute integer index range in x4 that corresponds to 2.99 to 3.01 s
x4_index_range = floor(2.99/DISCRETE_DELTA)+1:1:ceil(3.01/DISCRETE_DELTA);
x4_time_range = time_x4(x4_index_range);

% Overlay stem of x4 on the first subplot (time range 2.99-3.01 s)
subplot(2,1,1);
hold on;
stem(x4_time_range, x4(x4_index_range));
legend(["Original Signal", "Discrete Sample"])
hold off;


%% Question 5
% Calculate DFT of x2
N2 = length(x2);

X2_dft = fftshift(fft(x2));
f2 = (-N2/2:N2/2-1) * (CONTINOUS_SAMPLE_RATE/N2);

figure(1);
subplot(3,1,2);
plot(f2, abs(X2_dft)/N2);
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
title('Magnitude Spectrum of x(t)');
% Cut according to original signal frequencies
xlim([-600 600]);
grid on;


%% Question 7 - Sinc Reconstruction
% Upsample x4 back to original sampling grid
UPSAMPLE_RATIO = DOWNSAMPLE_RATIO;
x7 = upsample(x4, UPSAMPLE_RATIO);

% Sinc interpolation filter (ideal reconstruction)
n = -255:256; % Selected range
h_sinc = sinc(n / UPSAMPLE_RATIO);

% Convolution reconstruction
x7_sinc = conv(x7, h_sinc, 'same');

% Time vector for original signal
time_x2 = (0:length(x2)-1) * DELTA_TIME;

figure(2);
subplot(2,1,1);

hold on;
plot(time_x2(x2_index_range), x7_sinc(x2_index_range));
legend(["Original Signal", "Discrete Sample", "Sinc Reconstruct"]);
hold off;


%% Question 8 - ZOH Reconstruction
% Zero-order hold reconstruction - repeat discrete elements RATIO time
x8_zoh = repelem(x4, UPSAMPLE_RATIO);

hold on;
plot(time_x2(x2_index_range), x8_zoh(x2_index_range));
legend(["Original Signal", "Discrete Sample", "Sinc Reconstruct", "ZOH Reconstruct"]);
hold off;


%% Question 9 - FOH Reconstruction
% Upsample x4 (zero insertion)
x9_up = upsample(x4, UPSAMPLE_RATIO);

% Create triangular (FOH) interpolation kernel
n = -UPSAMPLE_RATIO:UPSAMPLE_RATIO;
h_foh = (1 - abs(n)/UPSAMPLE_RATIO);
h_foh(abs(n) > UPSAMPLE_RATIO) = 0;

% Convolution
x9_foh = conv(x9_up, h_foh, 'same');

hold on;
plot(time_x2(x2_index_range), x9_foh(x2_index_range));
legend(["Original Signal", "Discrete Sample", "Sinc Reconstruct", "ZOH Reconstruct", "FOH Reconstruct"]);
hold off;


%% Question 10
% Play the reconstructed signal
%soundsc(x7_sinc, CONTINOUS_SAMPLE_RATE); % Sounds nearly identical
%soundsc(x8_zoh, CONTINOUS_SAMPLE_RATE); % Sounds choppy
%soundsc(x9_foh, CONTINOUS_SAMPLE_RATE); % Sounds better but still not the
%best

%{
%% Question 11
NEW_SAMPLE_RATE = 800;
%}