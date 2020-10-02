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
  unv:
    type: 
        type: array
        items: File
    outputSource: pak/unv
  unvs:
    type: 
        type: array
        items: File
    outputSource: pak/unvs

steps:
  preprocess:
    run: input-preprocess/preprocess.cwl
    in:
      input-file: input-file
    out: [dat,solverVersion]

  pak:
    run: PAK/pak.cwl
    in:
      dat: preprocess/dat
      solverVersion: preprocess/solverVersion
    out: [vtk, unvs, unv]