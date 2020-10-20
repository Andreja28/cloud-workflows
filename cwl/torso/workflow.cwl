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
  preprocess:
    run: preprocessor/preprocess.cwl
    in:
      input-file: input-file
    out: [dat]

  pak:
    run: solver/solver.cwl
    in:
      dat: preprocess/dat
    out: [vtk]