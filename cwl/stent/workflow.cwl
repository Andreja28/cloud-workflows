cwlVersion: v1.0
class: Workflow
inputs:
  input-file: File

outputs:
  res:
    type: 
        type: array
        items: File
    outputSource: pak-c/vtks

steps:
  console-stent:
    run: console-stent/console-stent.cwl
    in:
      fajl: input-file
    out: [dat]

  pak-c:
    run: pak-c/pak-c.cwl
    in:
      dat: console-stent/dat
    out: [vtks]