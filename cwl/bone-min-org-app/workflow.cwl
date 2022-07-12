cwlVersion: v1.0
class: Workflow

inputs:
  input-file: File
  source: File[]

outputs:
  pngs:
    type: 
        type: array
        items: File
    outputSource: min-org/pngs

steps:
  min-org:
    run: min-org.cwl
    in:
      dat: input-file
    out: [pngs]
