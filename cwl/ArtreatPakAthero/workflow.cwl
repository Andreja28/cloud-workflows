cwlVersion: v1.0
class: Workflow

inputs:
  input-file: File

outputs:
  vtk:
    type: 
        type: array
        items: File
    outputSource: pak/vtk

steps:
  pak:
    run: pak-athero.cwl
    in:
      dat: input-file
    out: [vtk]
