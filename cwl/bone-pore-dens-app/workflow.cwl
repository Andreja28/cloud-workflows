#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["/home/andra/install/MATLAB/MATLAB_Production_Server/R2015a/bin/matlab", "-nodesktop", "-nosplash", "-r", "run BonePoreDensAPP.m;", "quit;"]

requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.input)
      - $(inputs.source)
inputs:
  input:
    type: File
  source:
    type: File[]
outputs:
  pngs:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.png"

