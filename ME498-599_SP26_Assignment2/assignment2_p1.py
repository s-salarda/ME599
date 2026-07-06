import pydicom 
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Circle
from scipy.stats import linregress
from scipy import stats 
import pandas as pd

# File path to the DIOCOM
file_path = 'CTA_hole_phantom.dcm'

# Read the DICOM file
CTA_dcm = pydicom.dcmread(file_path) 

# Pixel Data
CTA_dcm.pixel_array

# -----------------------------------------
# Problem 1: Part A and B 
# -----------------------------------------
# Convert to HU
CTA_HU = CTA_dcm.pixel_array * CTA_dcm.RescaleSlope + CTA_dcm.RescaleIntercept
print(f"Max HU: {CTA_HU.max():.1f}, Min HU: {CTA_HU.min():.1f}")

# Sample different regions to see actual HU values
# Choose random points in the image to sample HU values
print(f"Black region (background): {CTA_HU[100, 300]:.1f} HU")
print(f"Center of the image (phantom): {CTA_HU[250, 250]:.1f} HU")
print(f"White Region (contrast): {CTA_HU[150, 200]:.1f} HU")

# Display the image
# Adjust vmin (everything that should appear black) and vmax (everything that should appear white)
# Contrast HU = 828.0 so vmax<=828.0
# vmin was adjusted to -500
plt.imshow(CTA_HU, cmap='gray',
           vmin=-500, vmax=800)
plt.colorbar(label='HU')
plt.title('CTA Hole Phantom')
plt.xlabel('Pixel row')
plt.ylabel('Pixel column')
plt.show()

# Setting up ROIs to calculate average HU values in regions
rows, cols = CTA_HU.shape # grid of image (512x512)
Y, X = np.ogrid[:rows, :cols] # Creates coordinate grids for the image

# Puck ROI
center1_x, center1_y, radius1 = 250, 300, 70 # Geometric Parameters
dist_from_center1 = np.sqrt((X - center1_x)**2 + (Y - center1_y)**2)
mask1 = dist_from_center1 <= radius1
print(f"Average HU in the puck ROI: {CTA_HU[mask1].mean():.1f} HU")

# Contrast ROI 
center2_x, center2_y, radius2 = 180, 150, 20
dist_from_center2 = np.sqrt((X - center2_x)**2 + (Y - center2_y)**2)
mask2 = dist_from_center2 <= radius2
print(f"Average HU in the contrast ROI: {CTA_HU[mask2].mean():.1f} HU")

# Apply masks to image
fig, ax = plt.subplots(figsize=(10, 8))
ax.imshow(CTA_HU, cmap='gray', vmin=-500, vmax=800)

# Draw both circles in red
circle1 = Circle((center1_x, center1_y), radius1,
                linewidth=2, edgecolor='red', facecolor='none')
ax.add_patch(circle1)
circle2 = Circle((center2_x, center2_y), radius2,
                linewidth=2, edgecolor='red', facecolor='none')
ax.add_patch(circle2)

# Annotate ROI
ax.annotate('Puck ROI', (center1_x, center1_y - radius1 - 10), 
            color='red', fontsize=12, ha='center')
ax.annotate('Contrast ROI', (center2_x, center2_y - radius2 - 10), 
            color='red', fontsize=12, ha='center')

ax.set_title('ROI Locations')
plt.colorbar(ax.imshow(CTA_HU, cmap='gray', vmin=-500, vmax=800), 
            ax=ax, label='HU')
plt.tight_layout()
plt.show()
# Sanity check with ImajeJ... Could have just used ImageJ

# -----------------------------------------
# Problem 1: Part C
# -----------------------------------------
# Find the Coordinates for the holes using ImageJ - MultiPoint
x_3mm, y_3mm = [89.993], [80.875]
x_1mm, y_1mm = [134.790], [83.452]

# Lecture 11: SNR = I_t/sigma_b
# SNR = Intensity of the object / Standard Deviation of the background noise
# CNR = (I_t - I_b) / sigma_b
# CNR = Intensity of the object - Background/ Standard Deviation of the background noise
# Calculate SNR and CNR for the 3mm hole
I_t_3mm = 540.800 # Average HU from ImageJ
I_t_1mm = 369.562 # Average HU from ImageJ
I_b = 122.077 # Average HU from ImageJ
sigma_b = 79.855 # Standard Deviation from ImageJ
print(f"SNR for 3mm hole: {I_t_3mm / sigma_b:.2f}")
print(f"CNR for 3mm hole: {abs(I_t_3mm - I_b) / sigma_b:.2f}")
print(f"SNR for 1.4mm hole: {I_t_1mm / sigma_b:.2f}")
print(f"CNR for 1.4mm hole: {abs(I_t_1mm - I_b) / sigma_b:.2f}")

