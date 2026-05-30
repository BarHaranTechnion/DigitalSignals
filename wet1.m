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
% Define the signal frequency
omega_0 = 2*pi*250;
% Time vector starts at 0 - equivalent to u(t)
x1 = sin(omega_0 * time_vector) .* exp(-2 * time_vector);

% Compute Fourier transform numerically using FFT on a sufficiently long window
N = length(time_vector);
Xf = fft(x1, N) * DELTA_TIME;

% Frequency vector in Hz
f = (0:N-1) / (N*DELTA_TIME);  % positive frequencies
% Shift FFT and frequency to center zero
Xf_shift = fftshift(Xf);
% Center frequency vector around zero (fftshift later applied to Xf)
f_shift = f - CONTINOUS_SAMPLE_RATE/2;

% Select frequency range |f| <= 300 Hz
idx = abs(f_shift) <= 300;
f_plot = f_shift(idx);
X_plot = Xf_shift(idx);

% Plot magnitude
figure;
subplot(3,1,1);
plot(f_plot, abs(X_plot), 'LineWidth', 1.2);
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
sinuses = sin(freqs.' * time_vector);
% Concatenate the rows so each frequency plays for 1 second sequentially
x2 = reshape(sinuses.', 1, []);

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
title('Signal x2 over 2.99 to 3.01 s (plot 1)');
grid on;

subplot(2,1,2);
plot(x2_time_range, x2(x2_index_range), ":");
xlabel('Time (s)');
ylabel('Amplitude');
title('Signal x2 over 2.99 to 3.01 s (plot 2)');
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
x4_index_range = floor(2.99/DISCRETE_DELTA):1:floor(3.01/DISCRETE_DELTA);
x4_time_range = time_x4(x4_index_range);

% Overlay stem of x4 on the first subplot (time range 2.99-3.01 s)
subplot(2,1,1);
hold on;
stem(x4_time_range, x4(x4_index_range));
hold off;


%% Question 5
% Calculate DFT of x2
N2 = length(x2);
X2_dft = fft(x2, N2);
% Prepare frequency vector for x2 DFT (same length N as used earlier)
X_dft_shift = fftshift(X2_dft) * DELTA_TIME;
f2 = (0:N2-1) / (N2*DELTA_TIME);
f2_shift = f2 - (CONTINOUS_SAMPLE_RATE/2);

idx = abs(f2_shift) <= 300;

% Plot in the first figure's second subplot (abs, fftshift)
figure(1);
subplot(3,1,2);
plot(f2_shift(idx), abs(X_dft_shift(idx)));
xlabel('Frequency (Hz)');
ylabel('|X_{dft}(f)|');
title('Magnitude of DFT of x2 (fftshifted)');
grid on;