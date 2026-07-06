%% Question 1 Part A
N = 256; % image size
img = zeros(N); % matrix of zeros
% Defining a small rectangle in the center
img(127:129,127:129) = 1;

figure;
imagesc(img);
colormap(gray);
clim([0 1]);
colorbar;
title('(1a) Centered 3x3 Phantom');
xlabel('X Position (pixels)');
ylabel('Y Position (pixels)');

%% Question 1 Part B
% Display the Image
figure;
imagesc(img);
colormap(gray);
clim([0 1]);
colorbar;
title('(1b) 90° Projection Marked');
xlabel('X Position (pixels)');
ylabel('Y Position (pixels)');
% Add arrow to mark 90 degree projection
% This is very wrong
hold on
quiver(240, 250, 0, -240, 0, 'r');
text(190, 230, 'Projection Angle: 90°', 'Color', 'red');
quiver(40, 20, 180, 0, 0, 'w')
text(50, 25, 'Detector Length')
hold off

%% Question 1 Part C - Theoretical projection profile
detector_pos = [125, 126, 127, 127, 129, 129, 130, 131];
values =       [0,   0,   0,   3,   3,   0,   0,   0];

figure;
plot(detector_pos, values, 'LineWidth', 2);
title('(1c) Theoretical 90° Projection Profile');
xlabel('Detector Position (pixels)');
ylabel('Projection Value (intensity)');
ylim([0 4]);
xlim([124 132]);

%% Question 1 Part D
% Using radon function to generate sinogram
theta = 0:1:179; % Full sampling should span at least 180 degrees
[sinogram, l] = radon(img, theta);

% Display the Image
figure;
imagesc(theta, l, sinogram);
colormap(gray);
colorbar;
title('(1d) Sinogram of Centered 3x3 Phantom');
xlabel('Projection Angle (degrees)');  % X-axis is theta
ylabel('Detector Position (pixels)');   % Y-axis is l (detector positions)

%% Question 1 Part E
projection_90 = sinogram(:, 91);
find(projection_90 > 0)  % Shows positions
projection_90(projection_90 > 0)  % Shows values

figure;
plot(projection_90);
title('(1e) Sinogram Values');
xlabel('Detector Position (');
ylabel('Projection Value');

%% Question 1 Part D
sum_img = sum(img(:));
disp(sum_img);
sum_0deg = sum(sinogram(:, 1));
disp(sum_0deg);
sum_90deg = sum(sinogram(:, 91));
disp(sum_90deg);
sum_180deg = sum(sinogram(:, 180));
disp(sum_180deg);

%% Question 2 Part A
N = 256; % image size
img = zeros(N); % matrix of zeros
% Defining small rectangular objects
% Simulating small calcium particles in a cardiac image
% First set
img(127:129,127:129) = 1;
img(132:134,127:129) = 1;
% Second set
img(45:47,127:129) = 1;
img(50:52,127:129) = 1;
% Third set
img(55:57,55:57) = 1;
img(60:62,60:62) = 1;

% Display the image 
figure;
imagesc(img);
colormap(gray)
clim([0,1]);
colorbar;
title('(2a) Phantom with Multiple 3x3 Blocks')
xlabel('X Position (pixels)');
ylabel('Y Position (pixels)');

%% Question 2 Part B
theta = 0:1:179; % Full sampling should span at least 180 degrees
[sinogram, l] = radon(img, theta);

% Display the image
figure;
imagesc(theta, l, sinogram);
colormap(gray);
colorbar;
title('(2b) Sinogram of Phantom with Multiple 3x3 Blocks');
xlabel('Projection Angle (degrees)');  % X-axis is theta
ylabel('Detector Position (pixels)');   % Y-axis is l (detector positions)
%% Question 2 Part D
% Display the Image 
figure;
imagesc(img);
colormap(gray);
colorbar;
title('(2d) Multiple 3x3 Phantom');
xlabel('Projection Angle (degrees)');
ylabel('Detector Position (pixels)');
hold on;

% Add 0, 45, 90, 180 degree projections
% 0° Projection Angle and detector length
% quiver(50, 240, 100, 0, 0, 'r');
% text(100, 230, 'Projection Angle: 0°', 'Color', 'red');
quiver(128, 230, 0, -80, 0, 'w')
text(140, 245, 'Detector Length for 0 degrees')

% 45° Projection Angle and detector length
% quiver(200, 250, 50, -50, 0, 'r', 'LineWidth', 2.5, 'MaxHeadSize', 0.5);
% text(230, 230, '45°', 'Color', 'red', 'FontSize', 14, 'FontWeight', 'bold');
quiver(175, 175, 45, 45, 0,'w')
text(230, 230,'Detector Length for 45 degrees')

