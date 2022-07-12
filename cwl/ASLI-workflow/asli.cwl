#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["/bin/bash", "/asli/script.sh"]

hints:
  DockerRequirement:
    dockerPull: andra28/asli

requirements:
  InitialWorkDirRequirement:
    listing: 
      - $(inputs.stl)
      - $(inputs.yml)
      - $(inputs.sap)
      - $(inputs.tap)
      - $(inputs.fap)

inputs:
  stl:
    type: File
    inputBinding:
      position: 1
  yml:
    type: File
    inputBinding:
      position: 2
  sap:
    type: File?
  tap: 
    type: File?
  fap:
    type: File?

    
outputs:
  stl-out:
    type:
      type: array
      items: File
    outputBinding:
      glob: "outputs/*"

