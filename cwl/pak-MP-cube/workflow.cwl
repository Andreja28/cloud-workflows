cwlVersion: v1.0
class: Workflow

inputs:
  Ca: File
  params: File

outputs:
  vtk:
    type: 
        type: array
        items: File
    outputSource: pak/vtk

steps:
  console-cad:
    run: cad/cad.cwl
    in:
      Ca: Ca
    out: [outputs]

  pak:
    run: PAK/pak.cwl
    in:
      cad: console-cad/outputs
      params: params
    out: [vtk]