cwlVersion: v1.0
class: Workflow

inputs:
  zz: float
  nz: float
  vf2: float
  sz: float
  tz: float
  Emax: float
  source: File[]

outputs:
  pngs:
    type: 
        type: array
        items: File
    outputSource: baghdadite/pngs
  csv:
    type: 
        type: array
        items: File
    outputSource: baghdadite/csv

steps:
  baghdadite:
    run: baghdadite.cwl
    in:
        zz: zz
        nz: nz
        vf2: vf2
        sz: sz
        tz: tz
        Emax: Emax
        source: source
    out: [pngs,csv]
