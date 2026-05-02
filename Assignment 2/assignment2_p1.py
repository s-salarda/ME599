import pydicom 
import numpy as np
import matplotlib.pyplot as plt

# File path to the DIOCOM
file_path = 'path_to_your_dicom_file.dcm'

# Read the DICOM file
dicom_data = pydicom.dcmread(file_path) 
dcm.pixel_array