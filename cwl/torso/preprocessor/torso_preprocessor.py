import sys 

input_file_name = sys.argv[1]
output_file_name = 'pakf.dat'
template_file_name = 'templates/template_pakf.dat'

replace_ecg_function_string = 'C replace ecg function here'
# line format: C /7/ DATA FOR NODAL POINT DATA (I5,5I5,3F10.6)
replace_nodes_string = 'C   N,    (ID(N,I),I=1,5)     CORD(1,N), CORD(2,N), CORD(3,N)'
outfile_ending = 'C /13/ DATA ABOUT BOUNDARY CONDITIONS - SURFACE TRACTIONS\nC  El.  n1   n2  fx,fy\nC /14/ STOP CARD (A4)\nSTOP'
nnodes_line_number = 8

# read input and template file 
input_file = open(input_file_name,'r')
template_file = open(template_file_name,'r')

input_lines = input_file.readlines()
template_lines = template_file.readlines()

input_file.close()
template_file.close()


# read scales 
scales = input_lines[1].split()
scalex = float(scales[0])
scaley = float(scales[1])
scalez = float(scales[2])
del input_lines[:2]

# read number of nodes 
nnodes = int(template_lines[nnodes_line_number].split()[0])
output_file = open(output_file_name,'w')

# copy lines from the template to the output file, up to node list 
nremove = 0 
for line in template_lines: 
    output_file.write(line)
    nremove += 1 
    if(replace_nodes_string in line):
        break
del template_lines[:nremove] 

# scale all coordinates in node list and print to the output file 
for inode in range(0, nnodes):
    line = template_lines[inode]
    data = line.split()
    node_index = int(data[0])
    node_constrains = [int(data[iconstr]) for iconstr in range(1,6)]
    coordx = float(data[6])*scalex 
    coordy = float(data[7])*scalex
    coordz = float(data[8])*scalex
    output_file.write('     %5d%5d%5d%5d%5d%5d%13.6f%13.6f%13.6f\n' % (node_index, node_constrains[0],
                      node_constrains[1],node_constrains[2],node_constrains[3], node_constrains[4],
                      coordx, coordy, coordz))
del template_lines[:nnodes]

# copy lines from the template to the output file, up to ECG function 
for line in template_lines: 
     output_file.write(line)
     if(replace_ecg_function_string in line):
        break 
del template_lines

input_lines = [line for line in input_lines if line!='\n']
output_file.writelines(input_lines)
if(input_lines[-1][-1] != '\n'):
    output_file.write('\n')
output_file.write(outfile_ending)
output_file.close()
