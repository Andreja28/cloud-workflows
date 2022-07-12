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
    outputSource: pore-dens/pngs

steps:
  pore-dens:
    run: pore-dens.cwl
    in:
      input: input-file
      source: source
    out: [pngs]