% 90° Projection Angle and detector length
% quiver(240, 150, 0, -100, 0, 'r');
% text(220, 130, 'Projection Angle: 90°', 'Color', 'red');
quiver(40, 20, 180, 0, 0, 'w')
text(50, 25, 'Detector Length for 90 degrees')

% 180° Projection Angle and detector length
% quiver(200, 20, -100, 0, 0, 'r');
% text(180, 30, 'Projection Angle: 180°', 'Color', 'red');
quiver(150, 60, 0, 80, 0, 'w')
text(140, 95, 'Detector Length for 180 degrees')

hold off;

%% Question 3 Part A
theta = 0:1:179; % Full sampling should span at least 180 degrees
[sinogram] = radon(img, theta);

% Iradon with filter 'none' 
backprojected_image = iradon(sinogram,theta,'none');

% Display the Image 
figure;
imagesc(backprojected_image);
colormap(gray);
colorbar;
title('(3a) Back Projected w/ no filter');
xlabel('X Position (pixels)');
ylabel('Y Position (pixels)');

%% Question 3 part C
theta = 0:1:179; % Full sampling should span at least 180 degrees
[sinogram] = radon(img, theta);

% Iradon with filter 'Ram-Lak' 
backprojected_image_ramlak = iradon(sinogram,theta,'Ram-Lak');

% Display the Image 
figure;
imagesc(backprojected_image_ramlak);
colormap(gray);
colorbar;
title('(3c) Back Projected w/ Ram-Lak filter');
xlabel('X Position (pixels)');
ylabel('Y Position (pixels)');

%% Question 3 part E
theta = 0:1:179; % Full sampling should span at least 180 degrees
[sinogram] = radon(img, theta);

% Iradon with filter 'Hann' 
backprojected_image_hann = iradon(sinogram,theta,'Hann');

% Display the Image 
figure;
imagesc(backprojected_image_hann);
colormap(gray);
colorbar;
title('(3e) Back Projected w/ Hann filter');
xlabel('X Position (pixels)');
ylabel('Y Position (pixels)');

%% Question 3 part G
% Quick check because Arrays are incompatible sizes
size(img)
size(backprojected_image_ramlak)
size(backprojected_image_hann)

% Crop back projected images to 256x256
backprojected_image_ramlak_cropped = backprojected_image_ramlak(1:256, 1:256);
size(backprojected_image_ramlak_cropped)
backprojected_image_hann_cropped = backprojected_image_hann(1:256, 1:256);
size(backprojected_image_hann_cropped)

% RMSE = sqrt(sum(predicted - observed)^2/2)
rmse_ramlak = sqrt(mean((backprojected_image_ramlak_cropped(:) - img(:)).^2));
rmse_hann = sqrt(mean((backprojected_image_hann_cropped(:) - img(:)).^2));

%% Question 4 part A
img = phantom(N);

% Display the Image 
figure;
imagesc(img);
colormap(gray);
colorbar;
title('(4a) Shepp-Logan Phantom');
xlabel('X Position (pixels)');
ylabel('Y Position (pixels)');

%% Question 4 part B
theta = 0:1:179; % Full sampling should span at least 180 degrees
[sinogram, l] = radon(img, theta);

% Display the Image 
figure;
imagesc(theta, l, sinogram);
colormap(gray);
colorbar;
title('(4b) Shepp-Logan Phantom Sinogram');
xlabel('Projection Angle (degrees)');  % X-axis is theta
ylabel('Detector Position (pixels)');   % Y-axis is l (detector positions)

%% Question 4 part C 
% Iradon with filter 'Ram-Lak' 
backprojected_image = iradon(sinogram,theta,'Ram-Lak');

% Display the Image 
figure;
imagesc(backprojected_image);
colormap(gray);
colorbar;
title('(4c) Shepp-Logan Back Projected');
xlabel('Projection Angle (degrees)');  % X-axis is theta
ylabel('Detector Position (pixels)');   % Y-axis is l (detector positions)

%% Question 4 part D - Method 1
theta = 0:10:179; % change to a step size of 10 instead of 1
[sinogram, l] = radon(img, theta);
backprojected_image = iradon(sinogram, theta, 'Ram-Lak');

% Display the Image
figure;

% Subplot for the Sinogram
subplot(1,2,1);
imagesc(theta, l, sinogram);
colormap(gray);
colorbar;
title('(4d) Method 1: Sinogram');
xlabel('Projection Angle (degrees)');  % X-axis is theta
ylabel('Detector Position (pixels)');   % Y-axis is l (detector positions)

