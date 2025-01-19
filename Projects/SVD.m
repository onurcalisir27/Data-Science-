%% MECE E4520 HW 2 
% Onur Calisir (oc2356)
% 9/20/2024
% Housekeeping
clc; clear; close all;
x = input('Choose Problem (1,2,3): ');
switch(x)
    case 1
%% Problem 1: SVD for image compression
% First, we load the image
A=imread('Street_Pic.jpg');
X=double(rgb2gray(A)); % Convert RBG->gray, 256 bit->double.
nx = size(X,1); ny = size(X,2); 
imagesc(X), axis off, colormap gray

% Take the SVD 
[U,S,V] = svd(X);

i=0; figure(2);
for r = [1 4 16 64 256 1024] % using powers of 4
    i = i +1;
     Xapprox = U(:,1:r)*S(1:r,1:r)*V(:,1:r)';
     if i == 1
         subplot(3,2,1); % create a 3x2 subplot
         imagesc(X); colormap gray; axis off
         title('Original Image');
     else 
         subplot(3,2,i);
         imagesc(Xapprox); colormap gray; axis off
         title(['r = ', num2str(r)]);
     end
end
% Compute the singular values
singular_values = diag(S);
for k = 1:r
    sigma_r(k) = sum(singular_values(1:k))
end

% Plot the singular values to visualize their magnitude
figure;
semilogy(sigma_r, 'bo-'); % semilogy gives a log scale to observe decay
title('Singular Values of the Image');
xlabel('Index');
ylabel('Singular Value (log scale)');
grid on;

    case 2
%% Problem 2: SVD for plotting Ovarian Cancer Data
% Load the dataset
load ovariancancer
obs = ovariancancer_obs;
[U, S, V] = svd(obs,'econ');
for i= 1:size(obs,1)
    x = V(:,1)' * obs(i,:)';
    y = V(:,2)' * obs(i,:)';
    z = V(:,3)' * obs(i,:)';
    figure(1)
    plot3(x,y,z,'kx','LineWidth',3);
    hold on
    grid on
    xlabel('PCA 1')
    ylabel('PCA 2')
    zlabel('PCA 3')
    title('Ovarian Cancer Dataset without Annotation')
end
k = 1;
for i= 1:size(obs,1)
    x = V(:,1)' * obs(i,:)';
    y = V(:,2)' * obs(i,:)';
    z = V(:,3)' * obs(i,:)';
    if(k < 122)
        % figure(2)
        plot3(x,y,z,'rx','LineWidth',1);
        hold on
        grid on
        xlabel('PCA 1')
        ylabel('PCA 2')
        zlabel('PCA 3')
    elseif(k>=121 && k < 216)
        plot3(x,y,z,'bo','LineWidth',1);
    end
    title('Ovarian Cancer Dataset with Annotation')
    k = k + 1;
end
    case 3
%% Problem 3: PCA Analysis of HWs with Students
% Step 1
A = [91 82 82;74 84 90;90 90 90;71 91 87;78 86 93;88 78 94]; % Step 1
% Step 2
X_ave = mean(A); 
B = A - [1; 1; 1; 1; 1; 1]*X_ave;
% Step 3
C = (B' * B) / (size(A, 1) - 1);
% Step 4
[V, D] = eig(C); 
d = diag(D); 
% Step 5
[~, idx] = sort(d, 'descend'); 
W = V(:, idx(1:2));
% Step 6
A_reduced = B * W;
% Display the reduced data
disp(A_reduced);
% Matlab pca(x)
[coeff, score, latent] = pca(A);  
A_reduced_matlab = score(:, 1:2); 
% Display the reduced data from pca command
disp(A_reduced_matlab);
% Plotting both manual and MATLAB PCA results
figure
scatter(A_reduced(:, 1), A_reduced(:, 2), 'ro'); 
hold on;
scatter(A_reduced_matlab(:, 1), A_reduced_matlab(:, 2), 'bx'); 
xlabel('Principal Component 1');
ylabel('Principal Component 2');
grid on;
title('PCA of Homework Scores: Manual vs MATLAB');
legend('Manual PCA', 'MATLAB PCA', 'Location', 'best');
% Show how they differ
difference = A_reduced_matlab - A_reduced;

    otherwise
        disp('Please enter 1,2,or 3');
end

