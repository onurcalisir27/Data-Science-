%% ROC CURVE
clear; clc; close all

% Load ovarian cancer data
load('ovariancancer.mat');
data = ovariancancer_obs;

% Create data vectors from columns 909 and 1591
data_vec1 = data(:, 909);
data_vec2 = data(:, 1591); 

% Create gold standard vector (216x1)
gold_standard = [ones(121, 1); zeros(95, 1)];

% Obtain min, max, and range of data vector (column 909)
min_val1 = min(data_vec1);
max_val1 = max(data_vec1);
range1 = max_val1 - min_val1;

% Iterate over possible threshold values
thresholds = min_val1:range1/1000:max_val1;
TPR1 = zeros(length(thresholds), 1);
FPR1 = zeros(length(thresholds), 1);

for i = 1:length(thresholds)
    thresh = thresholds(i);
    
    % Evaluate model predictions based on threshold
    eval = data_vec1 >= thresh;

    % Calculate TP, FP, FN, TN
    TP1 = sum(eval == 1 & gold_standard == 1);
    FP1 = sum(eval == 1 & gold_standard == 0);
    FN1 = sum(eval == 0 & gold_standard == 1);
    TN1 = sum(eval == 0 & gold_standard == 0);

    % Calculate TPR (Sensitivity) and FPR (1 - Specificity)
    TPR1(i) = TP1 / (TP1 + FN1); % Sensitivity
    FPR1(i) = FP1 / (FP1 + TN1); % 1 - Specificity
end

% Plot ROC curve for feature 909
figure;
plot(FPR1, TPR1, 'b', 'LineWidth', 2);
hold on;

% Repeat for feature 1591
min_val2 = min(data_vec2);
max_val2 = max(data_vec2);
range2 = max_val2 - min_val2;

thresholds2 = min_val2:range2/1000:max_val2;
TPR2 = zeros(length(thresholds2), 1);
FPR2 = zeros(length(thresholds2), 1);

for i = 1:length(thresholds2)
    thresh = thresholds2(i);
    eval2 = data_vec2 >= thresh;

    % Calculate TP, FP, FN, TN
    TP2 = sum(eval2 == 1 & gold_standard == 1);
    FP2 = sum(eval2 == 1 & gold_standard == 0);
    FN2 = sum(eval2 == 0 & gold_standard == 1);
    TN2 = sum(eval2 == 0 & gold_standard == 0);

    % Calculate TPR (Sensitivity) and FPR (1 - Specificity)
    TPR2(i) = TP2 / (TP2 + FN2); % Sensitivity
    FPR2(i) = FP2 / (FP2 + TN2); % 1 - Specificity
end

% Plot ROC curve for feature 1591
plot(FPR2, TPR2, 'r', 'LineWidth', 2);

% Compute area under the curve (AUC) for both features
AUC1 = trapz(FPR1, TPR1);
AUC2 = trapz(FPR2, TPR2);

% Find the knee point (where TPR - FPR is maximal)
[~, knee_idx1] = max(TPR1 - FPR1);
[~, knee_idx2] = max(TPR2 - FPR2);

% Report performance metrics at knee point for feature 909
TP1 = sum((data_vec1 >= thresholds(knee_idx1)) & (gold_standard == 1));
FP1 = sum((data_vec1 >= thresholds(knee_idx1)) & (gold_standard == 0));
FN1 = sum((data_vec1 < thresholds(knee_idx1)) & (gold_standard == 1));
TN1 = sum((data_vec1 < thresholds(knee_idx1)) & (gold_standard == 0));

SEN1 = TP1 / (TP1 + FN1); % Sensitivity
SPEC1 = TN1 / (TN1 + FP1); % Specificity
PPV1 = TP1 / (TP1 + FP1); % Positive Predictive Value
NPV1 = TN1 / (TN1 + FN1); % Negative Predictive Value
ACC1 = (TP1 + TN1) / (TP1 + TN1 + FP1 + FN1); % Accuracy

% Report performance metrics at knee point for feature 1591
TP2 = sum((data_vec2 >= thresholds2(knee_idx2)) & (gold_standard == 1));
FP2 = sum((data_vec2 >= thresholds2(knee_idx2)) & (gold_standard == 0));
FN2 = sum((data_vec2 < thresholds2(knee_idx2)) & (gold_standard == 1));
TN2 = sum((data_vec2 < thresholds2(knee_idx2)) & (gold_standard == 0));

SEN2 = TP2 / (TP2 + FN2);
SPEC2 = TN2 / (TN2 + FP2);
PPV2 = TP2 / (TP2 + FP2);
NPV2 = TN2 / (TN2 + FN2);
ACC2 = (TP2 + TN2) / (TP2 + TN2 + FP2 + FN2);

% Display the ROC plot settings
title('ROC Curves for Features 909 and 1591 (Ovarian Cancer Data)');
xlabel('False Positive Rate (FPR)');
ylabel('True Positive Rate (TPR)');
legend('Feature 909', 'Feature 1591', 'Location', 'SouthEast');
grid on;

% Display AUC values and performance metrics
fprintf('AUC for Feature 909: %.4f\n', AUC1);
fprintf('AUC for Feature 1591: %.4f\n', AUC2);
fprintf('Performance metrics for Feature 909 at knee point:\n');
fprintf('Sensitivity: %.4f, Specificity: %.4f, PPV: %.4f, NPV: %.4f, Accuracy: %.4f\n', SEN1, SPEC1, PPV1, NPV1, ACC1);
fprintf('Performance metrics for Feature 1591 at knee point:\n');
fprintf('Sensitivity: %.4f, Specificity: %.4f, PPV: %.4f, NPV: %.4f, Accuracy: %.4f\n', SEN2, SPEC2, PPV2, NPV2, ACC2);