# -----------------------------------------
# Problem 1: Part D
# -----------------------------------------
# HU values for holes 3mm to 0.8mm
hole_sizes = np.array([1.4, 1.3, 1.2, 1.1, 1.0, 0.9, 0.8]) # Given 
hole_HU = np.array([509, 483, 416, 394, 385, 295, 257]) # MAX from ImageJ

# Plot HU values vs hole size
plt.figure(figsize=(10, 8))
plt.scatter(hole_sizes, hole_HU, color='blue')

# Add regression line
slope, intercept, r_value, p_value, std_err = stats.linregress(hole_sizes, hole_HU)
x_fit = np.linspace(0.7, 1.5, 100)
y_fit = slope * x_fit + intercept
plt.plot(x_fit, y_fit, 'r--', label='Linear Fit')

# 95% confidence interval: z_score = 1.96
# threshold = phantom background + 1.96*standard deviation of the background
# min_diameter = threshold intersects with linear regression line   
threshold = I_b + 1.96 * sigma_b
min_diameter = (threshold - intercept) / slope

# Threshold line and minimum diameter point
plt.axhline(threshold, color='green', linestyle='--', linewidth=2,
           label=f'95% Threshold = {threshold:.1f} HU')
plt.plot(min_diameter, threshold, 'rs', markersize=15,
        label=f'Min = {min_diameter:.2f} mm')

plt.xlabel('Hole Diameter (mm)')
plt.ylabel('Peak HU Value')
plt.title('HU Values vs Hole Size')
plt.legend()
plt.show()

# -----------------------------------------
# Problem 2: Part A and B
# -----------------------------------------
# Noise Ratios
I_t_1mm_2 = 278.429 # Average HU from ImageJ
I_b_2 = 119.659 # Average HU from ImageJ
sigma_b_2 = 80.545 # Standard Deviation from ImageJ
print(f"SNR for 1.4mm hole with fat ring: {I_t_1mm_2 / sigma_b_2:.2f}")
print(f"CNR for 1.4mm hole with fat ring: {abs(I_t_1mm_2 - I_b_2) / sigma_b_2:.2f}")

# Hole sizes are the same
hole_HU_2 = np.array([357, 360, 372, 351, 225, 185, 140]) # MAX from ImageJ

# Add regression line
slope, intercept, r_value, p_value, std_err = stats.linregress(hole_sizes, hole_HU_2)
x_fit = np.linspace(0.7, 1.5, 100)
y_fit = slope * x_fit + intercept
plt.plot(x_fit, y_fit, 'r--', label='Linear Fit')

# 95% confidence interval: z_score = 1.96
# threshold = phantom background + 1.96*standard deviation of the background
# min_diameter = threshold intersects with linear regression line   
threshold = I_b + 1.96 * sigma_b
min_diameter = (threshold - intercept) / slope

# Threshold line and minimum diameter point
plt.axhline(threshold, color='green', linestyle='--', linewidth=2,
           label=f'95% Threshold = {threshold:.1f} HU')
plt.plot(min_diameter, threshold, 'rs', markersize=15,
        label=f'Min = {min_diameter:.2f} mm')

plt.xlabel('Hole Diameter (mm)')
plt.ylabel('Peak HU Value')
plt.title('HU Values vs Hole Size for phantom in fat ring')
plt.legend()
plt.show()

# -----------------------------------------
# Problem 3
# -----------------------------------------
# MTF (Modulation Transfer Function): ability of an imaging system to reproduce contrast at different spatial frequencies
series_num = np.array([1, 2, 3, 4, 5, 6, 7])
distances = np.array([0.8, 0.6, 0.56, 0.52, 0.59, 0.43, 0.39]) # Given
line_pairs = np.array([5, 4, 4, 4, 5, 4, 4]) # Given
spatial_freq = line_pairs / distances # lp/cm 
F_max = np.array([125, 75, -25, -100, -200, -250, -175]) # MAX from ImageJ
F_min = np.array([-1175, -1100, -950, -825, -600, -575, -450]) # MIN from ImageJ

# MTF = (F_max - F_min) / (F_max + F_min)
# F_max = maximum intensity (peak HU) of the hole
# F_min = minimum intensity (background HU) around the hole
MTF = (F_max - F_min) / np.abs(F_max + F_min)

# Normalize MTF values to the MTF at the lowest spatial frequency
# Lowest spatial frequency is Series 1 with 6.25 lp/cm
MTF_normalized = MTF / MTF[0]

