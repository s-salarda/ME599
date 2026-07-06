%% Part A 
% A1-----------------------------------------------------------------------
% Caclulate total acquisition time
gantry_speed = 540; % degrees/s
dt = 1/gantry_speed;
angular_range = 0:179; % 180 projections
num_projections = length(angular_range);
total_acquisition_time = num_projections * dt;
disp(total_acquisition_time)

% A2-----------------------------------------------------------------------
% Calculate the total displacement of the object in mm and in pixels
vx = 40; % mm/s
vy = 40; % mm/s
ax = 40; % mm/s
ay = 40; % mm/s^2
t = total_acquisition_time;
Sx = vx*t + (1/2) * ax * t^2;
Sy = vy*t + (1/2) * ay * t^2;
% Magnitude (not really needed since Sx=Sy)
S = sqrt(Sx^2 + Sy^2);
disp(S)

% Convert to pixels
pixel_spacing = 0.5; % mm
S_pixels = S/pixel_spacing;
disp(S_pixels)

%% Part B
% B5-----------------------------------------------------------------------
% Calculate vx, ax, and t
% Default Paramaters
% Equation: S = v*t + (1/2) * a * t^2;
angular_range = 0:359;  % Change this for full (359)/half-scan(179)
gantry_speed = 360;     % degrees per secon; deffault = 360

% Total Displacement
S = 80; % mm

% Total acquisition time 
dt = 1/gantry_speed;
num_projections = length(angular_range);
t = num_projections * dt;
disp(t)

% Profile (i) constant velocity (a = 0)
a = 0;
v = (S - (1/2)*a*t^2)/t;
disp(v)

% Profile (ii) constant accelaration (v = 0)
v = 0;
a = (S - v*t) * 2 / t^2;
disp(a)

%% CT Simulation of Coronary Artery Motion
clear; clc; close all;

% Image and object parameters
N = 256;             % Image size (pixels)
pixel_size = 1;    % mm per pixel
obj_size = 3;        % in pixels
% -------------------------------------------------------------------------
% Only required to change vx, vy, ax, ay, angular_range, and gantry_speed
% Velocity parameters
vx = 80;    % x-velocity mm/s (positive = rightward)
vy = 0;     % y-velocity mm/s (positive = downward in image)

% Acceleration (mm/s^2) - set to 0 for constant velocity
ax = 0;     % x-acceleration
ay = 0;     % y-acceleration

% A4-----------------------------------------------------------------------
% Acquisition parameters
angular_range = 0:359;  % Change this for full (359)/half-scan(179)
gantry_speed = 360;     % degrees per secon; deffault = 360
% -------------------------------------------------------------------------

% Starting position (pixels)
start_col = 80; % starting column (x)
start_row = 80; % starting row (y)

% Calculating object position at each projection
dt = 1/gantry_speed;        % time per degree (seconds)
times = (0:length(angular_range)-1).*dt;

% Kinematics: S = v*t + 0.5*a*t^2
dx = (vx.*times + (0.5*ax)*times.^2)./pixel_size; % displacement in pixels
dy = (vy.*times + (0.5*ay)*times.^2)./pixel_size;

% Updated object positions during motion
col_positions = start_col + dx;
row_positions = start_row + dy;

% Generate sinogram
% Determine detector size from a test projection
test_img = zeros(N);
test_img(round(start_row),round(start_col)) = 1;
[~,l] = radon(test_img,0);
n_detector = length(l);

% Initializing sinogram
sinogram = zeros(n_detector,length(angular_range));
half_obj = floor(obj_size/2);

% A3 ----------------------------------------------------------------------
% Looping over each projection angle
for j = 1:length(angular_range)
    img = zeros(N);
    col_pos = round(col_positions(j));
    row_pos = round(row_positions(j));
    
    % Check object is fully inside image - shouldn't go out of bounds
    if col_pos > half_obj && col_pos <= N-half_obj && ...
       row_pos > half_obj && row_pos <= N-half_obj
        img(row_pos-half_obj:row_pos+half_obj, ...
            col_pos-half_obj:col_pos+half_obj) = 1;
    end
    
    % Stacking each projection in the sinogram
    sinogram(:,j) = radon(img,angular_range(j));
end

% Reconstructuction
recon = iradon(sinogram,angular_range,'Ram-Lak',N);

% Displaying results
figure('pos',[10 10 1200 500]);

subplot(1,2,1);
imagesc(angular_range,l,sinogram);
xlabel('Projection Angle [\circ]');
ylabel('Detector Position (l)');
title(sprintf('Sinogram (%d to %d\\circ)',angular_range(1), ...
    angular_range(end)));
colormap gray;
axis tight;

subplot(1,2,2);
imagesc(recon);
axis equal;
title('Object Reconstruction');
colormap gray;

% FOR YOUR REFERENCE ONLY: overlaying true trajectory on reconstruction
% DO NOT INCLUDE THIS IN YOUR SUBMISSION
% hold on;
% plot(col_positions,row_positions,'r--','LineWidth',1);
% plot(start_col, start_row,'go','MarkerSize',8,'LineWidth',2);
% plot(col_positions(end),row_positions(end),'rx','MarkerSize',8,'LineWidth',2);
% legend('True path','Start','End','Location','southeast','TextColor','w');
% hold off;