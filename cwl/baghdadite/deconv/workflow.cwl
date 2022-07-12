#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["/bin/bash", "start_script.sh"]

requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.source)
inputs:
  zz:
    type: float
    inputBinding:
      position: 1
  nz:
    type: float
    inputBinding:
      position: 2
  vf2:
    type: float
    inputBinding:
      position: 3
  sz:
    type: float
    inputBinding:
      position: 4
  tz:
    type: float
    inputBinding:
      position: 5
  Emax:
    type: float
    inputBinding:
      position: 6
  source:
    type: File[]
outputs:
  pngs:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.csv"