# Plot
plt.figure(figsize=(8, 6))
plt.plot(spatial_freq, MTF_normalized, 'bo-', linewidth=2, markersize=8)
plt.xlabel('Spatial Frequency (lp/cm)', fontsize=12)
plt.ylabel('MTF', fontsize=12)
plt.title('MTF vs Spatial Frequency', fontsize=14)
plt.show()

# -----------------------------------------
# Problem 4
# -----------------------------------------
# Step 1 & 2: ImageJ -> File -> Import -> Image Sequence -> Stacks -> Z Project -> Average Intensity
# Step 3: Location of the maximum value in the image (Center of the bead)
[bead_x,bead_y] = [24.591, 36.584] # ImageJ coordinates

# Step 4: Plot the intensity profile along a line through the center of the bead
df_line = pd.read_csv('plot_values.csv') # Line profile data from ImageJ
line_length = df_line['Distance_(mm)'].values # Length along the line profile
line_HU = df_line['Gray_Value'].values # HU values along the line profile  
avg_line_HU = -851.593 # Average HU from ImageJ

# Step 5: Average background intensity
bg_HU = -997.175 # Average HU from ImageJ

# Step 6: Subtract the background intensity from the intensity profile
# f_shift = f-mean(background)
bead_shift = line_HU - bg_HU
print(bead_shift)

# Step 7: Compute Fourier transform to estimate MTF 
# Discrete Fourier Transform (DFT): 
# F = abs(fft(f_shift))
# DC Component: value of the fourier ransform at the origin
# F = abs(fft(f_shit))/N where N = length(f_shift)
N = len(bead_shift)
F = np.fft.fft(bead_shift) / N
MTF_bead = np.abs(F) / np.abs(F[0]) # Normalize by the DC component

# Frequency vector 
# u_k = k/N * Sf where u_k is the k-th frequency component
# k = 0, 1,... (N-1)/2
# Sf = sampling frequency
pixel_spacing = line_length[1] - line_length[0] 
freq_bead = np.fft.fftfreq(N, pixel_spacing)

# Filter negative frequencies and MTF 
positive_mask = freq_bead >= 0
freq_bead = freq_bead[positive_mask]
MTF_bead = MTF_bead[positive_mask]

# -----------------------------------------
# Problem 4 Part A & B
# -----------------------------------------
# Frequency at which MTF drops to 0.1
# MTF Interpolation
target_MTF = 0.1
if target_MTF <= MTF_bead.max() and target_MTF >= MTF_bead.min() and target_MTF <= MTF_bead.max():
    target_freq = np.interp(target_MTF, MTF_bead[::-1], freq_bead[::-1])

plt.figure(figsize=(8, 6))
plt.plot(freq_bead, MTF_bead, 'bo-', linewidth=2, markersize=8)
plt.plot(target_freq, target_MTF, 'ro', markersize=10,
         label=f'MTF = {target_MTF} at {target_freq:.2f} lp/mm')
plt.xlim(0, 1.4)
plt.xlabel('Spatial Frequency (lp/cm)', fontsize=12)
plt.ylabel('MTF', fontsize=12)
plt.title('MTF vs Spatial Frequency', fontsize=14)
plt.legend()
plt.show()

# -----------------------------------------
# Problem 4 Part C
# -----------------------------------------
# Shifted line profile (background removed) given above
# Distance from the center of the bead
distance_from_center = line_length - line_length[N//2]

plt.figure(figsize=(10, 6))
plt.plot(distance_from_center, bead_shift, 'g-', linewidth=2.5)
plt.axhline(y=0, color='k', linestyle='--', alpha=0.5)
plt.xlabel('Distance from Center (mm)', fontsize=12)
plt.ylabel('Intensity (HU, background removed)', fontsize=12)
plt.title('Point Spread Function', fontsize=14)
plt.grid(True, alpha=0.3)
plt.show()

# -----------------------------------------
# Problem 4 Part D
# -----------------------------------------
# Full-Width-at-Half-Maximum (FWHM): width of the point spread function at half of its maximum value
max_val = np.max(bead_shift)
half_max = max_val / 2.0

# Find where the signal is above half maximum
above_half = bead_shift >= half_max
indices_above = np.where(above_half)[0]

# FWHM in mm
fwhm_mm = (indices_above[-1] - indices_above[0] + 1) * pixel_spacing
print(f"Full-Width-at-Half-Maximum: {fwhm_mm:.4f} mm")

# -----------------------------------------
# Problem 4 Part E
# -----------------------------------------
# Average value of shifted line profile and DC component
mean_shifted = np.mean(bead_shift)
dc_component = np.abs(F[0]) # DC component is the mean of the input signal
print(f"Average value of shifted line profile: {mean_shifted:.6f} HU")
print(f"DC component: {dc_component:.6f}")