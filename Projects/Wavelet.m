%%  WAVELET TRANSFORM
t = linspace(0, 99.9, 1000);  % Time vector from 0 to 99.9 seconds
y_noisy = sin(1.5 * t) + 0.5 * randn(size(t));

% Perform DWT with three levels using 'db4'
[coeffs, lengths] = wavedec(y_noisy, 3, 'db4');

% Extract approximation and detail coefficients
cA3 = appcoef(coeffs, lengths, 'db4', 3);
cD3 = detcoef(coeffs, lengths, 3);
cD2 = detcoef(coeffs, lengths, 2);
cD1 = detcoef(coeffs, lengths, 1);

% Reconstruct signal using only approximation coefficients (A3)
y_A3 = wrcoef('a', coeffs, lengths, 'db4', 3);

% Reconstruct full signal using approximation and detail coefficients
y_full = wrcoef('a', coeffs, lengths, 'db4', 3) + ...
         wrcoef('d', coeffs, lengths, 'db4', 3) + ...
         wrcoef('d', coeffs, lengths, 'db4', 2) + ...
         wrcoef('d', coeffs, lengths, 'db4', 1);

% Plot the original, A3 only, and full reconstructed signals
figure;
subplot(3, 1, 1);
plot(t, y_noisy);
title('Original Noisy Signal');
xlabel('Time (seconds)');
ylabel('Amplitude');

subplot(3, 1, 2);
plot(t, y_A3, 'r');
title('Reconstructed Signal using A3 only');
xlabel('Time (seconds)');
ylabel('Amplitude');

subplot(3, 1, 3);
plot(t, y_full, 'g');
title('Reconstructed Signal using A3 + D3 + D2 + D1');
xlabel('Time (seconds)');
ylabel('Amplitude');

% Decompose using more levels (e.g., 5 levels)
num_levels = 5;
[C, L] = wavedec(y_noisy, num_levels, 'db4');

% Reconstruct using only approximation coefficients at different levels
for level = 4:num_levels
    cA = appcoef(C, L, 'db4', level);
    reconstructed_approx = wrcoef('a', C, L, 'db4', level);
    % Plotting the approximation reconstruction for analysis
    figure;
    plot(t, reconstructed_approx);
    title(['Approximation Coefficients Only - Level ', num2str(level)]);
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
end