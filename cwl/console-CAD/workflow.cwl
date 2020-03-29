cwlVersion: v1.0
class: Workflow
inputs:
  input-file: File

outputs:
  res:
    type: 
        type: array
        items: File
    outputSource: pak/vtks

steps:
  console-cad:
    run: console-CAD.cwl
    in:
      input-file: input-file
    out: [dat]

  pak:
    run: pak.cwl
    in:
      dat: console-cad/dat
    out: [vtks]