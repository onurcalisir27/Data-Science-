%% ARX System Identification - Dryer Dataset
clc; clear;

% Plot dryer data
load dryer2.mat % Loads u2: power and y2:temperature

% Sampling rate and time vector
Ts = 0.08; % seconds
t = (0:length(u2)-1) * Ts;

% Use detrend() to obtain ud and yd with zero means
ud = detrend(u2, 'constant');
yd = detrend(y2, 'constant');

% Plot the detrended signals
figure;
subplot(2,1,1);
plot(t, yd, 'r');
title('Output (Temperature in C)');
ylabel('Temperature (C)');
grid on;
axis([0 80 -5 10]);
subplot(2,1,2);
plot(t, ud, 'r');
title('Input (Power in Watts)');
xlabel('Time (sec)');
ylabel('Power (W)');
grid on;
axis([0 80 -5 10]);

% Divide the data
N = length(ud) / 2; 
ude = ud(1:N);      % estimation input
yde = yd(1:N);      % estimation output
udv = ud(N+1:end);  % validation input
ydv = yd(N+1:end);  % validation output
te = t(1:N);        % time for estimation
tv = t(N+1:end);    % time for validation

% Plot the divided data for estimation and validation
figure;
subplot(2,1,1);
plot(t, y2, 'b');
hold on
plot(te, yde, 'r');
plot(tv, ydv, 'c');
title('Input and Output Signals');
ylabel('Temperature (C)');
grid on;
hold off;
axis([0 80 -5 10]);
subplot(2,1,2);
plot(t, u2, 'b');
hold on
plot(te, ude, 'r');
plot(tv, udv, 'c');
xlabel('Time (sec)');
ylabel('Power (W)');
grid on;
hold off;
axis([0 80 -5 10]);

% ARX model estimation
na = 3; % output order
nb = 1; % input order
d = na + nb; % total number of parameters to estimate

% Initialize Phi and Y
Phi = zeros(N , d); % Initialize Phi Matrix N x d 
Y = yde; % Define Y from estimation y
% Fill the Phi matrix row-by-row
for k = max(na, nb) + 1:N % iterate for the non zero entries of u and y
    % Fill u terms
    for i = 1:nb
        Phi(k , i) = ude(k - (i - 1))';
    end   
    % Fill y terms
    for i = 1:na
        Phi(k , nb + i) = - yde(k - i)';
    end
end

% Estimate the parameters using the pseudoinverse
theta = pinv(Phi) * Y; % theta is the parameter vector containing the ARX model coefficients
% Display estimated parameters
disp('Estimated Parameters (theta):');
disp(theta);

% Validation of ARX model 
% Initialize y_model for the validation phase
y_model = zeros(N, 1);
% Compute y_model using the estimated theta parameters
for k = max(na, nb) + 1:N
    % Initialize phi_k with zeros for the current sample
    phi_k = zeros(na + nb, 1);    
    % Fill phi_k with input terms
    for i = 1:nb
        phi_k(i) = udv(k - (i - 1));
    end    
    % Fill phi_k with output terms (using y_model for predictions)
    for j = 1:na
        phi_k(nb + j) = -y_model(k - j);
    end    
    % Compute the predicted output for the current sample
    y_model(k) = theta' * phi_k;
end
% Plot the validation result
figure;
plot(tv, ydv, 'r');
hold on;
plot(tv, y_model, 'b');
grid on;
xlabel('Time (sec)');
ylabel('Temperature (C)');
legend('Validation Set', 'Estimated Set', 'Location','best');
title('Validation of ARX Model na=3, nb=1');
hold off;
% Estimation error
error = ydv - y_model;
fprintf('Max error for given na: %d and nb: %d:\n', na, nb);
disp(max(error));
figure;
plot(tv, error, 'b');
grid on;
ylabel('Estimation Error');
xlabel('Time (sec)');
title('Estimation Error of ARX Model for Dryer Dataset')

% ARX model estimation code
na = 4; % output order
nb = 4; % input order
d = na + nb; % total number of parameters to estimate
% Initialize Phi and Y
Phi = zeros(N , d); % Initialize Phi Matrix N x d 
Y = yde; % Define Y from estimation y
% Fill the Phi matrix row-by-row
for k = max(na, nb) + 1:N % iterate for the non zero entries of u and y
    % Fill u terms
    for i = 1:nb
        Phi(k , i) = ude(k - (i - 1))';
    end   
    % Fill y terms
    for i = 1:na
        Phi(k , nb + i) = - yde(k - i)';
    end
end
% Estimate the parameters using the pseudoinverse
theta = pinv(Phi) * Y; % theta is the parameter vector containing the ARX model coefficients
% Validation code for ARX model 
% Initialize y_model for the validation phase
y_model = zeros(N, 1);
% Compute y_model using the estimated theta parameters
for k = max(na, nb) + 1:N
    % Initialize phi_k with zeros for the current sample
    phi_k = zeros(na + nb, 1);  
    % Fill phi_k with input terms
    for i = 1:nb
        phi_k(i) = udv(k - (i - 1));
    end    
    % Fill phi_k with output terms (using y_model for predictions)
    for j = 1:na
        phi_k(nb + j) = -y_model(k - j);
    end    
    % Compute the predicted output for the current sample
    y_model(k) = theta' * phi_k;
end

% Plot the validation result
figure;
plot(tv, ydv, 'r');
hold on;
plot(tv, y_model, 'b');
grid on;
xlabel('Time (sec)');
ylabel('Temperature (C)');
legend('Validation Set', 'Estimated Set', 'Location','best');
title('Validation of ARX Model na=4, nb=4');
hold off;

% Estimation error
error = ydv - y_model;
figure;
plot(tv, error, 'b');
grid on;
ylabel('Estimation Error');
xlabel('Time (sec)');
title('Estimation Error of ARX Model for Dryer Dataset')