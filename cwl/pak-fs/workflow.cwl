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
  console-cad:
    run: cad/console-CAD.cwl
    in:
      input-file: input-file
    out: [dat,solverVersion]

  pak:
    run: PAK/pak.cwl
    in:
      dat: console-cad/dat
      solverVersion: console-cad/solverVersion
    out: [vtk]