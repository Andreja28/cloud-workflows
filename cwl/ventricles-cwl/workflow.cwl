class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerPull: andra28/ventricles:latest

inputs:
    input-file:
        type: File
        inputBinding:
            position: 1
outputs:
    res:
        type: File
        outputBinding:
            glob: output.stl