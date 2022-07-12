cwlVersion: v1.0
class: Workflow

inputs:
  input-file: File

outputs:
  vtk:
    type: 
        type: array
        items: File
    outputSource: pak-athero/vtk

steps:
  pak-athero:
    run: pak-athero.cwl
    in:
      dat: input-file
    out: [vtk]
