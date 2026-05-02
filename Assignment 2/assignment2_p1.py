import pydicom 
import numpy as np
import matplotlib.pyplot as plt

# File path to the DIOCOM
file_path = 'CTA_hole_phantom.dcm'

# Read the DICOM file
dcm_data = pydicom.dcmread(file_path) 
dcm_data.pixel_array