% Subplot for the Reconstructed image
subplot(1,2,2);
imagesc(backprojected_image);
colormap(gray);
colorbar;
title('(4d) Method 1: Reconstructed Image');
xlabel('X Position (pixels)');
ylabel('Y Position (pixels)');

%% Question 4 part D - Method 2
theta = 0:1:17; % change to an angular range of 18 degrees instead of 180
[sinogram, l] = radon(img, theta);
backprojected_image = iradon(sinogram, theta, 'Ram-Lak');

% Display the Image 
figure;

% Subplot for the Sinogram
subplot(1,2,1);
imagesc(theta, l, sinogram);
colormap(gray);
colorbar;
title('(4d) Method 2: Sinogram');
xlabel('Projection Angle (degrees)');  % X-axis is theta
ylabel('Detector Position (pixels)');   % Y-axis is l (detector positions)

% Subplot for the Reconstructed image
subplot(1,2,2);
imagesc(backprojected_image);
colormap(gray);
colorbar;
title('(4d) Method 2: Reconstructed Image');
xlabel('X Position (pixels)');
ylabel('Y Position (pixels)');

%% Question 4 part E
% Estimate the position of the X-ray source at theta = 0
% Start from a different angle to see how the sinogram shifts
theta_test1 = 0:1:179;    % normal
theta_test2 = 90:1:269;   % starting at 90 degrees

% Sinograms starting at different projection angles
[sino1, l1] = radon(img, theta_test1);
[sino2, l2] = radon(img, theta_test2);

% Display the Image
figure;

% Projection angle of 0
subplot(1,2,1); 
imagesc(theta_test1, l1, sino1); 
colormap(gray);
title('Normal 0-179');
xlabel('Projection Angle (degrees)');  % X-axis is theta
ylabel('Detector Position (pixels)');   % Y-axis is l (detector positions)

% Projection angle of 0
subplot(1,2,2); 
imagesc(theta_test2, l2, sino2); 
colormap(gray);
title('Starting at 90°');
xlabel('Projection Angle (degrees)');  % X-axis is theta
ylabel('Detector Position (pixels)');   % Y-axis is l (detector positions)

%% Question 5 part A
theta = 0:1:179; % Full sampling should span at least 180 degrees
[sinogram, l] = radon(img, theta);

% noise levels
noise_levels = [0.05, 0.10, 0.15, 0.20, 0.25, 0.30];
n_noise = length(noise_levels);

% for loop through each noise level
for i = 1:n_noise
    % Add Gaussian noise to sinogram
    sino_noise = sinogram + noise_levels(i)*std(sinogram(:)) * randn(size(sinogram));

    % Reconstruct with Ram Lak
    ramlak_noise = iradon(sino_noise, theta, 'Ram-Lak');

    % Reconstruct with Hann
    hann_noise = iradon(sino_noise, theta, 'Hann');

    % Display the noisy Subplot for Ram-Lak
    subplot(2,6,i);
    imagesc(ramlak_noise);
    colormap(gray);
    clim([0 1]);
    xlabel(sprintf('%d%% noise', noise_levels(i)*100));

    % Display the noisy Subplot for Hann
    subplot(2,6,i+6);
    imagesc(hann_noise);
    colormap(gray);
    clim([0 1]);
    xlabel(sprintf('%d%% noise', noise_levels(i)*100));
end

sgtitle('(5a) Back projections at varying Noise levels');
subplot(2,6,1);
ylabel('Ram-Lak');
subplot(2,6,7);
ylabel('Hann');

%% Question 5 part B 
% Plot a graph of SNR value as a funciton of noise levels 
roi_x = 120:140; % Estimated from original Shepp image and adjusted
roi_y = 70:90; % Estimated from original Sheep image

% Display the image w/ ROI 
figure;
imagesc(img);
colormap(gray);
hold on;
rectangle('Position', [roi_x(1), roi_y(1), length(roi_x), length(roi_y)], ...
          'EdgeColor', 'r', 'LineWidth', 2);
title('Shepp-Logan Phantom with ROI');
hold off;

% Need to Preallocae SNR arrays
ramlak_snr = zeros(1, n_noise);
hann_snr = zeros(1, n_noise);

