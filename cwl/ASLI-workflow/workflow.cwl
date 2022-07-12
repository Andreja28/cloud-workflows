cwlVersion: v1.0
class: Workflow

inputs:
  stl: File
  yml: File
  sap: File?
  tap: File?
  fap: File?


outputs:
  stl-out:
    type: 
        type: array
        items: File
    outputSource: asli/stl-out

steps:
  asli:
    run: asli.cwl
    in:
      stl: stl
      yml: yaml
      sap: sap
      tap: tap
      fap: fap
    out: [stl-out]
