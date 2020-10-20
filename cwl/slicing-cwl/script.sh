cp /slicing/vtkClipper.py .

vtks=()

for vtk in "${@:2}"
do
    cp $vtk .
    vtks+=${vtk##*/}
done

pvpython vtkClipper.py $1 $vtks