% Loop through each noise level and calculate the SNR
for i = 1:n_noise 
    % Add Gaussian noise to sinogram
    sino_noise = sinogram + noise_levels(i)*std(sinogram(:)) * randn(size(sinogram));

    % Reconstruct with Ram Lak
    ramlak_noise = iradon(sino_noise, theta, 'Ram-Lak');

    % Reconstruct with Hann
    hann_noise = iradon(sino_noise, theta, 'Hann');

    % Calcualtee the ROI for Ram-Lak and Hann
    ramlak_roi = ramlak_noise(roi_y, roi_x);
    hann_roi = hann_noise(roi_y, roi_x);

    % Calculate SNR = mean(ROI)/std(ROI
    ramlak_snr(i) = mean(ramlak_roi) / std(ramlak_roi);
    hann_snr(i) = mean(hann_roi) / std(hann_roi);
end

% Display the Image for both Filters 
figure;

% Top subplot: Ram-Lak
subplot(2, 1, 1);
plot(noise_levels*100, ramlak_snr);
xlabel('Noise Level (%)');
ylabel('SNR');
title('Ram-Lak Filter');

% Bottom subplot: Hann
subplot(2, 1, 2);
plot(noise_levels*100, hann_snr);
xlabel('Noise Level (%)');
ylabel('SNR');
title('Hann Filter');

%% Question 5 part C
% Create a 5x5 averaging kernal and smooth the sinogram
h = ones(5,5)/25; % h = averaging kernal

% for loop through each noise level
for i = 1:n_noise
    % Add Gaussian noise to sinogram
    sino_noise = sinogram + noise_levels(i)*std(sinogram(:)) * randn(size(sinogram));

    % Smooth the noisy sinogram
    sinogram_smooth = conv2(sino_noise, h, 'same');

    % Reconstruct with Ram Lak
    ramlak_smooth = iradon(sinogram_smooth, theta, 'Ram-Lak');

    % Reconstruct with Hann
    hann_smooth = iradon(sinogram_smooth, theta, 'Hann');

    % Display the smoothed Subplot for Ram-Lak
    subplot(2,6,i);
    imagesc(ramlak_smooth);
    colormap(gray);
    clim([0 1]);
    xlabel(sprintf('%d%% noise', noise_levels(i)*100));

    % Display the smoothed Subplot for Hann
    subplot(2,6,i+6);
    imagesc(hann_smooth);
    colormap(gray);
    clim([0 1]);
    xlabel(sprintf('%d%% noise', noise_levels(i)*100));
end

sgtitle('(5c) Reconstructions with Smoothed Sinograms');
subplot(2,6,1);
ylabel('Ram-Lak');
subplot(2,6,7);
ylabel('Hann');

%% Question 5 part D
% Plot a graph of SNR value as a funciton of noise levels 
roi_x = 120:140; % Estimated from original Shepp image and adjusted
roi_y = 70:90; % Estimated from original Sheep image

% Display the image w/ ROI 
figure;
imagesc(img);
colormap(gray);
hold on;
rectangle('Position', [roi_x(1), roi_y(1), length(roi_x), length(roi_y)], ...
          'EdgeColor', 'r', 'LineWidth', 2);
title('Shepp-Logan Phantom with ROI');
hold off;

% Need to Preallocae SNR arrays
ramlak_snr = zeros(1, n_noise);
hann_snr = zeros(1, n_noise);

% Loop through each noise level and calculate the SNR
for i = 1:n_noise 
    % Add Gaussian noise to sinogram
    sino_noise = sinogram + noise_levels(i)*std(sinogram(:)) * randn(size(sinogram));

    % Smooth the noisy sinogram
    sinogram_smooth = conv2(sino_noise, h, 'same');

    % Reconstruct with Ram Lak
    ramlak_smooth = iradon(sinogram_smooth, theta, 'Ram-Lak');

    % Reconstruct with Hann
    hann_smooth = iradon(sinogram_smooth, theta, 'Hann');

    % Calcualtee the ROI for Ram-Lak and Hann
    ramlak_roi = ramlak_smooth(roi_y, roi_x);
    hann_roi = hann_smooth(roi_y, roi_x);

    % Calculate SNR = mean(ROI)/std(ROI
    ramlak_snr(i) = mean(ramlak_roi) / std(ramlak_roi);
    hann_snr(i) = mean(hann_roi) / std(hann_roi);
end

% Display the Image for both Filters 
sgtitle('(5d) Smoothed Sinograms SNR to Noise');

% Top subplot: Ram-Lak
subplot(2, 1, 1);
plot(noise_levels*100, ramlak_snr);
xlabel('Noise Level (%)');
ylabel('SNR');
title('Ram-Lak Filter');

% Bottom subplot: Hann
subplot(2, 1, 2);
plot(noise_levels*100, hann_snr);
xlabel('Noise Level (%)');
ylabel('SNR');
title('Hann Filter');
    