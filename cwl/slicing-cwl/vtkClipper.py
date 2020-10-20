from paraview.simple import *
from vtk.numpy_interface import dataset_adapter as dsa
import numpy as np
import sys

# input: 
# 1) input.txt - textual file with clipping direction (Cx,Cy,Cz) and number of slices (NSLICES)
# 2) one or more vtk files 

# output:
# for each of the input vtk files NSLICES vtk files are created
if len(sys.argv) < 3:
	print ("Usage:\n\tpvpython.exe vtkClipper.py input.txt FILE.vtk [more FILES.vtk...]\n")
	exit()
#
# read input file
# 
f = open(sys.argv[1], "r")
f.readline()
line = f.readline()
lst = [float(x) for x in line.split(' ')]
nslices = int(lst[-1])
clipping_vec = np.array(lst[:-1])
#  normalize vector 
clipping_vec = clipping_vec / np.linalg.norm(clipping_vec) 
f.close()
	
for arg in sys.argv[2:]:
	# read vtk file 
	input_vtk = LegacyVTKReader(FileNames=[arg])

	# coordinates of the model 
	vtk_data = servermanager.Fetch(input_vtk)
	vtk_dataset_adapter = dsa.WrapDataObject(vtk_data)
	coords = vtk_dataset_adapter.GetPoints()
	
	# find points of the model (start_point, end_point) 
	# which are in the direction of the clipping vector 
	# and farthest from the center	
	center = np.mean(coords, axis=0)
	tmp_vec = center + clipping_vec
	tmp_vec = tmp_vec / np.linalg.norm(tmp_vec)
	
	minTheta = 1e+10
	maxTheta = .0 
	start_point = end_point = coords[0] 
	dist_start = dist_end = np.linalg.norm(end_point-center)
	for point in coords[0:]:
	    # normalize point 
		curr_vec = (point-center) / np.linalg.norm(point-center)
		# calculate angle between tmp_vec and clipping_vec
		theta = np.arccos( np.dot(tmp_vec, curr_vec))
		if(theta < minTheta):
			dist_cur = np.linalg.norm(point-center)			
			if((dist_cur - dist_end) > -1e-6):
				end_point = point
				minTheta = theta
				dist_end = dist_cur
		if(theta > maxTheta):
			dist_cur = np.linalg.norm(point-center)
			if((dist_cur - dist_start) > -1e-6):
				start_point = point
				maxTheta = theta
				dist_start = dist_cur									
	
	# distance between two slices 
	dist = np.linalg.norm(end_point-start_point)
	dist = dist/(nslices+1)

	for iclip in range(nslices):
	    # create clip 
		clip = Clip(Input=input_vtk)
		clip.ClipType = 'Plane'
		clip.Scalars = ['POINTS']
		clip.ClipType.Origin = start_point + clipping_vec * dist * (iclip+1)
		clip.ClipType.Normal = clipping_vec
		if(iclip > 0):
			clip = Clip(Input=clip)
			clip.ClipType = 'Plane'
			clip.Scalars = ['POINTS']
			clip.ClipType.Origin = start_point + clipping_vec * dist * (iclip)
			clip.ClipType.Normal = -clipping_vec        

		# save vtk 
		SaveData(arg[:-4] + '-slice' + str(iclip+1) + '.vtk', proxy=clip)

